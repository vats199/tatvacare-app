
import UIKit

class SetLocationVC: ClearNavigationFontBlackBaseVC {
    
    //MARK:- Outlet
    @IBOutlet weak var lblSelectLoc         : UILabel!
    
    @IBOutlet weak var lblState             : UILabel!
    @IBOutlet weak var txtState             : UITextField!
    
    @IBOutlet weak var lblCity              : UILabel!
    @IBOutlet weak var txtCity              : UITextField!
    
    @IBOutlet weak var txtDeviceLocation    : UITextField!
    
    @IBOutlet weak var btnOr                : UIButton!
    
    @IBOutlet weak var btnBack              : UIButton!
    @IBOutlet weak var btnSubmit            : UIButton!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    private let viewModel               = SetLocationVM()
    var isEdit                          = false
    
    var selectedStateListModel          = StateListModel()
    var selectedCityListModel           = CityListModel()
    var locationStatus:CLAuthorizationStatus!
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        WebengageManager.shared.navigateScreenEvent(screen: .SelectLocation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .SelectLocation, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAnalytics.manageTimeSpent(on: .SelectLocation, when: .Disappear)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //-----------------------------------------------------
    
    //MARK:- Memory Management Method
    
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
        
//        LocationManager.shared.delegate = self
        
        self.txtState.setRightImage(img: UIImage(named: "IconDownArrow"))
        self.txtCity.setRightImage(img: UIImage(named: "IconDownArrow"))
        self.txtDeviceLocation.setRightImage(img: UIImage(named: "CurrentLoc"))
        
        self.txtState.delegate = self
        self.txtCity.delegate = self
        self.txtDeviceLocation.delegate = self
        
        if self.isEdit {
            self.setData()
        }
        
        self.btnBack.addTapGestureRecognizer {
            if self.isEdit {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                UIApplication.shared.manageLogin()
            }
        }
    }
    
    private func applyStyle() {
        self.lblSelectLoc.font(name: .bold, size: 20).textColor(color: .themeBlack)
        self.lblState.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.lblCity.font(name: .medium, size: 16).textColor(color: .themeBlack)
        self.btnOr.font(name: .medium, size: 16).textColor(color: .themeBlack)
    }
    
    //MARK:- Action Method
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        if self.selectedStateListModel.stateName == nil {
            Alert.shared.showSnackBar(AppError.validation(type: .selectState).localizedDescription)
        }else if self.selectedCityListModel.cityName == nil {
            Alert.shared.showSnackBar(AppError.validation(type: .selectCity).localizedDescription)
        } else {
            self.viewModel.apiCall(vc: self,
                                   city: self.selectedCityListModel.cityName,
                                   state: self.selectedStateListModel.stateName,
                                   country: "India")
        }
        
    }
    
    //------------------------------------------------------
}

//MARK: -------------------- UITextField Delegate --------------------
extension SetLocationVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtState:
            self.view.endEditing(true)
            let vc = SelectStateVC.instantiate(fromAppStoryboard: .auth)
            vc.completionHandler = { obj in
                //Do your task here
                if obj != nil {
                    self.selectedStateListModel     = obj!
                    self.txtState.text              = self.selectedStateListModel.stateName
                    
                    self.selectedCityListModel      = CityListModel()
                    self.txtCity.text               = ""
                    self.txtDeviceLocation.text     = ""
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        
        case self.txtCity:
            self.view.endEditing(true)
            if self.txtState.text?.trim() == "" {
                Alert.shared.showSnackBar(AppError.validation(type: .selectState).errorDescription ?? "")
            }
            else {
                let vc = SelectCityVC.instantiate(fromAppStoryboard: .auth)
                vc.state_name = self.selectedStateListModel.stateName
                vc.completionHandler = { obj in
                    //Do your task here
                    if obj != nil {
                        self.selectedCityListModel  = obj!
                        self.txtCity.text           = self.selectedCityListModel.cityName
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            return false
        
        case self.txtDeviceLocation:
            LocationManager.shared.getLocation(isAskForPermission: true)
            
            if LocationManager.shared.checkStatus() == .authorizedAlways || LocationManager.shared.checkStatus() == .authorizedWhenInUse {
                let lat     = LocationManager.shared.getUserLocation().coordinate.latitude
                let long    = LocationManager.shared.getUserLocation().coordinate.longitude
                
                GoogleNavigationAdddress.getAddressFromLatLong(lat: lat, lng: long) { (response) in
                    let response = JSON(response)
                    
                    
                    if response[StringConstant.City].stringValue != "" &&
                       response[StringConstant.State].stringValue != "" {
                        
                        self.selectedStateListModel.stateName   = response[StringConstant.State].stringValue
                        self.selectedCityListModel.cityName     = response[StringConstant.City].stringValue
                        
                        //self.txtDeviceLocation.text = self.selectedStateListModel.stateName + ", " +
                          //self.selectedCityListModel.cityName
                        self.txtState.text  = self.selectedStateListModel.stateName
                        self.txtCity.text   = self.selectedCityListModel.cityName
                    }
                    else {
                        Alert.shared.showSnackBar((AppError.validation(type: .locationNotFound)).errorDescription ?? "")
                    }
                }
            }else {
                _ = LocationManager.shared.isLocationServiceEnabled(showAlert: true)
            }
            
            return false
            
        default:break
        }
        return true
    }
}

//MARK: -------------------- Set Data method --------------------
extension SetLocationVC {
    
    func setData(){
        self.selectedStateListModel.stateName   = UserModel.shared.state
        self.selectedCityListModel.cityName     = UserModel.shared.city
        self.txtState.text                      = UserModel.shared.state
        self.txtCity.text                       = UserModel.shared.city
    }
}

//MARK: -------------------- setupViewModel Observer --------------------
extension SetLocationVC {
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                //Alert.shared.showAlert(message: "Login success", completion: nil)

                FIRAnalytics.FIRLogEvent(eventName: .USER_SELECTED_STATE,
                                         screen: .SelectLocation,
                                         parameter: nil)
                FIRAnalytics.FIRLogEvent(eventName: .USER_SELECTED_CITY,
                                         screen: .SelectLocation,
                                         parameter: nil)
                
                if self.isEdit {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    let vc = AddPrescriptionVC.instantiate(fromAppStoryboard: .auth)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
    }
}

extension SetLocationVC: LocationManagerDelegate {
    
    func didChangeAuthorizationStatus(status: CLAuthorizationStatus) {
        if self.locationStatus != status {
            self.locationStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                let lat     = LocationManager.shared.getUserLocation().coordinate.latitude
                let long    = LocationManager.shared.getUserLocation().coordinate.longitude
                
                WebengageManager.shared.setUserLocation()
                
                GoogleNavigationAdddress.getAddressFromLatLong(lat: lat, lng: long) { (response) in
                    let response = JSON(response)
                    
                    
                    if response[StringConstant.City].stringValue != "" &&
                       response[StringConstant.State].stringValue != "" {
                        
                        self.selectedStateListModel.stateName   = response[StringConstant.State].stringValue
                        self.selectedCityListModel.cityName     = response[StringConstant.City].stringValue
                        
                        //self.txtDeviceLocation.text = self.selectedStateListModel.stateName + ", " +
                          //self.selectedCityListModel.cityName
                        self.txtState.text  = self.selectedStateListModel.stateName
                        self.txtCity.text   = self.selectedCityListModel.cityName
                    }
                    else {
                        Alert.shared.showSnackBar((AppError.validation(type: .locationNotFound)).errorDescription ?? "")
                    }
                }
            }else {
                self.txtState.text  = ""
                self.txtCity.text   = ""
            }
        }
    }
    
}
