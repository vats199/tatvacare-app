//
//  BcaVitalsDetailsVC.swift
//  MyTatva
//
//  Created by Hyperlink on 10/05/23.
//  Copyright © 2023. All rights reserved.

import UIKit

class BcaVitalsDetailsVC: UIViewController {
    
    //MARK: Outlet
    
    @IBOutlet weak var colTitles        : UICollectionView!
    @IBOutlet weak var vwContainer      : CommonPageView!
    
    //------------------------------------------------------
    
    //MARK: Class Variable
    
    var viewModel: BcaDetailViewModel!
    var selectedIndex: Int = 0 {
        didSet {
            /*self.colTitles.scrollToItem(at: IndexPath(row: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
             self.vwContainer.setViewController(index: self.selectedIndex)*/
        }
    }
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit of \(BcaVitalsDetailsVC.self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK: Custom Method
    
    private func setUpView() {
        self.applyStyle()
        self.setup(collectionView: self.colTitles)
        self.setPageControler()
        
        /*DispatchQueue.main.async { [weak self] in
         guard let self = self else { return }
         self.selectedIndex = self.viewModel.getSelectedIndex()
         }*/
        
    }
    
    private func applyStyle() {
        
    }
    
    func setPageControler() {
        self.vwContainer.setUpView()
        self.vwContainer.arrViewController = self.viewModel.getVitalControllers()
        self.vwContainer.setScroll()
        self.vwContainer.delegate = self
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.colTitles.scrollToItem(at: IndexPath(row: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
            self.vwContainer.setViewController(index: self.selectedIndex,isAnimated: false)
        }
        
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: Action Method
    
    //------------------------------------------------------
    
    //MARK: Life Cycle Method
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = BcaDetailViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

//------------------------------------------------------
//MARK: - CommonPageDelegate
extension BcaVitalsDetailsVC: CommonPageProtocol {
    func scrollingDidEnd(index: Int) {
        self.selectedIndex = index
    }
}
//MARK: -------------------------- UICollectionView Methods --------------------------
extension BcaVitalsDetailsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BCATitleCell = collectionView.dequeueReusableCell(withClass: BCATitleCell.self, for: indexPath)
        
        let object              = self.viewModel.cellForRow(index: indexPath.item)
        cell.setData(object: object)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewModel.numberOfRow() > 0 else { return }
        self.viewModel.changeSelection(row: indexPath.row)
        self.selectedIndex = indexPath.row
        self.colTitles.reloadData()
        self.colTitles.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.vwContainer.setViewController(index: self.selectedIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
            
        case self.colTitles:
            
            let width   = self.viewModel.cellForRow(index: indexPath.row).formattedReadingName.widthOfString(usingFont: .customFont(ofType: .medium, withSize: 13)) + 20
            let height  = collectionView.frame.height
            
            return CGSize(width: width,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
}
