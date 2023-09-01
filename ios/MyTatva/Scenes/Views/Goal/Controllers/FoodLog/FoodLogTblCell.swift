//
//  FoodLogTblCell.swift
//  MyTatva
//

//

import UIKit

class QuantityFoodLog {
    var title: String!
    var unit: String!
    
    init(){}
}

class FoodLogTblCell: UITableViewCell {

    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var lblTitle             : UILabel!

    @IBOutlet weak var stackQty             : UIStackView!
    @IBOutlet weak var txtQty               : UITextField!
    @IBOutlet weak var vwQtyLine            : UIView!
    
    @IBOutlet weak var stackCal             : UIStackView!
    @IBOutlet weak var txtCal               : UITextField!
    @IBOutlet weak var lblCal               : UILabel!
    @IBOutlet weak var vwCalLine            : UIView!
    
    @IBOutlet weak var btnAddRemove         : UIButton!
    
    var object          = FoodSearchListModel()
    let pickerQty       = UIPickerView()
    var arrQty          = [QuantityFoodLog]()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.lblTitle
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack)

        self.txtQty
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack)
        
        self.txtCal.delegate = self
        
        self.txtQty.setRightImage(img: UIImage(named: "food_down"))
        
        self.txtCal
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack)
        self.lblCal
            .font(name: .medium, size: 13)
            .textColor(color: UIColor.themeBlack)

        self.txtCal.keyboardType = .numberPad
        self.initPicker()
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
        }
    }

    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    func initPicker(){
        
        self.pickerQty.delegate     = self
        self.pickerQty.dataSource   = self
        self.txtQty.delegate        = self
        self.txtQty.inputView       = self.pickerQty
    }
}

class FoodLogColCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgTitle         : UIImageView!
    @IBOutlet weak var btnDelete        : UIButton!
    
    //MARK:- Class Variable
    var datePicker                  = UIDatePicker()
    var dateFormatter               = DateFormatter()
    //var timeFormat                  = DateTimeFormaterEnum.hhmma.rawValue
    var obj                         = DoseTimeslotModel()
    
    override func awakeFromNib() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 6)
            self.vwBg.backGroundColor(color: UIColor.themeLightPurple)
        }
    }
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension FoodLogTblCell : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
       
        case self.txtQty:
            if self.txtQty.text?.trim() == "" {
                let object = self.arrQty[0]
                self.txtQty.text            = object.title + " " + object.unit
                self.object.quantity        = Int(object.title)
                
                if let tbl = self.superview as? UITableView {
                    tbl.reloadData()
                }
            }
            break
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        
        switch textField {
        case self.txtCal:
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                
                if newText.trim() != "" {
                    self.object.energyKcal = newText
                }
            }
            break
        default: return true
        }
        return true
    }
}

//MARK: --------------------- UIPickerVIew Method ---------------------
extension FoodLogTblCell : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pickerQty:
            return self.arrQty.count
        
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pickerQty:
            let object = self.arrQty[row]
            return object.title + " " + object.unit
        
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pickerQty:
            
            let object = self.arrQty[row]
            self.txtQty.text            = object.title + " " + object.unit
            self.object.quantity        = Int(object.title)
            
            if let tbl = self.superview as? UITableView {
                tbl.reloadData()
            }
            
            var param = [String : Any]()
            param[AnalyticsParameters.food_item_id.rawValue] = self.object.foodItemId
            FIRAnalytics.FIRLogEvent(eventName: .USER_ADDED_QUANTITY,
                                     screen: .LogFood,
                                     parameter: param)
            
            break
       
        default: break
        }
    }
}

