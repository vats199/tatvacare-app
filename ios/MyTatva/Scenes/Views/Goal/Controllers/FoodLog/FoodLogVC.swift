//
//  ExerciseMoreVC.swift

import UIKit

//MARK: -------------------------  UIViewController -------------------------
class FoodLogVC : WhiteNavigationBaseVC {
    
    //MARK: ------------------------- Outlet -------------------------
    @IBOutlet weak var scrollView               : UIScrollView!
    
    @IBOutlet weak var vwSelectFoodType         : UIView!
    @IBOutlet weak var txtDate                  : UITextField!
    @IBOutlet weak var txtSelectFoodType        : UITextField!
    @IBOutlet weak var lblQtyHelp               : UILabel!
    @IBOutlet weak var btnQtyHelp               : UIButton!
    
    @IBOutlet weak var lblAddMeal               : UILabel!
    @IBOutlet weak var vwAddMealImage           : UIView!
    @IBOutlet weak var colAddMealImage          : UICollectionView!
    
    @IBOutlet weak var vwSearch                 : UIView!
    @IBOutlet weak var txtSearch                : UITextField!
    
    @IBOutlet weak var lblFrequentlAddedItem    : UILabel!
    
    @IBOutlet weak var tblAddedItem             : UITableView!
    @IBOutlet weak var tblAddedItemHeight       : NSLayoutConstraint!
    
    @IBOutlet weak var tblFrequentItem          : UITableView!
    @IBOutlet weak var tblFrequentItemHeight    : NSLayoutConstraint!
    @IBOutlet weak var vwAddNewItem             : UIView!
    @IBOutlet weak var btnAddNewItem            : UIButton!
    
    @IBOutlet weak var lblNoSearch              : UILabel!
    @IBOutlet weak var tblSearchedItem          : UITableView!
    @IBOutlet weak var tblSearchedItemHeight    : NSLayoutConstraint!
    
    @IBOutlet weak var btnDone                  : UIButton!
    @IBOutlet weak var btnCancel                : UIButton!
    @IBOutlet weak var lblInfo                  : UILabel!
    
    //MARK:- Class Variable
    private let viewModel                           = FoodLogVM()
    private let refreshControl                      = UIRefreshControl()
    private var arrMyFood                           = [FoodSearchListModel]()
    
    private var strErrorMessage : String            = ""
    private var strErrorMessageNoSearch : String    = ""
    private var selectedFilterobject                = ContenFilterListModel()
    private var lastSyncDate                        = Date()
    private var arrMyFoodImages                     = [FoodImageModel]()
    private var datePicker                          = UIDatePicker()
    private var dateFormatter                       = DateFormatter()
//    var arrImg                                    = [UIImage]()
    
    private let pickerFoodType                      = UIPickerView()
    private var selectedMealType                    = MealTypeListModel()
    
    var isEdit                                  = false
    var patient_meal_rel_id                     = ""
    var mealTypesId                             = ""
    var selectedDate                            = Date()
    
    //MARK: ------------------------- Memory Management Method -------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //MARK: ------------------------- Custom Method -------------------------
    private func setUpView() {
        self.addObserverOnHeightTbl()
        self.initDatePicker()
        self.setData()
        self.configureUI()
        self.setupViewModelObserver()
        self.manageActionMethods()
        self.updateSearchViews(search: self.txtSearch.text!)
        self.initPicker()
        
        self.setup(tblView: self.tblAddedItem)
        self.setup(tblView: self.tblFrequentItem)
        self.setup(tblView: self.tblSearchedItem)
        self.setup(colView: self.colAddMealImage)
    }
    
    private func configureUI(){
        //self.tblView.themeShadow()
        
        self.txtSearch.delegate = self
        self.lblQtyHelp
            .font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack)
        
        self.lblAddMeal
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.lblNoSearch
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.btnAddNewItem
            .font(name: .regular, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.lblFrequentlAddedItem
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themeBlack)
        
        self.btnDone.font(name: .medium, size: 14)
            .textColor(color: UIColor.white)
            
        self.btnCancel.font(name: .medium, size: 14)
            .textColor(color: UIColor.themePurple)
        
        self.lblInfo.font(name: .regular, size: 12)
            .textColor(color: UIColor.themeGray)
        
        self.txtDate.setRightImage(img: UIImage(named: "calendar_day"))
        self.txtDate.tintColor = .clear
        self.txtSelectFoodType.tintColor = .clear
        
        DispatchQueue.main.async {
            self.vwAddMealImage.layoutIfNeeded()
            self.vwAddMealImage.backGroundColor(color: UIColor.clear)
                .cornerRadius(cornerRadius: 5, clips: true)
                .addDashBorder(color: UIColor.themeGray)
                
            self.btnDone.layoutIfNeeded()
            self.btnCancel.layoutIfNeeded()
            
            self.btnDone
                .borderColor(color: UIColor.clear, borderWidth: 1)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.themePurple)
            
            self.btnCancel
                .borderColor(color: UIColor.clear, borderWidth: 1)
                .cornerRadius(cornerRadius: 7)
                .backGroundColor(color: UIColor.white)
            
            self.vwSearch.layoutIfNeeded()
            self.vwSearch.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themeLightGray, borderWidth: 1)
            
            self.btnAddNewItem.layoutIfNeeded()
            self.btnAddNewItem.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.themePurple, borderWidth: 1)
            
            self.vwSelectFoodType.layoutIfNeeded()
            self.vwSelectFoodType.cornerRadius(cornerRadius: 5)
                .borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
        }
    }
    
    private func setup(tblView: UITableView){
        tblView.tableFooterView            = UIView.init(frame: CGRect.zero)
        tblView.emptyDataSetSource         = self
        tblView.emptyDataSetDelegate       = self
        tblView.delegate                   = self
        tblView.dataSource                 = self
        tblView.rowHeight                  = UITableView.automaticDimension
        tblView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        tblView.addSubview(self.refreshControl)
    }
    
    private func setup(colView: UICollectionView){
        colView.delegate                   = self
        colView.dataSource                 = self
        colView.reloadData()
    }
   
    private func initPicker(){
        
        self.pickerFoodType.delegate        = self
        self.pickerFoodType.dataSource      = self
        self.txtSelectFoodType.delegate     = self
        self.txtSelectFoodType.inputView    = self.pickerFoodType
    }
    
    //MARK: ------------------------- Action Method -------------------------
    @IBAction func btnMoveTopTapped(sender: UIButton){
        self.scrollView.scrollToTop()
    }
    
    private func manageActionMethods(){
        self.lblQtyHelp.addTapGestureRecognizer {
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_REFERENCE_UTENSILS,
                                     screen: .LogFood,
                                     parameter: nil)
            let vc = FoodQuantityHelpVC.instantiate(fromAppStoryboard: .goal)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnQtyHelp.addTapGestureRecognizer {
            FIRAnalytics.FIRLogEvent(eventName: .USER_CLICKED_ON_REFERENCE_UTENSILS,
                                     screen: .LogFood,
                                     parameter: nil)
            let vc = FoodQuantityHelpVC.instantiate(fromAppStoryboard: .goal)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.btnCancel.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)

        }
        
        var isAdd = true
        if self.patient_meal_rel_id.trim() != "" {
            isAdd = false
        }
        
        self.btnDone.addTapGestureRecognizer {
            self.viewModel.apiFoodLog(vc: self,
                                      isAdd: isAdd,
                                      txtDate: self.txtDate,
                                      txtSelectFoodType: self.txtSelectFoodType,
                                      arrImg: self.arrMyFoodImages,
                                      selectedMealType: self.selectedMealType,
                                      arrMyFood: self.arrMyFood,
                                      patient_meal_rel_id: self.patient_meal_rel_id)
            
        }
        
        self.btnAddNewItem.addTapGestureRecognizer {
            let object          = FoodSearchListModel()
            object.foodItemId   = self.txtSearch.text!
            object.foodName     = self.txtSearch.text!
            object.quantity     = 1
            object.unitName     = AppMessages.unit
            object.calUnitName  = ""
            object.energyKcal   = "\(kDefaultFoodCalorie)"
            
            if !self.arrMyFood.contains(where: { (obj) -> Bool in
                return obj.foodItemId == object.foodItemId
            }) {
                self.arrMyFood.append(object)
                self.tblAddedItem.reloadData()
                self.txtSearch.text = ""
            }
        }
    }
    
    //MARK: ------------------------- Life Cycle Method -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
       
        self.scrollView.canCancelContentTouches = false
       self.updateAPIData(withLoader: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebengageManager.shared.navigateScreenEvent(screen: .LogFood)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if Calendar.current.dateComponents([.minute], from: lastSyncDate, to: Date()).minute > kAPI_RELOAD_DELAY_BY {
            self.lastSyncDate = Date()
            //self.updateAPIData(withLoader: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAnalytics.manageTimeSpent(on: .LogFood, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAnalytics.manageTimeSpent(on: .LogFood, when: .Disappear)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

//MARK: -------------------- Date picker methods --------------------
extension FoodLogVC {
    
    private func initDatePicker(){
       
        self.txtDate.inputView             = self.datePicker
        self.txtDate.delegate              = self
        self.datePicker.datePickerMode     = .date
        self.datePicker.maximumDate        =  self.selectedDate//Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.datePicker.timeZone           = .current
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
        
        self.dateFormatter.dateFormat   = appDateFormat
        self.dateFormatter.timeZone     = .current
        self.txtDate.text               = self.dateFormatter.string(from: self.selectedDate)
        
        self.txtDate.isUserInteractionEnabled = true
        if self.isEdit {
            self.txtDate.isUserInteractionEnabled = false
        }
        
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            self.dateFormatter.dateFormat   = appDateFormat
            self.dateFormatter.timeZone     = .current
            self.txtDate.text               = self.dateFormatter.string(from: sender.date)
            
            break
     
        default:break
        }
    }
    
    ///add searched food tap
    @objc private func handleSearchedItemAddTap(_ sender : UIButton){
        let object = self.viewModel.getObjectSeachList(index: sender.tag)
        if !self.arrMyFood.contains(where: { (obj) -> Bool in
            return obj.foodItemId == object.foodItemId
        }) {
            
            var param = [String : Any]()
            param[AnalyticsParameters.food_item_id.rawValue] = object.foodItemId
            param[AnalyticsParameters.food_name.rawValue] = object.foodName
            FIRAnalytics.FIRLogEvent(eventName: .USER_SELECTED_FOOD_DISH,
                                     screen: .LogFood,
                                     parameter: param)
            
            object.quantity = 1
            self.arrMyFood.append(object)
            self.tblAddedItem.reloadData()
            
        }
    }
    
}

//MARK: -------------------------- UITableView Methods --------------------------
extension FoodLogVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tblAddedItem:
            return self.arrMyFood.count
            
        case self.tblSearchedItem:
            return self.viewModel.getCountSeachList()
            
        case self.tblFrequentItem:
            return self.viewModel.getCountFrequentFood()
            
        default:
            return 0
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tblAddedItem:
            let cell : FoodLogTblCell = tableView.dequeueReusableCell(withClass: FoodLogTblCell.self, for: indexPath)
            
            let object = self.arrMyFood[indexPath.row]
            cell.object         = object
            cell.lblTitle.text  = object.foodName
            
            if object.calUnitName.trim() == "" {
                cell.txtCal.isUserInteractionEnabled = true
                let calories        = object.energyKcal.components(separatedBy: " ").first!
                let caloriesDouble  = (Double(calories) ?? 0) * (Double(object.quantity) )
                cell.txtCal.text    = String(format: "%0.0f", caloriesDouble)
                cell.lblCal.text    = AppMessages.cal
            }
            else {
                ///This is for edit
                cell.txtCal.isUserInteractionEnabled = false
                let calories        = object.energyKcal.components(separatedBy: " ").first!
                let caloriesDouble  = (Double(calories) ?? 0) * (Double(object.quantity) )
                cell.txtCal.text    = String(format: "%0.0f", caloriesDouble)
                cell.lblCal.text    = object.calUnitName
            }
            cell.txtQty.text    = String(object.quantity) + " " + object.unitName
            
            cell.arrQty.removeAll()
            for i in 1...99 {
                let obj         = QuantityFoodLog()
                obj.title       = "\(i)"
                obj.unit        = object.unitName!
                cell.arrQty.append(obj)
                cell.pickerQty.reloadAllComponents()
            }
            
            
            cell.btnAddRemove.isSelected    = true
            cell.stackQty.isHidden          = false
            cell.vwCalLine.isHidden         = true
            
            cell.btnAddRemove.addTapGestureRecognizer {
                self.arrMyFood.remove(at: indexPath.row)
                self.tblAddedItem.reloadData()
            }
            
            return cell
            
        case self.tblSearchedItem:
            let cell : FoodLogTblCell = tableView.dequeueReusableCell(withClass: FoodLogTblCell.self, for: indexPath)
            
            let object = self.viewModel.getObjectSeachList(index: indexPath.row)
            cell.lblTitle.text  = object.foodName
            cell.txtCal.text    = object.energyKcal.components(separatedBy: " ").first!
            cell.lblCal.text    = object.calUnitName
            
            cell.stackQty.isHidden = true
            cell.vwCalLine.isHidden = true
            cell.txtCal.isUserInteractionEnabled = false
            
            cell.btnAddRemove.isUserInteractionEnabled = false
            
//            cell.btnAddRemove.tag = indexPath.row
//            cell.btnAddRemove.addTarget(self, action: #selector(self.handleSearchedItemAddTap(_:)), for: .touchUpInside)
            
            
//            cell.btnAddRemove.addTapGestureRecognizer {
//                if !self.arrMyFood.contains(where: { (obj) -> Bool in
//                    return obj.foodItemId == object.foodItemId
//                }) {
//                    self.arrMyFood.append(object)
//                    self.tblAddedItem.reloadData()
//                }
//            }
            
            return cell
            
        case self.tblFrequentItem:
            let cell : FoodLogTblCell = tableView.dequeueReusableCell(withClass: FoodLogTblCell.self, for: indexPath)
            
            let object = self.viewModel.getObjectFrequentFood(index: indexPath.row)
            cell.lblTitle.text  = object.foodName
            cell.txtCal.text    = object.energyKcal.components(separatedBy: " ").first! 
            cell.lblCal.text    = object.calUnitName
            
            cell.stackQty.isHidden = true
            cell.vwCalLine.isHidden = true
            cell.txtCal.isUserInteractionEnabled = false
            
            cell.btnAddRemove.isUserInteractionEnabled = false
            
//            cell.btnAddRemove.addTapGestureRecognizer {
//                if !self.arrMyFood.contains(where: { (obj) -> Bool in
//                    return obj.foodItemId == object.foodItemId
//                }) {
//
//                    var param = [String : Any]()
//                    param[AnalyticsParameters.food_item_id.rawValue] = object.foodItemId
//                    param[AnalyticsParameters.food_name.rawValue] = object.foodName
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_SELECTED_FOOD_DISH, parameter: param)
//
//                    object.quantity = 1
//                    self.arrMyFood.append(object)
//                    self.tblAddedItem.reloadData()
//
//                }
//            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tblSearchedItem:
            
            DispatchQueue.main.async {
                let object = self.viewModel.getObjectSeachList(index: indexPath.row)
                if !self.arrMyFood.contains(where: { (obj) -> Bool in
                    return obj.foodItemId == object.foodItemId
                }) {
                    var param = [String : Any]()
                    param[AnalyticsParameters.food_item_id.rawValue] = object.foodItemId
                    param[AnalyticsParameters.food_name.rawValue] = object.foodName
                    FIRAnalytics.FIRLogEvent(eventName: .USER_SELECTED_FOOD_DISH, parameter: param)
                    
                    object.quantity = 1
                    self.arrMyFood.append(object)
                    self.tblAddedItem.reloadData()
                }
            }
            break
        case self.tblFrequentItem:
            
            DispatchQueue.main.async {
                let object = self.viewModel.getObjectFrequentFood(index: indexPath.row)
                if !self.arrMyFood.contains(where: { (obj) -> Bool in
                    return obj.foodItemId == object.foodItemId
                }) {
                    
                    var param = [String : Any]()
                    param[AnalyticsParameters.food_item_id.rawValue] = object.foodItemId
                    param[AnalyticsParameters.food_name.rawValue] = object.foodName
                    FIRAnalytics.FIRLogEvent(eventName: .USER_SELECTED_FOOD_DISH, parameter: param)
                    
                    object.quantity = 1
                    self.arrMyFood.append(object)
                    self.tblAddedItem.reloadData()
                }
            }
            
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //self.viewModel.managePagenationContentList(index: indexPath.row)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension FoodLogVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themePurple]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: -------------------------- Observers Methods --------------------------
extension FoodLogVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.tblAddedItem, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblAddedItemHeight.constant = newvalue.height
        }
        
        if let obj = object as? UITableView, obj == self.tblSearchedItem, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblSearchedItemHeight.constant = newvalue.height
            DispatchQueue.main.async {
                self.updateSearchViews(search: self.txtSearch.text!)
            }
        }
        
        if let obj = object as? UITableView, obj == self.tblFrequentItem, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tblFrequentItemHeight.constant = newvalue.height
        }
        
        UIView.animate(withDuration: kAnimationSpeed) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func addObserverOnHeightTbl() {
        self.tblAddedItem.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblSearchedItem.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblFrequentItem.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    private func removeObserverOnHeightTbl() {
        
        guard let tblView = self.tblAddedItem else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView2 = self.tblSearchedItem else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
        
        guard let tblView3 = self.tblFrequentItem else {return}
        if let _ = tblView3.observationInfo {
            tblView3.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension FoodLogVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colAddMealImage:
            return self.arrMyFoodImages.count + 1
      
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        
        case self.colAddMealImage:
            let cell : FoodLogColCell = collectionView.dequeueReusableCell(withClass: FoodLogColCell.self, for: indexPath)
            
            if indexPath.item == self.arrMyFoodImages.count {
                cell.imgTitle.image         = UIImage.init(named: "food_img_add")
                cell.btnDelete.isHidden     = true
            }
            else {
                let obj                     = self.arrMyFoodImages[indexPath.item]
                if obj.newImage != nil {
                    cell.imgTitle.image         = obj.newImage
                }
                else {
                    cell.imgTitle.setCustomImage(with: obj.imageUrl)
                }
                cell.btnDelete.isHidden     = false
            }

            cell.btnDelete.addTapGestureRecognizer {
                self.arrMyFoodImages.remove(at: indexPath.item)
                self.colAddMealImage.reloadData()
            }
            
            return cell
         
        
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colAddMealImage:
            
            if indexPath.item == self.arrMyFoodImages.count {
                DispatchQueue.main.async {
                    ImagePickerController(isAllowEditing: true) { [weak self] (pickedImage) in
                        
                        let object          = FoodImageModel()
                        object.newImage     = pickedImage
                        self?.arrMyFoodImages.append(object)
                        self?.colAddMealImage.reloadData()
                        
                    }.present()
                }
            }
            
            break
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colAddMealImage:
            
            let width   = self.colAddMealImage.frame.size.height
            let height  = self.colAddMealImage.frame.size.height
            
            return CGSize(width: width,
                          height: height)
       
            
        default:
            
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
}

//MARK: -------------------------- Set data Methods --------------------------
extension FoodLogVC {
    
    @objc private func updateAPIData(withLoader: Bool = false){
        
        self.viewModel.apiCallFromStart_mealTypeList(pickerView: self.pickerFoodType,
                                                     withLoader: withLoader)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            //if self.viewModel.arrListContentList.count == 0 {
            self.viewModel.apiCallFromStart_frequently_added_food(refreshControl: nil,
                                                                  tblView: self.tblFrequentItem,
                                                                  withLoader: withLoader)
        }
        
        if self.isEdit {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
                //if self.viewModel.arrListContentList.count == 0 {
                self.viewModel.apiCallFromStart_my_added_food(refreshControl: nil,
                                                              tblView: self.tblAddedItem,
                                                              patient_meal_rel_id: self.patient_meal_rel_id, withLoader: withLoader)
            }
        }
    }
    
    private func setData(){
        
    }

}

//MARK: -------------------- UITextField Delegate --------------------
extension FoodLogVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: string)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {

            if newText.trim() != "" {
                self.updateSearchViews(search: newText)
            }
            else {
                self.updateSearchViews(search: "")
            }

            self.viewModel.apiCallFromStart_search_food(refreshControl: nil,
                                                        tblView: self.tblSearchedItem,
                                                        withLoader: false,
                                                        food_name: newText)
            
        }
       
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
       
        case self.txtSelectFoodType:
            if self.txtSelectFoodType.text?.trim() == "" {
                self.txtSelectFoodType.text = self.viewModel.getObjectMealType(index: 0).mealType
                self.selectedMealType       = self.viewModel.getObjectMealType(index: 0)
            }
            break
        case self.txtDate:
            
            if self.txtDate.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appDateFormat
                self.dateFormatter.timeZone     = .current
                self.txtDate.text          = self.dateFormatter.string(from: self.datePicker.date)
                
                //self.txtEndDate.text = ""
            }
            return true

        case self.txtSearch:
            
            self.view.endEditing(true)
            let vc = SearchFoodVC.instantiate(fromAppStoryboard: .goal)
            vc.completionHandler = { data in
                //Do your task here
                if let object = data {
                    DispatchQueue.main.async {

                        if !self.arrMyFood.contains(where: { (obj) -> Bool in
                            return obj.foodName == object.foodName
                        }) {
                            var param = [String : Any]()
                            param[AnalyticsParameters.food_item_id.rawValue] = object.foodItemId
                            param[AnalyticsParameters.food_name.rawValue] = object.foodName
                            FIRAnalytics.FIRLogEvent(eventName: .USER_SELECTED_FOOD_DISH, parameter: param)
                            
                            object.quantity = 1
                            self.arrMyFood.append(object)
                            self.tblAddedItem.reloadData()
                        }
                    }
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            return false
            
        default:
            break
        }
        return true
    }
    
    func updateSearchViews(search: String){
        DispatchQueue.main.async {
            if search.trim() == "" {
                self.vwAddNewItem.isHidden      = true
                self.lblNoSearch.isHidden       = true
                self.tblSearchedItem.isHidden   = true
                self.tblSearchedItem.reloadData()
            }
            else {
                if self.viewModel.getCountSeachList() > 0 {
                    self.vwAddNewItem.isHidden      = true
                    self.lblNoSearch.isHidden       = true
                    self.tblSearchedItem.isHidden   = false
                }
                else {
                    self.vwAddNewItem.isHidden      = false
                    self.lblNoSearch.isHidden       = false
                    self.tblSearchedItem.isHidden   = true
                }
                self.tblSearchedItem.reloadData()
            }
        }
    }
}

//MARK: --------------------- UIPickerVIew Method ---------------------
extension FoodLogVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerFoodType:
            return self.viewModel.getCountMealType()
        
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerFoodType:
            return self.viewModel.getObjectMealType(index: row).mealType
        
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerFoodType:
            self.selectedMealType       = self.viewModel.getObjectMealType(index: row)
            self.txtSelectFoodType.text = self.selectedMealType.mealType
            
            break
       
        default: break
        }
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension FoodLogVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResultMealType.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessageMealType
                self.pickerFoodType.reloadAllComponents()
                
                if !self.isEdit {
                    if self.viewModel.arrListMealType.count > 0 {
                        for i in 0...self.viewModel.arrListMealType.count - 1 {
                            let type = self.viewModel.arrListMealType[i]
                            
                            if type.mealTypesId == self.mealTypesId {
                                self.selectedMealType       = self.viewModel.getObjectMealType(index: i)
                                self.txtSelectFoodType.text = self.selectedMealType.mealType
                                self.pickerFoodType.selectRow(i, inComponent: 0, animated: true)
                            }
                        }
                    }
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
        
        self.viewModel.vmResultSearch.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessageNoSearch    = self.viewModel.strErrorMessageNoSearch
                self.lblNoSearch.text           = self.strErrorMessageNoSearch
                
                self.updateSearchViews(search: self.txtSearch.text!)
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
            case .none: break
            }
        })
        
        self.viewModel.vmResultFrequent.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                if self.viewModel.getCountFrequentFood() > 0 {
                    self.lblFrequentlAddedItem.isHidden     = false
                    self.tblFrequentItem.isHidden           = false
                    self.tblFrequentItem.reloadData()
                }
                else {
                    self.lblFrequentlAddedItem.isHidden     = true
                    self.tblFrequentItem.isHidden           = true
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
            case .none: break
            }
        })
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                
//                var params              = [String : Any]()
//                params[AnalyticsParameters.goal_name.rawValue]  = self.goalListModel.goalName
//                params[AnalyticsParameters.goal_id.rawValue]    = self.goalListModel.goalMasterId
//                FIRAnalytics.FIRLogEvent(eventName: .USER_UPDATED_ACTIVITY, parameter: params)
                
                if self.isEdit {
                    if let viewControllers = self.navigationController?.viewControllers {
                        for vc in viewControllers {
                            // some process
                            if vc.isKind(of: FoodDiaryParentVC.self) {
                                self.navigationController?.popToViewController(vc, animated: true)
                            }
                        }
                    }
                    //UIApplication.shared.setHome()
                }
                else {
                    let vc = FoodLogDonePopupVC.instantiate(fromAppStoryboard: .goal)
                    vc.mealType = self.txtSelectFoodType.text ?? ""
                    vc.object = self.viewModel.objcFoodLogAnalysis
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.completionHandler = { obj in
                        //UIApplication.shared.setHome()
                        var isBack = false
                        if let viewControllers = self.navigationController?.viewControllers {
                            for vc in viewControllers {
                                // some process
                                if vc.isKind(of: FoodDiaryParentVC.self) ||
                                    vc.isKind(of: CarePlanVC.self) {
                                    isBack = true
                                    self.navigationController?.popToViewController(vc, animated: true)
                                }
                            }
                        }
                        
                        if !isBack {
                            UIApplication.shared.setHome()
                        }
                    }
                    self.present(vc, animated: true, completion: nil)
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
            case .none: break
            }
        })
        
        self.viewModel.vmResultMyFood.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.arrMyFood          = self.viewModel.arrMyFood
                self.arrMyFoodImages    = self.viewModel.arrMyFoodImages
                self.tblAddedItem.reloadData()
                self.colAddMealImage.reloadData()
                
                if self.viewModel.arrListMealType.count > 0 {
                    for i in 0...self.viewModel.arrListMealType.count - 1 {
                        let type = self.viewModel.arrListMealType[i]
                        
                        if type.mealTypesId == self.arrMyFood[0].meal_types_id {
                            self.selectedMealType       = self.viewModel.getObjectMealType(index: i)
                            self.txtSelectFoodType.text = self.selectedMealType.mealType
                            self.pickerFoodType.selectRow(i, inComponent: 0, animated: true)
                            
                            if self.viewModel.getCountMyFood() > 0{
                                self.txtDate.text = self.viewModel.getObjectMyFood(index: 0).mealDate.changeDateFormat(from: .default(format: .yyyymmdd), to: .default(format: .ddmmyyyy), type: .noconversion)
                            }
                        }
                    }
                }
                
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                break
            case .none: break
            }
        })
    }
}

                                                                                         
