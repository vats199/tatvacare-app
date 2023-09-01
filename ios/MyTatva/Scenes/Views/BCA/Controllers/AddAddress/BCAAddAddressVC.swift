//
//  BCAAddAddressVC.swift
//  MyTatva
//
//  Created by Uttam patel on 12/06/23.
//

//

import UIKit

class BCAAddAddressVC: LightPurpleNavigationBase {
    
    //MARK:- Outlet
    @IBOutlet weak var vwDiclaimer              : UIView!
    @IBOutlet weak var lblDiclaimer             : UILabel!
    
    @IBOutlet weak var lblName                  : UILabel!
    @IBOutlet weak var lblMobile                : UILabel!
    @IBOutlet weak var lblPincode               : UILabel!
    @IBOutlet weak var lblHouseNumber           : UILabel!
    @IBOutlet weak var lblStreet                : UILabel!
    
    @IBOutlet weak var txtName                  : UITextField!
    @IBOutlet weak var txtMobile                : UITextField!
    @IBOutlet weak var txtPincode               : UITextField!
    @IBOutlet weak var txtHouseNumber           : UITextField!
    @IBOutlet weak var lblNote                  : UILabel!
    @IBOutlet weak var txtStreet                : UITextField!
    
    @IBOutlet weak var lblAdddressType          : UILabel!
    @IBOutlet weak var colAdddressType          : UICollectionView!
    
    @IBOutlet weak var btnSubmit                : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel               = BCAAddAddressVM()
    var object                          = LabAddressListModel()
    var isEdit                          = false
    var address_id                      = ""
    
    var completion:((LabAddressListModel) -> ())?
    
    var arrData : [JSON] = [
        [
            "name" : "Home",
            "value" : "Home",
            "key": AddressType.Home.rawValue,
            "image" : "home_address",
            "isSelected": 1,
            "type": "S"
        ],
        [
            "name" : "Work",
            "value" : "Work",
            "key": AddressType.Work.rawValue,
            "image" : "work_address",
            "isSelected": 0,
            "type": "I"
        ],
        [
            "name" : "Other",
            "value" : "Other",
            "key": AddressType.Other.rawValue,
            "image" : "other_address",
            "isSelected": 0,
            "type": "F"
        ]
    ]
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupViewModelObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        WebengageManager.shared.navigateScreenEvent(screen: .AddAddress)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .SetUpDrugs, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //FIRAnalytics.manageTimeSpent(on: .SetUpDrugs, when: .Disappear)
    }
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //------------------------------------------------------
    
    @IBAction func btnCancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        self.manageActionMethods()
        self.btnSubmit.setTitle("Save & Next", for: .normal)
        self.setData()
        
        DispatchQueue.main.async {
            
            self.btnSubmit.superview!.shadow(color: .themeGray, shadowOffset: .zero, shadowOpacity: 0.2)
            
//            if self.isEdit {
//                self.btnSubmit.setTitle(AppMessages.Update, for: .normal)
//                self.btnSkip.isHidden = true
//                self.viewModel.get_prescription_detailsAPI { (isDone, object, msg) in
//                    if isDone {
//                        self.objcet = object
//                        self.arrMedication = object.medicineData
//                        self.arrPrecription = object.documentData
//                        self.colMedication.reloadData()
//                        self.colPrecription.reloadData()
//                    }
//                }
//            }
        }
        
    }
    
    private func applyStyle() {
        self.lblNote
            .font(name: .medium, size: 12.0).textColor(color: .themeGray5)
            .text = "Minimum 25 characters required"
        self.lblDiclaimer
            .font(name: .regular, size: 13.0).textColor(color: .themeBlack.withAlphaComponent(0.8))
            .text = "Disclaimer: We need this information to deliver your product & for collecting test samples"
        self.lblName
            .font(name: .medium, size: 14).textColor(color: .themeBlack)
        self.lblMobile
            .font(name: .semibold, size: 14).textColor(color: .themeBlack)
        self.lblPincode
            .font(name: .medium, size: 14).textColor(color: .themeBlack)
        self.lblHouseNumber
            .font(name: .medium, size: 14).textColor(color: .themeBlack)
        self.lblStreet
            .font(name: .medium, size: 14).textColor(color: .themeBlack)
        self.lblAdddressType
            .font(name: .semibold, size: 14).textColor(color: .themeBlack)
        
        self.txtName.maxLength          = Validations.MaxCharacterLimit.Name.rawValue
//        self.txtName.regex              = Validations.RegexType.AlpabetsDotQuoteSpace.rawValue
        self.txtName.defaultcharacterSet    = CharacterSet.letters.union(CharacterSet(charactersIn: ".' "))
        self.txtName.keyboardType        = .default
        
        self.txtMobile.maxLength        = Validations.PhoneNumber.Maximum.rawValue
        self.txtMobile.regex            = Validations.RegexType.OnlyNumber.rawValue
        self.txtMobile.keyboardType     = .numberPad
        
        self.txtPincode.maxLength       = Validations.MaxCharacterLimit.Pincode.rawValue
        self.txtPincode.regex           = Validations.RegexType.OnlyNumber.rawValue
        self.txtPincode.keyboardType    = .numberPad
        self.txtHouseNumber.keyboardType = .asciiCapable
        self.txtStreet.keyboardType     = .asciiCapable
        
        self.txtHouseNumber.delegate = self
        self.txtStreet.delegate = self
//        self.txtHouseNumber.addTarget(self, action: #selector(didChangeText), for: .editingChanged)

        
        //self.txtHouseNumber.maxLength    = Validations.MaxCharacterLimit.Pincode.rawValue
        /*self.txtHouseNumber.regex        = Validations.RegexType.AlphaNumeric.rawValue
        self.txtHouseNumber.keyboardType = .default
        
        //self.txtHouseNumber.maxLength    = Validations.MaxCharacterLimit.Pincode.rawValue
        self.txtStreet.regex            = Validations.RegexType.AlphaNumeric.rawValue
        self.txtStreet.keyboardType     = .default*/
        
        self.btnSubmit.font(name: .bold, size: 15)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setup(collectionView: self.colAdddressType)
            self.vwDiclaimer.cornerRadius(cornerRadius: 20)
            self.btnSubmit.cornerRadius(cornerRadius: 16)
        }
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    /*@objc func didChangeText(field: UITextField) {
         if (field.text?.containsEmoji == true) {
            field.text = field.text?.minusEmojis
        }
    }*/
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    private func manageActionMethods(){
        
        self.btnSubmit.addTapGestureRecognizer {

            var addressType = ""
            for item in self.arrData {
                if item["isSelected"].intValue == 1 {
                    addressType = item["value"].stringValue
                }
            }
            
            self.viewModel.apiCall(vc: self,
                                   address_id: self.address_id,
                                   name: UserModel.shared.name,
                                   mobile: UserModel.shared.contactNo,
                                   pincode: self.txtPincode,
                                   houseNumber: self.txtHouseNumber,
                                   street: self.txtStreet,
                                   addressType: addressType,
                                   isEdit: self.isEdit)
        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension BCAAddAddressVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colAdddressType:
            return self.arrData.count
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        
        case self.colAdddressType:
            let cell : AddAddressTypeCell = collectionView.dequeueReusableCell(withClass: AddAddressTypeCell.self, for: indexPath)

            let obj                     = self.arrData[indexPath.item]
            cell.lblTitle.text          = obj["name"].stringValue
            cell.imgView.image = UIImage(named: "checkbox_gray")
            
            cell.vwBg.backGroundColor(color: UIColor.white)
            cell.lblTitle.font(name: .medium, size: 13)
                .textColor(color: UIColor.themeBlack)
            if obj["isSelected"].intValue == 1 {
                cell.imgView.image = UIImage(named: "checkbox_purple")
            } else {
                cell.imgView.image = UIImage(named: "checkbox_gray")
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colAdddressType:
            
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
            self.colAdddressType.reloadData()
            
            break
            
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colAdddressType:
            
            //let obj     = self.arrData[indexPath.item]
            //let width   = obj["name"].stringValue.width(withConstraintedHeight: 15.0, font: UIFont.customFont(ofType: .medium, withSize: 15.0)) + 66
            
            let width   = self.colAdddressType.frame.size.width / 3
            let height  = self.colAdddressType.frame.size.height
            
            return CGSize(width: width,
                          height: height)
       
        default:
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension BCAAddAddressVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.isContainsEmoji()
    }
    
    func setData(){
        if self.object.name != nil {
            self.txtName.text           = self.object.name
            self.txtMobile.text         = self.object.contactNo
            self.txtPincode.text        = "\(self.object.pincode!)"
            self.txtHouseNumber.text    = self.object.address
            self.txtStreet.text         = self.object.street
//            self.address_id             = self.object.patientAddressRelId
            
            for i in 0...self.arrData.count - 1 {
                var item = self.arrData[i]
                
                item["isSelected"].intValue = 0
                if item["value"].stringValue == self.object.addressType {
                    item["isSelected"].intValue = 1
                }
                self.arrData[i] = item
            }
            self.colAdddressType.reloadData()
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension BCAAddAddressVC {
    
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


