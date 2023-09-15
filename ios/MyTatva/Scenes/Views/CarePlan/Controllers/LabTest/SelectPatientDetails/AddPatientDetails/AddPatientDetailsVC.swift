//

import UIKit

class AddPatientDetailsVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblName                  : UILabel!
    @IBOutlet weak var lblAge                   : UILabel!
    @IBOutlet weak var lblEmail                 : UILabel!
    @IBOutlet weak var lblEmailMsg              : UILabel!
    @IBOutlet weak var lblRelation              : UILabel!
    @IBOutlet weak var lblRelationMsg           : UILabel!
    
    @IBOutlet weak var txtName                  : UITextField!
    @IBOutlet weak var txtAge                   : UITextField!
    @IBOutlet weak var txtEmail                 : UITextField!
    @IBOutlet weak var txtRelation              : UITextField!
    
    @IBOutlet weak var lblGender                : UILabel!
    @IBOutlet weak var colGender                : UICollectionView!
    @IBOutlet weak var sgGender                 : UISegmentedControl!
    
    @IBOutlet weak var btnSubmit                : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel               = AddPatientDetailsVM()
    var isEdit                          = false
    var member_id                       = ""
    let pickerRelation                  = UIPickerView()
    var strSelectedGender               = ""
    var arrGender : [JSON] = [
        [
            "name" : "Male",
            "image" : "home_address",
            "key": GenderType.Male.rawValue,
            "isSelected": 1,
            "type": "S"
        ],
        [
            "name" : "Female",
            "image" : "work_address",
            "key": GenderType.Female.rawValue,
            "isSelected": 0,
            "type": "I"
        ],
//        [
//            "name" : "Prefer not to say",
//            "image" : "work_address",
//            "key": GenderType.Other.rawValue,
//            "isSelected": 0,
//            "type": "I"
//        ]
    ]
    
    var arrRelation : [JSON] = [
        [
            "name" : "Self",
            "key": RelationType.WithSelf.rawValue,
            "isSelected": 0,
        ],
        [
            "name" : "Spouse",
            "key": RelationType.Spouse.rawValue,
            "isSelected": 0,
        ],
        [
            "name" : "Parent",
            "key": RelationType.Parent.rawValue,
            "isSelected": 0,
        ],
        [
            "name" : "Sibling",
            "key": RelationType.Sibling.rawValue,
            "isSelected": 0,
        ],
        [
            "name" : "Child",
            "key": RelationType.Child.rawValue,
            "isSelected": 0,
        ],
        [
            "name" : "Other",
            "key": RelationType.Other.rawValue,
            "isSelected": 0,
        ]
    ]
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupViewModelObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        WebengageManager.shared.navigateScreenEvent(screen: .AddPatientDetails)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .SetUpDrugs, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //FIRAnalytics.manageTimeSpent(on: .SetUpDrugs, when: .Disappear)
    }
    
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
        self.applyStyle()
        self.manageActionMethods()
        self.btnSubmit.setTitle(AppMessages.save, for: .normal)
        self.initPicker()
        
        DispatchQueue.main.async {
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
        self.lblName
            .font(name: .semibold, size: 15).textColor(color: .themeBlack)
        self.lblAge
            .font(name: .semibold, size: 15).textColor(color: .themeBlack)
        self.lblGender
            .font(name: .semibold, size: 15).textColor(color: .themeBlack)
        self.lblEmail
            .font(name: .semibold, size: 15).textColor(color: .themeBlack)
        self.lblRelation
            .font(name: .semibold, size: 15).textColor(color: .themeBlack)
        
        self.lblEmailMsg
            .font(name: .regular, size: 12).textColor(color: .themeBlack.withAlphaComponent(1))
        self.lblRelationMsg
            .font(name: .regular, size: 12).textColor(color: .themeBlack.withAlphaComponent(1))
        
        self.txtName.maxLength              = Validations.MaxCharacterLimit.Name.rawValue
//        self.txtName.regex                = Validations.RegexType.AlpabetsDotQuoteSpace.rawValue
        self.txtName.defaultcharacterSet    = CharacterSet.letters.union(CharacterSet(charactersIn: ".' "))
        self.txtName.keyboardType           = .default
        
        self.txtAge.maxLength           = Validations.MaxCharacterLimit.cvv.rawValue
        self.txtAge.regex               = Validations.RegexType.OnlyNumber.rawValue
        self.txtAge.keyboardType        = .numberPad
        
        self.txtEmail.maxLength         = Validations.MaxCharacterLimit.Email.rawValue
        self.txtEmail.keyboardType      = .emailAddress
        
        self.txtRelation.tintColor      = UIColor.clear
        self.txtRelation.setRightImage(img: UIImage(named: "IconDownArrow"))
        
        self.sgGender.setTitle(GenderType.Male.rawValue, forSegmentAt: 0)
        //self.sgGender.setWidth(self.sgGender.frame.width / 4.2, forSegmentAt: 0)
        
        self.sgGender.setTitle(GenderType.Female.rawValue, forSegmentAt: 1)
       // self.sgGender.setWidth(self.sgGender.frame.width / 4.2, forSegmentAt: 1)
        
//        self.sgGender.setTitle(self.strPreferNotToSay, forSegmentAt: 2)
        self.sgGender.selectedSegmentIndex = 0
        self.strSelectedGender = GenderType.Male.rawValue
        self.lblRelationMsg.text = self.lblRelationMsg.text! + " \(UserModel.shared.name!)"
        
        DispatchQueue.main.async {
            self.setup(collectionView: self.colGender)
        }
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    private func initPicker(){
        self.pickerRelation.delegate            = self
        self.pickerRelation.dataSource          = self
        self.txtRelation.delegate               = self
        self.txtRelation.inputView              = self.pickerRelation
    }
    
    //MARK: -------------------------- Action Method --------------------------
    private func manageActionMethods(){
        
        self.btnSubmit.addTapGestureRecognizer {
//            let vc = SetGoalsVC.instantiate(fromAppStoryboard: .auth)
//            self.navigationController?.pushViewController(vc, animated: true)
//            let vc = AddWeightHeightVC.instantiate(fromAppStoryboard: .auth)
//            self.navigationController?.pushViewController(vc, animated: true)
            
            var gender = ""
            for item in self.arrGender {
                if item["isSelected"].intValue == 1 {
                    if let key = GenderType.init(rawValue: item["key"].stringValue) {
                        switch key {

                        case .Male:
                            gender = "Male"
                            break
                        case .Female:
                            gender = "Female"
                            break
                        case .Other:
                            gender = "Other"
                            break
                        }
                    }
                }
            }
            
            self.viewModel.apiCall(vc: self,
                                   member_id: self.member_id,
                                   name: self.txtName,
                                   email: self.txtEmail,
                                   relation: self.txtRelation.text!,
                                   age: self.txtAge,
                                   gender: gender,//self.strSelectedGender,
                                   isEdit: self.isEdit)
        }
    }
    
    @IBAction func selectGender(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            self.strSelectedGender = GenderType.Male.rawValue
        }
        else if sender.selectedSegmentIndex == 1 {
            self.strSelectedGender = GenderType.Female.rawValue
        }
//        else if sender.selectedSegmentIndex == 2 {
//            self.strSelectedGender = "P"
//        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension AddPatientDetailsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colGender:
            return self.arrGender.count
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        
        case self.colGender:
            let cell : AddAddressTypeCell = collectionView.dequeueReusableCell(withClass: AddAddressTypeCell.self, for: indexPath)
            let obj                     = self.arrGender[indexPath.item]
            cell.lblTitle.text          = obj["name"].stringValue
            cell.imgView.image          = UIImage(named: obj["image"].stringValue)
            cell.imgView.isHidden       = true
            
            cell.imgView.tintColor = UIColor.themePurple
            cell.vwBg.backGroundColor(color: UIColor.themePurple.withAlphaComponent(0.04))
            cell.lblTitle.font(name: .medium, size: 15)
                .textColor(color: UIColor.themeBlack)
            if obj["isSelected"].intValue == 1 {
                cell.imgView.tintColor = UIColor.white
                cell.vwBg.backGroundColor(color: UIColor.themePurple.withAlphaComponent(1))
                cell.lblTitle.font(name: .medium, size: 15)
                    .textColor(color: UIColor.white)
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colGender:
            
            let obj                  = self.arrGender[indexPath.item]
            for i in 0...self.arrGender.count - 1 {
                var object          = self.arrGender[i]
                if object["name"].stringValue == obj["name"].stringValue {
                    object["isSelected"].intValue = 1
                }
                else {
                    object["isSelected"].intValue = 0
                }
                self.arrGender[i] = object
            }
            self.colGender.reloadData()
            
            break
            
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colGender:
            
            let obj     = self.arrGender[indexPath.item]
//            let width   = obj["name"].stringValue.width(withConstraintedHeight: 30.0, font: UIFont.customFont(ofType: .medium, withSize: 15.0)) + 55
            let width   = self.colGender.frame.size.width / 2
            let height  = self.colGender.frame.size.height
            
            return CGSize(width: width,
                          height: height)
       
        default:
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: --------------------- UIPickerVIew Method ---------------------
extension AddPatientDetailsVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerRelation:
            return self.arrRelation.count
        
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerRelation:
            let obj = self.arrRelation[row]
            return obj["name"].stringValue
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerRelation:
            let obj                 = self.arrRelation[row]
            self.txtRelation.text   = obj["name"].stringValue
            break
        default: break
        }
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension AddPatientDetailsVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtRelation:
            if self.txtRelation.text?.trim() == "" {
                let obj                 = self.arrRelation[0]
                self.txtRelation.text   = obj["name"].stringValue
            }
            return true
        default:
            return true
        }
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension AddPatientDetailsVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                
                if self.isEdit {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
                
            break
            
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}

