//
//  UpdateMedicationPopupCell.swift
//  MyTatva
//

//

import Foundation

class UpdateMedicationPopupCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    @IBOutlet weak var imgView              : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var colMedicationDosage  : UICollectionView!
    
    var arrData : [JSON] = []
    var object = MedicationTodayList()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font(name: .bold, size: 14)
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

class UpdateMedicationDosageCell : UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var btnSelect        : UIButton!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var vwLeft           : UIView!
    @IBOutlet weak var vwRight          : UIView!
    
    //MARK:- Class Variable
    
    override func awakeFromNib() {
        
        self.lblTitle.font(name: .medium, size: 12)
            .textColor(color: UIColor.themeBlack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
        }
    }
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension UpdateMedicationPopupCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colMedicationDosage:
            return self.object.doseTimeSlot.count
      
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        
        case self.colMedicationDosage:
            let cell : UpdateMedicationDosageCell = collectionView.dequeueReusableCell(withClass: UpdateMedicationDosageCell.self, for: indexPath)
            
            let obj                     = self.object.doseTimeSlot[indexPath.item]
            
            let time = GFunction.shared.convertDateFormate(dt: obj.time,
                                                           inputFormat: DateTimeFormaterEnum.HHmm.rawValue,
                                                           outputFormat: appTimeFormat,
                                                           status: .NOCONVERSION)
                                                           
                                                           
            cell.lblTitle.text      = time.0
            
            cell.btnSelect.isSelected = false
            if obj.taken == "Y" {
                cell.btnSelect.isSelected = true
            }
            
            cell.vwLeft.alpha   = 1
            cell.vwRight.alpha  = 1
            if indexPath.row == 0 {
                cell.vwLeft.alpha   = 0
                cell.vwRight.alpha  = 1
            }
            else if indexPath.row == self.object.doseTimeSlot.count - 1 {
                cell.vwLeft.alpha   = 1
                cell.vwRight.alpha  = 0
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colMedicationDosage:
            let obj = self.object.doseTimeSlot[indexPath.item]
            
            
            if obj.taken == "Y" {
                obj.taken = "N"
            }
            else {
                obj.taken = "Y"
            }
            self.object.doseTimeSlot[indexPath.item] = obj
            self.colMedicationDosage.reloadData()
            break
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colMedicationDosage:
            
            let width   = self.colMedicationDosage.frame.size.width / 3
            let height  = self.colMedicationDosage.frame.size.height
            
            return CGSize(width: width,
                          height: height)
     
            
        default:
            
            return CGSize(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
        }
    }
    
}
