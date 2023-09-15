//
//  FoodQuantityHelpVC.swift
//  MyTatva
//
//  Created by hyperlink on 27/10/21.
//

import UIKit

class FoodQuantityCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg             : UIView!
    @IBOutlet weak var imgQuantity      : UIImageView!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblQuantity      : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 16)
            .textColor(color: UIColor.ThemeDarkBlack)
        self.lblQuantity.font(name: .regular, size: 14).textColor(color: UIColor.ThemeDarkBlack)
        
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 7)
            self.vwBg.applyViewShadow(shadowOffset: .zero, shadowColor: UIColor.themeBlack, shadowOpacity: 0.1, shdowRadious: 4)
        }
    }
}


class FoodQuantityHelpVC: ClearNavigationFontBlackBaseVC{

    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var btnHelp      : UIButton!
    @IBOutlet weak var lblHelp      : UILabel!
    @IBOutlet weak var colView      : UICollectionView!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = FoodQuantityHelpVM()
    let refreshControl              = UIRefreshControl()
    var isEdit                      = false
    
    var strErrorMessage : String    = ""
    
    //Language: English, Hindi, Kannad
    
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        DispatchQueue.main.async {
            
        }
        self.lblHelp.font(name: .regular, size: 18).textColor(color: UIColor.ThemeDarkBlack)
        self.configureUI()
        self.manageActionMethods()
      
    }
    
    @objc func updateAPIData(){
        //self.viewModel.apiCallFromStart(colView: self.colView, refreshControl: self.refreshControl, withLoader: false)
    }
    
    //Desc:- Set layout desing customize
    
    func configureUI(){
    
        self.colView.emptyDataSetSource         = self
        self.colView.emptyDataSetDelegate       = self
        self.colView.delegate                   = self
        self.colView.dataSource                 = self
        self.colView.reloadData()
        self.refreshControl.addTarget(self, action: #selector(self.updateAPIData), for: UIControl.Event.valueChanged)
        self.colView.addSubview(self.refreshControl)
           
        DispatchQueue.main.async {
           
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        
    }
    
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModelObserver()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


//----------------------------------------------------------------------------
//MARK:- UICollectionView Methods
//----------------------------------------------------------------------------
extension FoodQuantityHelpVC : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getCount()
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : FoodQuantityCell = collectionView.dequeueReusableCell(withClass: FoodQuantityCell.self, for: indexPath)
    
        let object = self.viewModel.getObject(index: indexPath.row)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = (collectionViewLayout as? UICollectionViewFlowLayout)
        
        let width = collectionView.bounds.width - ((layout?.sectionInset.left ?? 25) * 2)
        let height = 124 * ScreenSize.heightAspectRatio
        let strHeight = self.viewModel.getObject(index: indexPath.row)["name"].stringValue.heightOfString(usingFont: UIFont.customFont(ofType: .semibold, withSize: 16))
        
        return CGSize(width: width / 2, height: height + strHeight)
    }
}

//MARK: -------------------------- Empty TableView Methods --------------------------
extension FoodQuantityHelpVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.strErrorMessage
        let attributes = [NSAttributedString.Key.font: UIFont.customFont(ofType: .medium, withSize: 13.0) , NSAttributedString.Key.foregroundColor: UIColor.themeBlack]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//MARK: ------------------ UITableView Methods ------------------
extension FoodQuantityHelpVC {
    
    fileprivate func setData(){
        
    }
}


//MARK: -------------------- setupViewModel Observer --------------------
extension FoodQuantityHelpVC {
    
    private func setupViewModelObserver() {
        // Result binding observer
        
        self.viewModel.vmResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen
                self.strErrorMessage = self.viewModel.strErrorMessage
                self.setData()
                break
                
            case .failure(let error):
                Alert.shared.showSnackBar(error.errorDescription ?? "", isError: true)
                
            case .none: break
            }
        })
    }
}
