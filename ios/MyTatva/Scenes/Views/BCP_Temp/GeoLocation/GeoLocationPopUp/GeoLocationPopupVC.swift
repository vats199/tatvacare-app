//
//  GeoLocationPopupVC.swift
//  MyTatva
//
//  Created by Uttam patel on 29/08/23.
//

import Foundation
import UIKit

public final class ContentSizedScrollView: UIScrollView {
    override public var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return self.contentSize
    }
}


class GeoLocationPopupVC: UIViewController {
    //MARK: - Outlets -
    
    @IBOutlet var constVWTopGreaterOrEqual: NSLayoutConstraint!
    @IBOutlet var constVWTopEqual: NSLayoutConstraint!
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var vwBG: UIView!
    @IBOutlet weak var imgTopLine: UIImageView!
    @IBOutlet weak var imgLine: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    
    //----------------- Disclaimer -------------------
    @IBOutlet weak var vwDisclaimer: UIView!
    @IBOutlet weak var lblDisclaimer: UILabel!
    
    //----------------- Pincode -------------------
    @IBOutlet weak var vwPincode: UIView!
    @IBOutlet weak var txtPincode: ThemeFloatingTextField!
    
    //----------------- Button Save -------------------
    @IBOutlet weak var vwBtnSave: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    //----------------- Address Type -------------------
    @IBOutlet weak var vwAddressType: UIView!
    @IBOutlet weak var lblAddressType: UILabel!
    @IBOutlet weak var colAddress: UICollectionView!
    
    //----------------- Street Name -------------------
    @IBOutlet weak var vwStreetName: UIView!
    @IBOutlet weak var txtStreetName: ThemeFloatingTextField!
    
    //----------------- Address -------------------
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet weak var txtAddress: ThemeFloatingTextField!
    
    
    @IBOutlet weak var vwErrorPincode: UIView!
    @IBOutlet weak var lblEroorPincode: UILabel!
    @IBOutlet weak var vwErrorAddress: UIView!
    @IBOutlet weak var lblEroorAddress: UILabel!
    @IBOutlet weak var vwErrorStreeName: UIView!
    @IBOutlet weak var lblEroorStreeName: UILabel!
    @IBOutlet weak var constBottom: NSLayoutConstraint!
    
    //    @IBOutlet weak var scrlView: ContentSizedScrollView!
    @IBOutlet var constSaveTop: NSLayoutConstraint!
    
    //MARK: - Class Variables -
    
    var complition: (() -> Void)?
    
    var inputs: [UITextField] {
        get {
            return [txtPincode, txtAddress, txtStreetName]
        }
    }
    
    var arrData : [JSON] = [
        [
            "name" : "Home",
            "value" : "Home",
            "key": AddressType1.Home.rawValue,
            "image" : "home_address",
            "isSelected": 1,
            "type": "S"
        ],
        [
            "name" : "Office",
            "value" : "Work",
            "key": AddressType1.Office.rawValue,
            "image" : "office_address",
            "isSelected": 0,
            "type": "I"
        ],
        [
            "name" : "Other",
            "value" : "Other",
            "key": AddressType1.Other.rawValue,
            "image" : "other_address",
            "isSelected": 0,
            "type": "F"
        ]
    ]
    
    let viewModel = GeoLocationPopupVM()
    var completion:((LabAddressListModel) -> ())?
    var isEdit                          = false
    var address_id                      = ""
    var locationData : locationData? = nil
    
    //MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setData()
        self.applyStyle()
        self.checkEnableForInputs(textFields: inputs)
    }
    
    //------------------------------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupEvents(events: .SHOW_BOTTOM_SHEET)
        self.navigationController?.isNavigationBarHidden = true
        self.constVWTopEqual.isActive = false
        self.constVWTopGreaterOrEqual.isActive = true
//        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        IQKeyboardManager.shared.enableAutoToolbar = true
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    //------------------------------------------------------------------------------------------
    
    
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------------------------------------------
    
    //MARK: - Custom Functions -
    
    func setup() {
        self.setupViewModelObserver()
        self.colAddress.delegate = self
        self.colAddress.dataSource = self
        
        self.txtPincode.delegate = self
        self.txtAddress.delegate = self
        self.txtStreetName.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmissVC))
        tapGesture.numberOfTapsRequired = 1
        self.imgBG.isUserInteractionEnabled = true
        self.imgBG.addGestureRecognizer(tapGesture)
        
        self.txtStreetName.keyboardDistanceFromTextField = 75
        self.txtAddress.keyboardDistanceFromTextField = 75
        self.constVWTopEqual.constant = 40
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getKeyboardHeight), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        self.constScrollViewHeight.isActive = false
        self.constSaveTop.constant = 16
        
        self.txtStreetName.becomeFirstResponder()
        
        DispatchQueue.main.async {
            
//            self.constScrollViewHeight.isActive = true
//            self.constScrollViewHeight.constant = self.scrlView.intrinsicContentSize.height
            self.constVWTopEqual.isActive = false
            self.constVWTopGreaterOrEqual.isActive = true
            
            self.view.endEditing(true)
            self.vwErrorStreeName.isHidden = true
            
            self.vwBG.layoutIfNeeded()
            self.vwBG.layoutSubviews()
        }
        
    }
    
    @objc func getKeyboardHeight(_ notification: Notification) {
        
        DispatchQueue.main.async {
            
            self.constVWTopEqual.isActive = true
            self.constVWTopGreaterOrEqual.isActive = false
            self.constSaveTop.constant = 0
            
            self.vwBG.layoutIfNeeded()
            self.vwBG.layoutSubviews()
        }
                
        /*guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        self.constBottom.constant = keyboardHeight*/
        
        /*if let keyBoardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyBoardRectangle = keyBoardFrame.cgRectValue
            let keyBoardHeight = keyBoardRectangle.height
            self.constBottom.constant = (keyBoardHeight / 3) + 8// DeviceDetail.shared.hasNotch ? keyBoardHeight - 34 : keyBoardHeight
        }*/
        
    }
    
    @objc func hideKeyBoard(_ notification: Notification) {
        
        DispatchQueue.main.async {
            
            self.constVWTopEqual.isActive = false
            self.constVWTopGreaterOrEqual.isActive = true
            self.constSaveTop.constant = 16
            
            self.vwBG.layoutIfNeeded()
            self.vwBG.layoutSubviews()
        }
        
        /*if let keyBoardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyBoardRectangle = keyBoardFrame.cgRectValue
            _ = keyBoardRectangle.height
            self.constBottom.constant = 8 // keyBoardHeight
        }*/
        
    }
    
    //------------------------------------------------------------------------------------------
    
    func applyStyle() {
        DispatchQueue.main.async { [weak self]  in
            guard let self = self else {return}
            self.vwBG.layoutIfNeeded()
            self.vwBG.roundCorners([.topLeft, .topRight], radius: 20)
            self.imgTopLine.setRound()
        }
        
        self.vwPincode.cornerRadius(cornerRadius: 12.0).borderColor(color: .themeBorder2).themeTextFieldShadow()
        self.vwAddress.cornerRadius(cornerRadius: 12.0).borderColor(color: .themeBorder2).themeTextFieldShadow()
        self.vwStreetName.cornerRadius(cornerRadius: 12.0).borderColor(color: .themeBorder2).themeTextFieldShadow()
        
        self.imgTopLine.backGroundColor(color: .ThemeGrayE0)
        self.lblHeader.font(name: .bold, size: 20).textColor(color: .themeBlack3).text = "Enter Address"
        self.lblAddressType.font(name: .bold, size: 14).textColor(color: .themeBlack2).text = "Address Type"
        self.imgLine.backGroundColor(color: .themeLightGray)
        self.vwDisclaimer.cornerRadius(cornerRadius: 16).borderColor(color: .themeLightGray)
        self.lblDisclaimer.font(name: .regular, size: 12)
            .textColor(color: .themeGray4).text = "Disclaimer: We need this information to deliver your product & for collecting test samples"
        
        self.btnSave.cornerRadius(cornerRadius: 16).backGroundColor(color: .themeGray4).font(name: .bold, size: 16).textColor(color: .white).setTitle("Save Address", for: .normal)
        
        //        self.txtPincode.maxLength       = Validations.MaxCharacterLimit.Pincode.rawValue
        //        self.txtPincode.regex           = Validations.RegexType.OnlyNumber.rawValue
        self.txtPincode.keyboardType    = .numberPad
        self.txtAddress.keyboardType    = .asciiCapable
        self.txtStreetName.keyboardType = .asciiCapable
        
        //        let vc = GeoLocationPopupVC.instantiate(fromAppStoryboard: .BCP_temp)
        //        let navController = UINavigationController(rootViewController: vc) //Add navigation controller
        //        navController.modalPresentationStyle = .overFullScreen
        //        navController.modalTransitionStyle = .crossDissolve
        //        self.present(navController, animated: true, completion: nil)
        
        self.vwErrorPincode.isHidden = true
        self.vwErrorAddress.isHidden = true
        self.vwErrorStreeName.isHidden = true
        
        self.lblEroorPincode.font(name: .regular, size: 12).textColor(color: .themeRedAlert)
        self.lblEroorAddress.font(name: .regular, size: 12).textColor(color: .themeRedAlert)
        self.lblEroorStreeName.font(name: .regular, size: 12).textColor(color: .themeRedAlert)
        
    }
    
    private func setupEvents(events: FIREventType) {
        var params              = [String : Any]()
        params[AnalyticsParameters.bottom_sheet_name.rawValue]            = BottomScreenName.enter_address.rawValue
        FIRAnalytics.FIRLogEvent(eventName: events,
                                 screen: .EnterAddress,
                                 parameter: params)
    }
    
    //------------------------------------------------------------------------------------------
    
    @objc  func dissmissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkEnableForInputs(textFields: [UITextField]) {
        textFields.forEach { (input) -> Void in
            input.addAction(for: .allEditingEvents) {
                self.validateForEnable()
            }
        }
    }
    
    func validateForEnable() {
        self.btnSave.isEnabled = false
        self.btnSave.backGroundColor(color: .themeGray4)
        
        if inputs.first(where: { $0.text!.trim().isEmpty }) != nil {
            return
        }
        self.btnSave.isEnabled = true
        self.btnSave.backGroundColor(color: .themePurple)
    }
    
    func setData() {
        if self.locationData != nil {
            self.txtPincode.isUserInteractionEnabled = false
            self.txtPincode.text = self.locationData?.pinCode
            self.txtAddress.text = self.locationData?.fullAddress
            
            self.txtPincode.backgroundColor = .clear
            self.txtAddress.backgroundColor = .clear
            
            DispatchQueue.main.async {
                self.vwPincode.backGroundColor(color: .themeBorder2).borderColor(color: .themeLightGaryBorder, borderWidth: 1)
                self.vwAddress.borderColor(color: self.locationData?.fullAddress == "" ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            }
            
            if self.isEdit {
                self.txtStreetName.text = self.locationData?.streetName
                self.txtStreetName.backgroundColor = .clear
                
                DispatchQueue.main.async {
                    self.vwStreetName.borderColor(color: self.locationData?.fullAddress == "" ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
                }
                self.address_id = self.locationData?.patientAddressRelationId ?? ""
                if !(self.locationData?.addressType ?? "").isEmpty {
                    self.arrData = self.arrData.map({ obj in
                        var tmp = obj
                        tmp["isSelected"] = tmp["value"].stringValue == self.locationData?.addressType ? "1" : "0"
                        return tmp
                    })
                    self.colAddress.reloadData()
                }
            }
            
            self.validateForEnable()
            
        }
    }
    
    //MARK: - Button Action Methods -
    
    @IBAction func btnDownSheetTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //------------------------------------------------------------------------------------------
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        var addressType = ""
        for item in self.arrData {
            if item["isSelected"].intValue == 1 {
                addressType = item["value"].stringValue
            }
        }
        
        var params              = [String : Any]()
        params[AnalyticsParameters.bottom_sheet_name.rawValue]            = BottomScreenName.enter_address.rawValue
        params[AnalyticsParameters.address_type.rawValue]                 = addressType
        FIRAnalytics.FIRLogEvent(eventName: .TAP_SAVE_ADDRESS,
                                 screen: .EnterAddress,
                                 parameter: params)
        
        self.viewModel.apiCall(vc: self,
                               address_id: self.address_id,
                               name: UserModel.shared.name,
                               mobile: UserModel.shared.contactNo,
                               pincode: self.txtPincode,
                               houseNumber: self.txtAddress,
                               street: self.txtStreetName,
                               addressType: addressType,
                               isEdit: self.isEdit, latitude: self.locationData?.latitude ?? "", longitude: self.locationData?.longitude ?? "")
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension GeoLocationPopupVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(let newAddress):
                
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self, let newAddress = newAddress else { return }
                    self.completion?(newAddress)
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true, isBCP: true)
                
            case .none: break
            }
        })
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension GeoLocationPopupVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case self.colAddress:
            return self.arrData.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case self.colAddress:
            let cell : AddAddressTypeCell = collectionView.dequeueReusableCell(withClass: AddAddressTypeCell.self, for: indexPath)
            
            let obj                     = self.arrData[indexPath.item]
            cell.lblTitle.text          = obj["name"].stringValue
            cell.imgView.image = UIImage(named: "ic_deselectAddress")
            
            cell.vwBg.backGroundColor(color: UIColor.white)
            cell.lblTitle.font(name: .regular, size: 14)
                .textColor(color: UIColor.themeGray4)
            if obj["isSelected"].intValue == 1 {
                cell.imgView.image = UIImage(named: "ic_selectAddress")
                cell.lblTitle.textColor(color: UIColor.themeBlack3)
            } else {
                cell.imgView.image = UIImage(named: "ic_deselectAddress")
                cell.lblTitle.textColor(color: UIColor.themeGray4)
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case self.colAddress:
            
            let obj                  = self.arrData[indexPath.item]
            for i in 0...self.arrData.count - 1 {
                var object          = self.arrData[i]
                if object["name"].stringValue == obj["name"].stringValue {
                    object["isSelected"].intValue = 1
                }
                else {
                    object["isSelected"].intValue = 0
                }
                self.arrData[i] = object
            }
            self.colAddress.reloadData()
            
            break
            
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
            
        case self.colAddress:
            
            //let obj     = self.arrData[indexPath.item]
            //let width   = obj["name"].stringValue.width(withConstraintedHeight: 15.0, font: UIFont.customFont(ofType: .medium, withSize: 15.0)) + 66
            
            let width   = self.colAddress.frame.size.width / 3
            let height  = self.colAddress.frame.size.height
            
            return CGSize(width: width,
                          height: height)
            
        default:
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension GeoLocationPopupVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        DispatchQueue.main.async {
            self.vwBG.layoutIfNeeded()
            self.vwBG.layoutSubviews()
        }
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            guard let self = self else { return }
            IQKeyboardManager.shared.enableAutoToolbar = true
        }*/
        
        switch textField {
            
        case self.txtPincode:
            self.vwErrorPincode.isHidden = true
            if range.location >= 6 {
                return false
            } else {
                let allowedCharacters = "1234567890"
                let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                let typedCharacterSet = CharacterSet(charactersIn: string)
                let number = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                return number
                
            }
            break
        case self.txtAddress:
            let str = (string.isBackspace() ? String(textField.text!.dropLast()) : textField.text! + string)
            self.vwErrorAddress.isHidden = str.count >= 25 ? true : false
            self.lblEroorAddress.text = AppError.validation(type: .enterValidHouseNumber).errorDescription
//            self.vwErrorAddress.isHidden = true
            break
        case self.txtStreetName:
            self.vwErrorStreeName.isHidden = true
            
            break
        default:
            break
        }
                
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case self.txtPincode :
            self.vwPincode.borderColor(color: .themeLightGaryBorder)
            break
        case self.txtAddress :
            self.vwAddress.borderColor(color: .themePurpleBlack)
//            self.vwErrorAddress.isHidden = true
            
            break
        case self.txtStreetName :
            self.vwStreetName.borderColor(color: .themePurpleBlack)
//            self.vwErrorStreeName.isHidden = true
            break
            
        default:
            break
        }
        
        //  self.scrlView.setContentOffset(CGPoint(x: 0, y: (textField.superview?.frame.origin.y)! + 60), animated: true)
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
            
        case self.txtPincode :
            self.vwErrorPincode.isHidden = textField.text!.isEmpty ? false : true
            self.lblEroorPincode.text = AppError.validation(type: .enterPincode).errorDescription
            self.vwPincode.borderColor(color: self.txtPincode.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themeLightGaryBorder)
            break
        case self.txtAddress :
            if textField.text == ""  {
                self.vwErrorAddress.isHidden = textField.text!.isEmpty  ? false : true
                self.lblEroorAddress.text = AppError.validation(type: .enterHouseFullAddress).errorDescription
                self.vwAddress.borderColor(color: self.txtAddress.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            } else {
                self.vwErrorAddress.isHidden = textField.text!.count >= 25 ? true : false
                self.lblEroorAddress.text = AppError.validation(type: .enterValidHouseNumber).errorDescription
                self.vwAddress.borderColor(color: self.txtAddress.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            }
            break
        case self.txtStreetName :
            self.vwErrorStreeName.isHidden = textField.text!.isEmpty  ? false : true
            self.lblEroorStreeName.text = AppError.validation(type: .enterStreet).errorDescription
            self.vwStreetName.borderColor(color: self.txtStreetName.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
            break
        default:
            break
        }
        
        // self.scrlView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            guard let self = self else { return }
            self.vwBG.layoutIfNeeded()
            self.vwBG.layoutSubviews()
        }
        
    }
}
