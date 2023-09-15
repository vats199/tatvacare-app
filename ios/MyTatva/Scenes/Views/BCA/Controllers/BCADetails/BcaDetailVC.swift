//
//  BcaDetailVC.swift
//  MyTatva
//
//  Created by Hyperlink on 09/05/23.
//  Copyright © 2023. All rights reserved.

import UIKit
import Lottie

class BcaDetailVC: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var svMain           : UIStackView!
    
    @IBOutlet weak var svDetails        : UIStackView!
    
    @IBOutlet weak var vwMainSync       : UIView!
    @IBOutlet weak var vwSyncingData    : UIView!
    @IBOutlet weak var imgGiF           : UIImageView!
    @IBOutlet weak var animationView    : LottieAnimationView!
    @IBOutlet weak var lblSyncingData   : UILabel!
    
    @IBOutlet weak var vwMainMeasure    : UIView!
    @IBOutlet weak var vwMeasure        : UIView!
    @IBOutlet weak var btnMeasure       : ThemePurpleBorderButton!
    
    @IBOutlet weak var vwLastSync       : UIView!
    @IBOutlet weak var imgRotate        : UIImageView!
    @IBOutlet weak var lblLastMeasured  : UILabel!
    @IBOutlet weak var lblNotice        : UILabel!
    
    @IBOutlet weak var btnDownload      : UIButton!
    @IBOutlet weak var lblVitals        : UILabel!
    
    @IBOutlet weak var vwVitals         : UIView!
    @IBOutlet weak var colBCAList       : UICollectionView!
    @IBOutlet weak var colHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var lblNavTitle: SemiBoldBlackTitle!
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: BcaDetailViewModel!
    var isFromHome = false
    var isBackToHome = false
    
    var count: Int = 20
    var timer: Timer? = nil
    
    var isMeasuredEnable = false {
        didSet {
            self.btnMeasure.font(name: .bold, size: 13.0).textColor(color: self.isMeasuredEnable ? .themePurple : .themeGray).borderColor(color: self.isMeasuredEnable ? .themePurple : .themeGray, borderWidth: 1.0).isUserInteractionEnabled = self.isMeasuredEnable
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        debugPrint("‼️‼️‼️ deinit of \(BcaDetailVC.self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.addObserverOnHeightTbl()
        self.applyStyle()
        self.setup(collectionView: self.colBCAList)
        self.configureUI()
        self.addGif()
    }
    
    private func applyStyle() {
        self.isMeasuredEnable = true
        self.svDetails.isHidden = self.isFromHome
        self.vwLastSync.isHidden = true
        self.vwVitals.isHidden = true
        
        if !self.isFromHome {
            self.vwLastSync.isHidden = false
            self.lblNotice.isHidden = false
            self.lblLastMeasured.superview?.isHidden = true
            if UserModel.shared.bcaSync != nil {
                self.viewModel.getBCAVitals()
            }
        } else {
            self.viewModel.getBCAVitals()
        }
        
        self.tabBarController?.tabBar.isHidden = true
        self.lblNavTitle.text = "Measure Health Markers"
        self.lblVitals
            .font(name: .bold, size: 17).textColor(color: .themeBlack.withAlphaComponent(1))
        self.lblLastMeasured
            .font(name: .light, size: 13).textColor(color: .themeBlack.withAlphaComponent(1))
            .text = "Last measured on 09 May 2023 , 03:58 PM"
        self.lblNotice
            .font(name: .light, size: 11).textColor(color: .themeRed.withAlphaComponent(1))
            .text = "NOTE : Pairing with Phone’s Bluetooth is not required"
        
        self.btnMeasure
            .font(name: .bold, size: 13)
        self.lblSyncingData
            .font(name: .medium, size: 13)
            .textColor(color: .themePurple).text = "Step up on scale and click on 'Measure'"
        
        self.navigationItem.rightBarButtonItems = nil
        
        self.btnMeasure.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            
            guard BleManager.shared.bleState.value == .poweredOn else {
                BleManager.shared.checkBTPermission()
                return
            }
            
            var params = [String:Any]()
            params[AnalyticsParameters.medical_device.rawValue] = kBCA
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKS_MEASURE,
                                     screen: .MeasureSmartScaleReadings,
                                     parameter: params)
            
            self.count = 20
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCountDown), userInfo: nil, repeats: true)
            self.animationView.play()
            self.isMeasuredEnable = false
            BleManager.shared.isFromMeasured = true
            BleManager.shared.connectToScaleSdk()
        }
                
    }
    
    @objc func updateCountDown() {
        self.count -= 1
        if(self.count <= 0) {
            if(self.timer != nil){
                self.count = -1
                self.timer!.invalidate()
                self.timer = nil
            }
            self.isMeasuredEnable = true
            self.animationView.stop()
            BleManager.shared.bleAPIState.value = (.CONNECTION_FAILED,nil)
            BleManager.shared.stopSDK()
        }
    }
    
    func configureUI(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwSyncingData.cornerRadius(cornerRadius: 12, clips: true).borderColor(color: UIColor.hexStringToUIColor(hex: "#F0F0F0"), borderWidth: 1).themeShadow()
        }
        self.svMain.setCustomSpacing(0, after: vwMainSync)
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func addGif() {
        let animation = LottieAnimation.named("Weigth_scale")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.animationView.animation          = animation
            self.animationView.backgroundColor    = .clear
            self.animationView.loopMode           = .loop
            self.animationView.autoresizingMask   = [.flexibleHeight, .flexibleWidth]
            self.animationView.contentMode        = .scaleAspectFit
            self.animationView.backgroundBehavior = .pauseAndRestore
            self.animationView.animationSpeed     = 1.5
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    @IBAction func btnBackTapped(_ sender: Any) {
        if self.isBackToHome {
            if let viewControllers = self.navigationController?.viewControllers {
                for vc in viewControllers {
                    // some process
                    if vc.isKind(of: HomeVC.self) {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = BcaDetailViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = true
        WebengageManager.shared.navigateScreenEvent(screen: .MeasureSmartScaleReadings)
        //        BleManager.shared.connectToScaleSdk()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BleManager.shared.isFromMeasured = false
    }
}


//MARK: -------------------------- UICollectionView Methods --------------------------
extension BcaDetailVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BcaListCell = collectionView.dequeueReusableCell(withClass: BcaListCell.self, for: indexPath)
        
        let object              = self.viewModel.cellForRow(index: indexPath.item)
        cell.setData(object: object)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.changeSelection(row: indexPath.row)
        
        var params = [String:Any]()
        let obj = self.viewModel.cellForRow(index: indexPath.item)
        params[AnalyticsParameters.medical_device.rawValue] = kBCA
        params[AnalyticsParameters.reading_id.rawValue] = obj.readingsMasterId
        params[AnalyticsParameters.reading_name.rawValue] = obj.readingName
        FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_DEVICE_READINGS,
                                 screen: .MeasureSmartScaleReadings,
                                 parameter: params)
        
        let vc = BcaVitalsDetailsVC.instantiate(fromAppStoryboard: .bca)
        vc.viewModel = self.viewModel
        vc.selectedIndex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
            
        case self.colBCAList:
            
            let width   = self.colBCAList.frame.size.width / 2
            let height  = width / 2
            
            return CGSize(width: width,
                          height: height + 10)
            
        default:
            
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
}

extension BcaDetailVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UICollectionView, obj == self.colBCAList, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.colHeightConstant.constant = newvalue.height
        }
        UIView.animate(withDuration: kAnimationSpeed) { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }
    }
    
    func addObserverOnHeightTbl() {
        self.colBCAList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let tblView = self.colBCAList else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    private func setupViewModelObserver() {
        BleManager.shared.bleAPIState.bind { [weak self] result in
            guard let self = self, let result = result else { return }
            self.lblSyncingData.text = result.0.rawValue
            guard let bcaReading = result.1 else { return }
            self.timer?.invalidate()
            self.isMeasuredEnable = true
            self.animationView.stop()
            self.viewModel.updateBCAReadings(bcaReading)
        }
        
        self.viewModel.isResult.bind { [weak self] lastSync in
            guard let self = self else { return }
            self.vwVitals.isHidden = false
            self.vwVitals.layoutIfNeeded()
            self.vwVitals.layoutSubviews()
            self.navigationItem.rightBarButtonItems = nil
            let btnPDFDownLoad = UIButton()
            btnPDFDownLoad.setImage(UIImage(named: "download_gray"), for: UIControl.State())
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btnPDFDownLoad)]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.colBCAList.reloadData()
            }
            
            if let lastSync = lastSync {
                self.vwLastSync.isHidden = false
                self.lblLastMeasured.superview?.isHidden = false
                self.lblNotice.isHidden = true
                self.lblLastMeasured.text = "Last measured on " + GFunction.shared.convertDateFormat(dt: lastSync, inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue, outputFormat: DateTimeFormaterEnum.ddMMMYYYYhhmma.rawValue, status: .NOCONVERSION).str
            }
            
            btnPDFDownLoad.addAction(for: .touchUpInside) { [weak self] in
                guard let self = self else { return }
                self.viewModel.downloadBCAPDF()
            }
            
        }
        
    }
    
}
