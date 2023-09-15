//
//  ExerciseMoreTblCell.swift


import UIKit
import AVKit

class ExerciseMoreTblCell: UITableViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var btnViewMore          : UIButton!
    
    @IBOutlet weak var colView              : UICollectionView!
    @IBOutlet weak var colViewHeight        : NSLayoutConstraint!
    
    var object = ExerciseMoreListModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addObserverOnHeightTbl()
        
//        self.lblTitle
//            .font(name: .semibold, size: 23)
//            .textColor(color: UIColor.themeBlack)
    
        self.btnViewMore
            .font(name: .semibold, size: 15)
            .textColor(color: UIColor.themePurple)
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 0)
        }
        self.setup(collectionView: self.colView)
    }
    
    deinit {
        self.removeObserverOnHeightTbl()
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    func setup(collectionView: UICollectionView){
        collectionView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func setCellData(){
        
    }
}

class ExerciseMoreColCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var vwImgTitle           : UIView!
    @IBOutlet weak var imgTitle             : UIImageView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    @IBOutlet weak var btnPlay              : UIButton!
    
    @IBOutlet weak var btnLike              : UIButton!
    @IBOutlet weak var btnBookmark          : UIButton!
    @IBOutlet weak var btnShare             : UIButton!
    @IBOutlet weak var btnInfo              : UIButton!
    
    @IBOutlet weak var lblLikeCount         : UILabel!
    
    @IBOutlet weak var vwRead               : UIView!
    @IBOutlet weak var lblRead              : UILabel!
    
    @IBOutlet weak var vwFitnessLevel       : UIView!
    @IBOutlet weak var lblFitnessLevel      : UILabel!
    
    @IBOutlet weak var vwExerciseTool       : UIView!
    @IBOutlet weak var lblExerciseTool      : UILabel!
    
    var videoUrl: URL?
    var player: AVPlayer?
    let avPVC = AVPlayerViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle
            .font(name: .semibold, size: 17)
            .textColor(color: UIColor.themeBlack)
        
        self.lblDesc
            .font(name: .regular, size: 14)
            .textColor(color: UIColor.themeBlack)
    
        self.lblRead
            .font(name: .semibold, size: 9)
            .textColor(color: UIColor.themeBlack)
        
        self.lblFitnessLevel
            .font(name: .semibold, size: 9)
            .textColor(color: UIColor.themeBlack)
        
        self.lblExerciseTool
            .font(name: .semibold, size: 9)
            .textColor(color: UIColor.themeBlack)
        
        self.lblLikeCount
            .font(name: .semibold, size: 11)
            .textColor(color: UIColor.themeBlack.withAlphaComponent(0.8))
        
        DispatchQueue.main.async  {
            self.vwBg.layoutIfNeeded()
            self.vwBg.cornerRadius(cornerRadius: 10)
                .borderColor(color: UIColor.themePurple, borderWidth: 0)
            
            self.imgTitle.layoutIfNeeded()
            self.imgTitle.roundCorners([.topLeft, .topRight], radius: 10)
            
            self.vwRead.layoutIfNeeded()
            self.vwRead.cornerRadius(cornerRadius: 2)
                .backGroundColor(color: UIColor.themeLightGray)
            
            self.vwFitnessLevel.layoutIfNeeded()
            self.vwFitnessLevel.cornerRadius(cornerRadius: 2)
                .backGroundColor(color: UIColor.themeLightGray)
            
            self.vwExerciseTool.layoutIfNeeded()
            self.vwExerciseTool.cornerRadius(cornerRadius: 2)
                .backGroundColor(color: UIColor.themeLightGray)
            
            self.btnPlay.layoutIfNeeded()
            self.btnPlay.themeShadow()
        }
    }
    
}

//MARK: -------------------------- UICollectionView Methods --------------------------
extension ExerciseMoreTblCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        
        case self.colView:
            if self.object.contentData != nil {
                return self.object.contentData.count
            }
            return 0
       
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        
        case self.colView:
            let cell : ExerciseMoreColCell = collectionView.dequeueReusableCell(withClass: ExerciseMoreColCell.self, for: indexPath)
            
            let obj = self.object.contentData[indexPath.item]
            
            cell.lblTitle.text              = obj.title
            cell.lblDesc.text = ""
            DispatchQueue.main.async {
                cell.lblDesc.text           = obj.descriptionField.htmlToString
            }
            
            if self.object.genreMasterId.trim() == "" {
                //this is exercise of the week
                cell.vwBg.layoutIfNeeded()
                cell.vwBg.borderColor(color: UIColor.themePurple, borderWidth: 1)
            }
            else {
                cell.vwBg.layoutIfNeeded()
                cell.vwBg.borderColor(color: UIColor.themePurple, borderWidth: 0)
            }
            
//            self.vwTopic.isHidden = true
//            if self.object.topicName.trim() != "" {
//                self.vwTopic.isHidden = false
//                self.lblTopic.text                  = self.object.topicName
//            }
            
            cell.vwRead.isHidden        = true
            cell.lblRead.text           = AppMessages.Duration + " \(obj.timeDuration!)" + " " + obj.durationUnit
            cell.lblFitnessLevel.text   = AppMessages.FitnessLevel + " \(obj.fitnessLevel!)"
            cell.lblExerciseTool.text   = AppMessages.ExerciseTool + " \(obj.exerciseTools!)"
            
            if obj.media.count > 0 {
                cell.imgTitle.setCustomImage(with: obj.media[0].imageUrl)
            }
            
            cell.btnLike.isHidden = obj.likeCapability == "No" ? true : false
            cell.lblLikeCount.isHidden = obj.likeCapability == "No" ? true : false
            
            cell.btnBookmark.isHidden = obj.bookmarkCapability == "No" ? true : false
            
            cell.btnLike.isSelected = obj.liked == "N" ? false : true
            cell.btnBookmark.isSelected = obj.bookmarked == "N" ? false : true
            
            cell.lblLikeCount.text      = obj.noOfLikes.roundedWithAbbreviations
            
            cell.btnPlay.addTapGestureRecognizer {
                if obj.media.count > 0 {
                    kGoalMasterId = obj.goalMasterId
                    GFunction.shared.openVideoPlayer(strUrl: obj.media[0].mediaUrl,
                                                     content_master_id: obj.contentMasterId,
                                                     content_type: obj.contentType)
                    
                    var param = [String : Any]()
                    param[AnalyticsParameters.content_master_id.rawValue]   = obj.contentMasterId
                    param[AnalyticsParameters.content_type.rawValue]        = obj.contentType
                    FIRAnalytics.FIRLogEvent(eventName: .USER_PLAY_VIDEO_EXERCISE,
                                             screen: .VideoPlayer,
                                             parameter: nil)
                    //cell.initVideoPlayer(strUrl: obj.media[0].mediaUrl)
                }
            }
            
            cell.btnLike.addTapGestureRecognizer {
                if cell.btnLike.isSelected {
                    cell.btnLike.isSelected = false
                    obj.liked = "N"
                    obj.noOfLikes -= 1
                    
                    GlobalAPI.shared.update_likesAPI(content_master_id: obj.contentMasterId,
                                                     content_type: obj.contentType,
                                                     is_active: "N",
                                                     screen: .ExerciseMore) { [weak self] (isDone, msg) in
                        guard let _ = self else {return}
                        if isDone{
                        }
                    }
                }
                else {
                    cell.btnLike.isSelected = true
                    obj.liked = "Y"
                    obj.noOfLikes += 1
                    
                    GlobalAPI.shared.update_likesAPI(content_master_id: obj.contentMasterId,
                                                     content_type: obj.contentType,
                                                     is_active: "Y",
                                                     screen: .ExerciseMore) { [weak self] (isDone, msg) in
                        guard let _ = self else {return}
                        
                        if isDone{
                        }
                    }
                }
                self.colView.reloadData()
            }
            
            cell.btnBookmark.addTapGestureRecognizer {
                PlanManager.shared.isAllowedByPlan(type: .bookmarks,
                                                   sub_features_id: "",
                                                   completion: { isAllow in
                    if isAllow {
                        if cell.btnBookmark.isSelected {
                            cell.btnBookmark.isSelected = false
                            obj.bookmarked = "N"
                            
                            GlobalAPI.shared.update_bookmarksAPI(content_master_id: obj.contentMasterId,
                                                                 content_type: obj.contentType,
                                                                 is_active: "N",
                                                                 forQuestion: false,
                                                                 screen: .ExerciseMore) { [weak self] (isDone, msg) in
                                guard let _ = self else {return}
                                
                                if isDone{
                                }
                            }
                        }
                        else {
                            cell.btnBookmark.isSelected = true
                            obj.bookmarked = "Y"
                            
                            GlobalAPI.shared.update_bookmarksAPI(content_master_id: obj.contentMasterId,
                                                                 content_type: obj.contentType,
                                                                 is_active: "Y",
                                                                 forQuestion: false,
                                                                 screen: .ExerciseMore) { [weak self] (isDone, msg) in
                                guard let _ = self else {return}
                                if isDone{
                                }
                            }
                        }
                    }
                    else {
                        PlanManager.shared.alertNoSubscription()
                    }
                })
            }
            
            cell.btnInfo.addTapGestureRecognizer {
                let vc = ExerciseInfoPopupVC.instantiate(fromAppStoryboard: .exercise)
                vc.infoTitle = obj.title
                vc.infoDesc = obj.descriptionField
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                if let parentVc = self.parentViewController as? ExerciseMoreVC{
                    parentVc.present(vc, animated: true, completion: nil)
                }
            }
            
            return cell
            
        default: return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        
        case self.colView:
            
            break
        
        default:break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch collectionView {
        
        case self.colView:
            //let obj         = self.arrTitle[indexPath.item]
            //let width       = obj["name"].stringValue.width(withConstraintedHeight: 18.0, font: UIFont.customFont(ofType: .semibold, withSize: 18.0))
            let width       = self.colView.frame.size.width / 1.1
            let height      = self.colView.frame.size.height
            
//            let cell : ExerciseMoreColCell = collectionView.dequeueReusableCell(withClass: ExerciseMoreColCell.self, for: indexPath)
//            height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel).height
            

            return CGSize(width: width,
                          height: height)
        default:
            
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height)
        }
    }
    
}

//MARK: -------------------------- UIScrollViewDelegate Methods --------------------------
extension ExerciseMoreTblCell: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.colView {
            if !decelerate {
                self.colView.scrollToCenter()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.colView {
            self.colView.scrollToCenter()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.colView {

//            let visibleRect = CGRect(origin: self.colView.contentOffset, size: self.colView.bounds.size)
//            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//            if let visibleIndexPath = self.colView.indexPathForItem(at: visiblePoint) {
//                self.pageControlMedia.setPage(visibleIndexPath.row)
//            }
        }
    }
    
}

//MARK: -------------------------- Observers Methods --------------------------
extension ExerciseMoreTblCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if let obj = object as? UICollectionView, obj == self.colView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            //let oldHeight = self.colViewHeight.constant
            //self.colViewHeight.constant = newvalue.height
            
//            if let tbl = self.superview as? UITableView {
//                if oldHeight != self.colViewHeight.constant {
//                    tbl.reloadData()
//                }
//            }
        }
   
    }
    
    func addObserverOnHeightTbl() {
        self.colView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      
    }
    
    func removeObserverOnHeightTbl() {
        
        guard let colView = self.colView else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

//MARK: -------------------------- Video player Methods --------------------------
extension ExerciseMoreColCell {
    
    func initVideoPlayer(strUrl: String){
        // 3. make sure the url your using isn't nil
//        self.videoUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")

        
        //self.videoUrl = URL(string: "http://3.7.8.99/hugs_basket/assets/upload/Pexels%20Videos%204697%20(1).mp4")
        
//        if self.object.media.count > 0 {
            
//        }
//        else {
//            Alert.shared.showSnackBar(AppMessages.noVideoData)
//            return
//        }
        
        self.videoUrl = URL(string: strUrl)
        
        guard let videoUrl = videoUrl else {
            Alert.shared.showSnackBar(AppMessages.noVideoData)
            return
        }

        // 4. init an AVPlayer object with the url then set the class property player with the AVPlayer object
        self.player = AVPlayer(url: videoUrl)
        self.player?.play()
        
        // 5. set the class property player to the AVPlayerViewController's player
        self.avPVC.player = self.player
        
        // 6. set the the parent vc's bounds to the AVPlayerViewController's frame
        self.avPVC.view.frame                       = self.vwImgTitle.bounds
        self.avPVC.showsPlaybackControls            = true
        
        // 7. the parent vc has a method on it: addChildViewController() that takes the child you want to add to it (in this case the AVPlayerViewController) as an argument
        //self.addChild(self.avPVC)
        
        // 8. add the AVPlayerViewController's view as a subview to the parent vc
        //self.vwImgTitle.addSubview(self.avPVC.view)
        
        // 9. on AVPlayerViewController call didMove(toParentViewController:) and pass the parent vc as an argument to move it inside parent
        //self.avPVC.didMove(toParent: self)
        UIApplication.topViewController()?.present(self.avPVC, animated: true, completion: {
        })
    }
    
    func stopPlayer() {
        if let play = self.player {
            print("stopped")
            play.pause()
            self.player = nil
            print("player deallocated")
            self.avPVC.dismiss(animated: true, completion: nil)
            self.avPVC.removeFromParent()
            self.avPVC.view.removeFromSuperview()
        } else {
            print("player was already deallocated")
        }
    }
}
