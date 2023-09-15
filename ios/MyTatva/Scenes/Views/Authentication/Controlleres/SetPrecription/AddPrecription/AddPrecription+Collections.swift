//
//  AddPrecription+Collection.swift
//  MyTatva
//

//

import Foundation

class SuggestedDoseCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var txtTitle         : UITextField!
    @IBOutlet weak var btnEdit          : UIButton!
    
    //MARK:- Class Variable
    var datePicker                  = UIDatePicker()
    var dateFormatter               = DateFormatter()
    //var timeFormat                  = DateTimeFormaterEnum.hhmma.rawValue
    var obj                         = DoseTimeslotModel()
    
    override func awakeFromNib() {
        
        self.txtTitle.font(name: .medium, size: 11)
            .textColor(color: UIColor.white)
        self.initDatePicker()
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

//MARK: -------------------- Date picker methods --------------------
extension SuggestedDoseCell {
    
    func initDatePicker(){
       
        self.txtTitle.inputView                 = self.datePicker
        self.txtTitle.delegate                  = self
        self.datePicker.datePickerMode          = .time
//        self.datePicker.minimumDate             =  Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.datePicker.timeZone                = .current
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
       
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        
        switch sender {
        case self.datePicker:
            self.dateFormatter.dateFormat   = appTimeFormat
            self.dateFormatter.timeZone     = .current
            self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
            self.obj.time = self.dateFormatter.string(from: sender.date)
            self.txtTitle.text              = self.obj.time
            break
        default:break
        }
    }
    
}

//MARK: --------------------- UITextFieldDelegate Method ---------------------
extension SuggestedDoseCell : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtTitle:
            
            if self.txtTitle.text?.trim() == "" {
                self.dateFormatter.dateFormat   = appTimeFormat
                self.dateFormatter.timeZone     = .current
                self.dateFormatter.locale       = NSLocale(localeIdentifier: "en_US") as Locale
                self.obj.time                   = self.dateFormatter.string(from: self.datePicker.date)
                self.txtTitle.text              = self.obj.time
                
            }
            break
    
        default:
            break
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //self.txtTitle.isUserInteractionEnabled = false
        return true
    }
}

class MedicationCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var btnDelete        : UIButton!
    
    override func awakeFromNib() {
        
        self.lblTitle.font(name: .bold, size: 14)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .regular, size: 12)
            .textColor(color: UIColor.themeBlack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class PrecriptionCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgTitle         : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var btnDelete        : UIButton!
    
    override func awakeFromNib() {
        
        self.lblTitle.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
        self.lblDesc.font(name: .regular, size: 10)
            .textColor(color: UIColor.themeBlack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension AddPrescriptionVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colSuggestedDose:
            self.colSuggestedDose.isHidden = self.arrSuggestedDose.count > 0 ? false : true
            
            return self.arrSuggestedDose.count
            
        case self.colMedication:
            self.colMedication.isHidden = self.arrMedication.count > 0 ? false : true
           
            return self.arrMedication.count
        
        case self.colPrecription:
            self.colPrecription.isHidden = self.arrPrecription.count > 0 ? false : true
            
            return self.arrPrecription.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        
        case self.colSuggestedDose:
            let cell : SuggestedDoseCell = collectionView.dequeueReusableCell(withClass: SuggestedDoseCell.self, for: indexPath)
            let obj                     = self.arrSuggestedDose[indexPath.item]
            
//            let time = GFunction.shared.convertDateFormate(dt: obj.time,
//                                                           inputFormat: DateTimeFormaterEnum.HHmm.rawValue,
//                                                           outputFormat: DateTimeFormaterEnum.hhmma.rawValue,
//                                                           status: .NOCONVERSION)
            
            cell.obj = obj
            //cell.txtTitle.isUserInteractionEnabled = false
            cell.txtTitle.text          = obj.time
            
            cell.btnEdit.addTapGestureRecognizer {
                cell.txtTitle.isUserInteractionEnabled = true
                cell.txtTitle.becomeFirstResponder()
            }
            
            return cell
            
        case self.colMedication:
            let cell : MedicationCell = collectionView.dequeueReusableCell(withClass: MedicationCell.self, for: indexPath)
            let obj                     = self.arrMedication[indexPath.item]
            cell.lblTitle.text          = obj.medicineName
            cell.lblDesc.text           = obj.doseType
            
            cell.btnDelete.isHidden = false
            cell.btnDelete.addTapGestureRecognizer {
                self.arrMedication.remove(at: indexPath.item)
                self.colMedication.reloadData()
            }
            
            return cell
            
        case self.colPrecription:
            let cell : PrecriptionCell = collectionView.dequeueReusableCell(withClass: PrecriptionCell.self, for: indexPath)
            let obj                     = self.arrPrecription[indexPath.item]
            
            cell.imgTitle.image = nil
            if let image = obj.image {
                cell.imgTitle.image         = image
            }
            else {
                cell.imgTitle.setCustomImage(with: obj.documentUrl)
            }
            //UIImage(named: obj["img"].stringValue)
//            cell.lblTitle.text          = obj["name"].stringValue
//            cell.lblDesc.text           = obj["time"].stringValue
            
            cell.btnDelete.isHidden = false
            cell.btnDelete.addTapGestureRecognizer {
                self.arrPrecription.remove(at: indexPath.item)
                self.colPrecription.reloadData()
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colSuggestedDose:
//            var obj = arrFavDrink[indexPath.item]
//            obj["is_select"].intValue = obj["is_select"].intValue == 1 ? 0 : 1
//            arrFavDrink[indexPath.item] = obj
            
//            for i in 0...self.arrDealsData.count - 1 {
//                var object = self.arrDealsData[i]
//                object["is_select"].intValue = 0
//                if object["title"].stringValue == obj["title"].stringValue {
//                    object["is_select"].intValue = 1
//                }
//                self.arrDealsData[i] = object
//            }
            //self.colSuggestedDose.reloadData()
          
            break
            
        case self.colMedication:
            break
            
        case self.colPrecription:
            break
            
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colSuggestedDose:
            
            let width   = self.colSuggestedDose.frame.size.width / 3.6
            let height  = self.colSuggestedDose.frame.size.height
            
            return CGSize(width: width,
                          height: height)
            
        case self.colMedication:
            
            let width   = self.colMedication.frame.size.width / 3.5
            let height  = self.colMedication.frame.size.height
            
            return CGSize(width: width,
                          height: height)
      
        case self.colPrecription:
            let width   = self.colPrecription.frame.size.width / 2.7
            let height  = self.colPrecription.frame.size.height
            
            return CGSize(width: width,
                          height: height)
            
        default:
            
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
    
}
