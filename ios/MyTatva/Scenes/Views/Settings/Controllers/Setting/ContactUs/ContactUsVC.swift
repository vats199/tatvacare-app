//
//  CreateAccountVC.swift
//
//

import UIKit


class ContactUsVC: WhiteNavigationBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var lblTitle                 : UILabel!
    
    @IBOutlet weak var txtSubject               : CustomSkyTextField!
    
    @IBOutlet weak var lblMsg                   : UILabel!
    @IBOutlet weak var tvMsg                    : UITextView!

    @IBOutlet weak var btnSubmit                : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel = ContactUsViewModel()

    var arrSubject          = ["About Payment", "About Payment 2", "About Payment 3"]
    let pickerSubject       = UIPickerView()
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
    
    //MARK: ----------------------- Custom Method -----------------------
    private func setUpView() {
        self.applyStyle()
        self.initPicker()
    
        DispatchQueue.main.async {
            self.btnSubmit.layoutIfNeeded()
            
            self.btnSubmit.cornerRadius(cornerRadius: self.btnSubmit.frame.height / 2)
            
            self.navigationController?.clearNavigation(textColor: UIColor.themePurple, navigationColor: UIColor.white)
        }
    }
    
    private func applyStyle() {
        
        self.lblTitle.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeGray)
        
        self.lblMsg.font(name: .regular, size: 14)
            .textColor(color: UIColor.themeGray)
        
        self.btnSubmit.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
            .backGroundColor(color: UIColor.themePurple)
        
        self.txtSubject.setRightImage(img: UIImage(named: "IconDownArrow"))
    }
    
    func initPicker(){
        
        self.pickerSubject.delegate = self
        self.pickerSubject.dataSource = self
        self.txtSubject.delegate = self
        self.txtSubject.inputView = self.pickerSubject
    }
    
    //MARK: -------------------- Action Method --------------------
    @IBAction func btnUpdateTapped(_ sender: Any) {
        self.viewModel.apiCall(vc: self,
                               subject: self.txtSubject.text!,
                               message: self.tvMsg.text!)
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension ContactUsVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
       
        case self.txtSubject:
            if self.txtSubject.text?.trim() == "" {
                self.txtSubject.text         = self.arrSubject[0]
            }
            break
        default:
            break
        }
        return true
    }
}

//MARK: --------------------- UIPickerVIew Method ---------------------
extension ContactUsVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerSubject:
            return self.arrSubject.count
        
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerSubject:
            return self.arrSubject[row]
        
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerSubject:
            self.txtSubject.text = self.arrSubject[row]
            break
       
        default: break
        }
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension ContactUsVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.navigationController?.popViewController(animated: true)
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}


