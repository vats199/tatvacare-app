//
//  ChronicConditionsVC.swift
//  MyTatva
//
//  Created by 2022M43 on 04/07/23.
//

import Foundation
import UIKit

class ChronicConditionsCell: UICollectionViewCell {
    
    @IBOutlet weak var imgConditionImage: UIImageView!
    @IBOutlet weak var lblConditionName: UILabel!
    @IBOutlet weak var vwBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    func applyStyle() {
        self.lblConditionName.font(name: .semibold, size: 12).textColor(color: .themeGray4)
        self.vwBG.borderColor(color: .ThemeGrayE0, borderWidth: 1).cornerRadius = 16
    }
}

class ChronicConditionsVC: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var colConditions: UICollectionView!
    @IBOutlet weak var constColConditionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwBtn: UIView!
    @IBOutlet weak var vwOther: UIView!
    @IBOutlet weak var vwTextField: UIView!
    
    @IBOutlet weak var btnFinish: UIButton!
    
    @IBOutlet weak var lblOtherTitle: UILabel!
    
    @IBOutlet weak var txtOther: UITextField!
    
    @IBOutlet weak var scrollMain: UIScrollView!
    //------------------------------------------------------
    //MARK: - Class Variables -
    let viewModel = ChronicConditionsVM()
    var isBackShown = false
    var isToRoot = false
    
    var isOptionSelect = false {
        didSet {
            self.btnFinish.backGroundColor(color: isOptionSelect ? .themePurple : .themePurple.withAlphaComponent(0.5)).textColor(color: isOptionSelect ? .white : .themeGray5.withAlphaComponent(0.5)).borderColor(color: isOptionSelect ? .themePurple : .themeGray5.withAlphaComponent(0.5))
            
        }
    }
    var selectedCondition = MedicalConditionListModel()
    
    //------------------------------------------------------
    //MARK: - UIView Life Cycle Methods -
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.manageActionMethods()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.ApiConditionList(withLoader: false) { isSuccess in
            if isSuccess {
                self.colConditions.reloadData()
                self.setData()
            }
        }
        self.navigationController?.isNavigationBarHidden = !self.isBackShown
    }
    //------------------------------------------------------
    
    override func popViewController(sender: AnyObject) {
        if self.isToRoot {
            if let viewControllers = self.navigationController?.viewControllers {
                for vc in viewControllers {
                    // some process
                    if vc.isKind(of: EnterMobileViewPopUp.self) {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    //MARK: - Memory Management Method -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightCol()
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    //MARK: - Custome Methods -
    func setUpView() {
        self.applyStyle()
        self.addObserverOnHeightCol()
        self.colConditions.delegate = self
        self.colConditions.dataSource = self
    }
    
    func applyStyle() {
        
        self.vwOther.isHidden = true
        
        self.lblTitle.font(name: .bold, size: 20).textColor(color: .themeBlack2)
            .text = "Which chronic condition are you diagnosed with? "
        
        self.lblSubTitle.font(name: .regular, size: 14).textColor(color: .themeGray5)
            .text = "Choose the condition you need help with and get the support you deserve."
        
        self.btnFinish.cornerRadius(cornerRadius: 16).borderColor(color: .themeGray5.withAlphaComponent(0.5)).backGroundColor(color: .themeGray5.withAlphaComponent(0.03))
        self.btnFinish.font(name: .bold, size: 16).textColor(color: .themeGray5.withAlphaComponent(0.5))
        
        //self.vwTextField.borderColor(color: .ThemeGrayE0, borderWidth: 1).cornerRadius = 12
        self.lblOtherTitle.font(name: .bold, size: 14).textColor(color: .themeGray4)
            .text = "Please provide condition (Optional)"
        self.lblOtherTitle.setAttributesForOptional(str: "Please provide condition")
        self.txtOther.delegate = self
        
        self.btnFinish.isEnabled = false
        

        self.vwTextField.cornerRadius(cornerRadius: 12.0).borderColor(color: .themeBorder2).themeTextFieldShadow()
    }
    
    //MARK: - Button Action Methods -
    func manageActionMethods() {
        self.btnFinish.addAction(for: .touchUpInside) { [weak self] in
            guard let self = self else { return }
            self.viewModel.apiAddDetails(other_condition: self.txtOther.text!,medical_condition_ids: [self.selectedCondition])
        }
    }
    
    private func setupViewModelObserver() {
        self.viewModel.isResult.bind { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                
                FIRAnalytics.FIRLogEvent(eventName: .USER_SIGNUP_COMPLETE,
                                         screen: .AddAccountDetails,
                                         parameter: nil)
                UIApplication.shared.manageLogin()
                break
            case .failure(let error):
//                Alert.shared.showSnackBar(error.localizedDescription)
                Alert.shared.showSnackBar(error.localizedDescription, isError: true, isBCP: true)
                break
            case .none: break
            }
        }
    }
    
    func setData() {
        
        UserModel.shared.retrieveUserData()
        let userData = UserModel.shared
        
        if userData.medicalConditionGroupId.trim() != "" {
            self.selectedCondition.medicalConditionName      = userData.indicationName
            self.selectedCondition.medicalConditionGroupId   = userData.medicalConditionGroupId
            self.colConditions.isUserInteractionEnabled = false
            let selectedValue = self.viewModel.arrList.firstIndex(where: { $0.medicalConditionGroupId == userData.medicalConditionGroupId })
            self.viewModel.arrList[selectedValue ?? 0].isSelected = true
            self.colConditions.reloadData()
            self.isOptionSelect = true
            self.btnFinish.isEnabled = true
        }
    }
}

//MARK: - UICollectionview DataSource & Delegate -
extension ChronicConditionsVC: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ChronicConditionsCell = collectionView.dequeueReusableCell(withClass: ChronicConditionsCell.self, for: indexPath)
        let selectedValue = self.viewModel.listOfRow(indexPath.row).isSelected
        cell.lblConditionName.text = self.viewModel.listOfRow(indexPath.row).medicalConditionName
        cell.vwBG.backgroundColor = selectedValue ? .themeLightPurple.withAlphaComponent(0.08) : .white
        cell.vwBG.borderColor = selectedValue ? .black : .ThemeGrayE0
        cell.lblConditionName.font(name: .semibold, size: 12).textColor(color: selectedValue ? .themeBlack2 : .themeGray4)
        cell.imgConditionImage.setCustomImage(with: self.viewModel.listOfRow(indexPath.row).isSelected ? self.viewModel.listOfRow(indexPath.row).selectedImage : self.viewModel.listOfRow(indexPath.row).unselectedImage)
        cell.vwBG.applyViewShadow(shadowOffset: .zero, shadowColor: self.viewModel.listOfRow(indexPath.row).isSelected ? .clear : .themeBlack2.withAlphaComponent(0.3), shadowOpacity: 0.3, shdowRadious: 5)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: (self.colConditions.frame.size.width / 3), height: (85 * (ScreenSize.heightAspectRatio)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isOptionSelect = true
        self.btnFinish.isEnabled = true
        self.viewModel.didSelectect(indexPath.row)
        self.vwOther.isHidden = self.viewModel.listOfRow(indexPath.row).isOther == "Yes" ? false : true
        self.selectedCondition = self.viewModel.listOfRow(indexPath.row)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if self.viewModel.listOfRow(indexPath.row).isOther == "Yes" {
                self.scrollMain.scrollToBottom()
            }
        }
        self.colConditions.reloadData()
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension ChronicConditionsVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UICollectionView, obj == self.colConditions, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.constColConditionHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightCol() {
        self.colConditions.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightCol() {
        self.colConditions.removeObserver(self, forKeyPath: "contentSize")
    }
}


//===========================================================================

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension ChronicConditionsVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.txtOther :
            self.vwTextField.borderColor(color: .themePurpleBlack)
            break
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.txtOther :
            self.vwTextField.borderColor(color: self.txtOther.text!.isEmpty ? UIColor.themeBorder2 : UIColor.themePurpleBlack)
        default:
            break
        }
    }
    
}
