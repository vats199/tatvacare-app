
//
//  UpdateMedicationPopupCell.swift
//  MyTatva
//

//

import Foundation

class CarePlanMedicationCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var imgView              : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var colMedicationDosage  : UICollectionView!
    
    var arrData : [JSON] = []
    var arrList = [DoseTakenData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .semibold, size: 8)
            .textColor(color: UIColor.themeBlack)
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 6)
            //self.vwBg.applyViewShadow(shadowOffset: CGSize.zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.2, shdowRadious: 5)
            
            self.imgView.layoutIfNeeded()
            self.imgView.cornerRadius(cornerRadius: 0)
        }
        
        self.setup(collectionView: self.colMedicationDosage)
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
}

class CarePlanMedicationDosageCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgTag           : UIImageView!
    @IBOutlet weak var btnSelect        : UIButton!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var vwLeft           : UIView!
    @IBOutlet weak var vwRight          : UIView!
    
    //MARK:- Class Variable
    
    override func awakeFromNib() {
        
        self.lblTitle.font(name: .medium, size: 9)
            .textColor(color: UIColor.themeBlack)
        self.btnSelect.font(name: .medium, size: 9)
            .textColor(color: UIColor.white)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
        }
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//----------------------------------------------------------------------------
//MARK:- UITableView Methods
//----------------------------------------------------------------------------
extension CarePlanMedicineCell : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrList.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CarePlanMedicationCell = tableView.dequeueReusableCell(withClass: CarePlanMedicationCell.self, for: indexPath)

        let object = self.arrList[indexPath.row]
        
        //cell.arrData = object["dose_list"].arrayValue
        cell.arrList = object.doseTakenData
        cell.colMedicationDosage.reloadData()
        
        DispatchQueue.main.async {
            cell.vwBg.layoutIfNeeded()
            
            if indexPath.row % 2 == 0 {
                cell.vwBg
                    .backGroundColor(color: UIColor.white)
            }
            else {
                cell.vwBg
                    .backGroundColor(color: UIColor.themeLightGray.withAlphaComponent(0.25))
            }
        }
        
        cell.imgView.setCustomImage(with: object.imageUrl)
        cell.lblTitle.text          = object.medicineName
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewModel.managePagenation(tblView: self.tblView,
//                                        index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65 * ScreenSize.widthAspectRatio
    }
}

//MARK: 🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦
//MARK: -------------------------- UICollectionView Methods --------------------------
extension CarePlanMedicationCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colMedicationDosage:
            return self.arrList.count
      
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        
        case self.colMedicationDosage:
            let cell : CarePlanMedicationDosageCell = collectionView.dequeueReusableCell(withClass: CarePlanMedicationDosageCell.self, for: indexPath)
            let obj                     = self.arrList[indexPath.item]
            
//            let time = GFunction.shared.convertDateFormate(dt: object.createdAt,
//                                                           inputFormat: DateTimeFormaterEnum.UTCFormat.rawValue,
            //                                                           outputFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue,
            //
            
            cell.lblTitle.text      = obj.doseDay
            
            if obj.achievedValue >= obj.goalValue {
                cell.btnSelect.isSelected = true
                cell.btnSelect.setTitle("", for: .normal)
            }
            else {
                cell.btnSelect.isSelected = false
                let strTitle = "\(obj.achievedValue!)/\(obj.goalValue!)"
                cell.btnSelect.setTitle(strTitle, for: .normal)
            }
            
//            if obj["isSelected"].intValue == 1 {
//                cell.btnSelect.isSelected = true
//                cell.btnSelect.setTitle("", for: .normal)
//            }
//            else {
//                cell.btnSelect.isSelected = false
//                cell.btnSelect.setTitle("--", for: .normal)
//            }
//
            cell.imgTag.alpha = 0
//            if obj["is_tag"].intValue == 1 {
//                cell.imgTag.alpha = 1
//            }
            
            if indexPath.row == 0 {
                cell.vwLeft.alpha       = 0
                cell.vwRight.alpha      = 1
            }
            else if indexPath.row == self.arrList.count - 1 {
                cell.vwLeft.alpha       = 1
                cell.vwRight.alpha      = 0
            }
            
            return cell
    
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colMedicationDosage:
            break
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
            
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colMedicationDosage:
            
            let width   = self.colMedicationDosage.frame.size.width / 7
            let height  = self.colMedicationDosage.frame.size.height
            
            return CGSize(width: width,
                          height: height)
     
            
        default:
            
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
    
}
