//
//  RecordsVC.swift
//  MyTatva
//
//  Created by hyperlink on 25/10/21.
//

import UIKit
import SwiftUI

class VideoAppointmentVC: ClearNavigationFontBlackBaseVC {
    
    //----------------------------------
    //MARK:- UIControl's Outlets
    @IBOutlet weak var lblTitleTop          : UILabel!
    
    @IBOutlet weak var vwCamera1            : VideoView!
    
    @IBOutlet weak var vwCamera2Parent      : UIView!
    @IBOutlet weak var vwCamera2            : VideoView!
    @IBOutlet weak var vwBottom             : UIView!
    
    @IBOutlet weak var btnBack              : UIButton!
    @IBOutlet weak var btnMute              : UIButton!
    @IBOutlet weak var btnSpeaker           : UIButton!
    @IBOutlet weak var btnVideoOff          : UIButton!
    @IBOutlet weak var btnVideoFlip         : UIButton!
    @IBOutlet weak var btnCancel            : UIButton!
    
    @IBOutlet weak var vwMuteUser           : UIView!
    @IBOutlet weak var lblMuteUser          : UILabel!
    
    //----------------------------------------------------------------------------
    //MARK:- Class Variables
    let viewModel                   = VideoAppointmentVM()
    let refreshControl              = UIRefreshControl()
    var selectedDate                = Date()
    var selectedDoctorClinic        = ClinicDoctorResult()
    var selectedType                = JSON()
    var selectedTimeSlot            = ""
    var strErrorMessage : String    = ""
    var strTitle                    = ""
    var appointment_id              = ""
    
    // Create an audio track
    var localAudioTrack: LocalAudioTrack!
    // Create a data track
    var localDataTrack                          = LocalDataTrack()
    
    // Create a CameraSource to provide content for the video track
    var camera                                  = CameraSource()
    
    // Create a CameraSource to provide content for the video track
    var localVideoTrack : LocalVideoTrack?
    
    var room : Room?
    var participant: [RemoteParticipant]        = [RemoteParticipant]()
    var remoteParticipant: RemoteParticipant?
    //var arrParticipantNewObj: [VideoCallParticipate] = [VideoCallParticipate]()
    
    var flagForPreviewInVideo: Bool             = false //True - Video Off, False  - Video On
    var flagForMuteInVideo: Bool                = false //True - Mute, False - UnMute
    
    let audioEngine                             = AVAudioEngine()
    var audioDevice                             = DefaultAudioDevice()

    var video : LocalVideoTrack?
    var strAccessToken                          = ""
    var strUserIdVideoCall                      = ""
    var strUserNameVideoCall                    = ""
    var strUserImageVideoCall                   = ""
    var strRoomSid                              = "123"
    var strRoomName                             = "123"
    var type                                    = ""
    var mAudioPlayer : AVAudioPlayer?
    var arrAllParticipates: [JSON]              = [JSON.null]
    var strAudioVideoCallTokent: String         = ""
    var strVideoCallTimerReceiverSide           = Timer() //For start timer to disconnect call in some minutes If receiver is not take any action
    var strVideoCallCountReceiverSide: Int      = 0 //For start time to disconnect call in some minutes If receiver is not take any action
    var panGesture       = UIPanGestureRecognizer()

    var initialState: PIPState { return .full }
    var pipSize: CGSize { return CGSize(width: ScreenSize.width/2.5, height: ScreenSize.width/1.7) }
    var pipCorner: PIPCorner { return .init(radius: 7, curve: .circular) }
    //----------------------------------------------------------------------------
    //MARK:- Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    deinit {
        GFunction.shared.deinitWithClass(className: self.classForCoder)
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Custome Methods
    
    //Desc:- Centre method to call in View
    func setUpView(){
        
        self.lblMuteUser
            .font(name: .medium, size: 11)
            .textColor(color: UIColor.white)
        
        self.vwMuteUser.isHidden = true
        self.configureUI()
        self.manageActionMethods()
        self.lblTitleTop.text = self.strTitle
        self.lblMuteUser.text = self.strTitle + " " + AppMessages.mutedTheCall
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.vwCamera1.layoutIfNeeded()
            self.vwCamera2.layoutIfNeeded()
            self.initPanGesture()
            self.initTwilio()
            
//              let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTS2E3ODA4YjkzYTBjMDBkOWQ0NTE4ZDNkM2M4ZTI2ZTc5LTE2NTA4ODU3NzEiLCJncmFudHMiOnsiaWRlbnRpdHkiOiI5NzM4M2E3Ny01N2MwLTExZWMtYjMwZC0yOGIyMDNmNmNhMTJfMC4zNjE2NDU3MjA4MDcwMjIwNl84MTE0Iiwidm9pY2UiOnsiaW5jb21pbmciOnsiYWxsb3ciOnRydWV9LCJvdXRnb2luZyI6eyJhcHBsaWNhdGlvbl9zaWQiOiJlZDExZTdiYmVjYTk0Y2UyN2YzNDdiYTA2ZjIzMzBiMyJ9LCJwdXNoX2NyZWRlbnRpYWxfc2lkIjoiQ1IzY2VkYjU2OGJhY2QwNjJiYmQzZDg3NmFjMDhiZTViNCJ9LCJ2aWRlbyI6eyJyb29tIjoiY2FiYWM4YjVjNDYzMTFlY2E1NjdmZTdlNzllNjE3YmMifX0sImlhdCI6MTY1MDg4NTc3MSwiZXhwIjoxNjUwODg5MzcxLCJpc3MiOiJTS2E3ODA4YjkzYTBjMDBkOWQ0NTE4ZDNkM2M4ZTI2ZTc5Iiwic3ViIjoiQUNiOWRmYWU4NjVkZjc5MTEyNWQ4NjNkMjY5OWI4MzY4ZiJ9.ACFOhBCHCVh5rOhboIJ5_ABlpK6NEi5dKWE2BWIT9v4"
//
//                self.connectToRoom(accessToken: token,
//                                   roomName: "cabac8b5c46311eca567fe7e79e617bc")
            
            
            GlobalAPI.shared.get_voicetokenAPI(room_id: self.strRoomSid,
                                               room_name: self.strRoomName,
                                               type: self.type,
                                               appointment_id: self.appointment_id,
                                               completion: { [weak self] isDone, token, identity in
                guard let self = self else {return}
                if isDone {
                    self.connectToRoom(accessToken: token,
                                       roomName: self.strRoomName)
                }
            })
        }
    }
    
    //DESC:- Set layout desing customize
    
    func configureUI(){
        DispatchQueue.main.async {
            self.vwCamera2Parent.layoutIfNeeded()
            self.vwBottom.layoutIfNeeded()
            self.vwBottom.cornerRadius(cornerRadius: 10)
            
//            self.vwCamera1.layoutIfNeeded()
//            self.vwCamera1.cornerRadius(cornerRadius: 10)
            
            self.vwCamera2.layoutIfNeeded()
            self.vwCamera2.cornerRadius(cornerRadius: 10)
            //self.vwCamera.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
            
            self.vwMuteUser.layoutIfNeeded()
            self.vwMuteUser.cornerRadius(cornerRadius: 10)
            self.vwMuteUser.backGroundColor(color: UIColor.themeBlack.withAlphaComponent(0.6))
        }
    }
    
    func authenticateForVideo(completion: @escaping (Bool) -> Void){
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //Already Authorized
            completion(true)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //Access Allowed
                    completion(true)
                } else {
                    //Access Denied
                    //AppDelegate.shared.forCameraAlert()
                    completion(false)
                }
            })
        }
    }
    
    func initTwilio(){
        //Set audio device
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {

            if (self.localAudioTrack == nil) {
                self.localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")

                if (self.localAudioTrack == nil) {
                    print("Failed to create audio track")
                }
            }
            
            let options = CameraSourceOptions { (builder) in
                if #available(iOS 13.0, *) {
                    // Track UIWindowScene events for the key window's scene.
                    // The example app disables multi-window support in the .plist (see UIApplicationSceneManifestKey).
                    builder.orientationTracker = UserInterfaceTracker(scene: UIApplication.shared.windows.first!.windowScene!)
                }
            }
            
            // Preview our local camera track in the local video preview view.
            self.camera = CameraSource(options: options, delegate: self)
            self.localVideoTrack = LocalVideoTrack(source: self.camera!, enabled: true, name: "Camera")

            // Add renderer to video track for local preview
            self.vwCamera2.contentMode = .scaleAspectFit
            self.localVideoTrack!.addRenderer(self.vwCamera2)
            self.videoCall(setOn: false)
            print("Video track created")

            if (frontCamera != nil && backCamera != nil) {
                // We will flip camera on tap.
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.flipCamera))
                self.vwCamera2.addGestureRecognizer(tap)
            }

            self.camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    print("Capture failed with error.\ncode = \((error as NSError).code)")
                } else {
                    self.vwCamera2.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            print("No front or back capture device found!")
        }
//        // Create a video track with the capturer.
//        if let camera = CameraSource(delegate: self) {
//            self.localVideoTrack = LocalVideoTrack(source: camera)
//        }
      
    }
    
    func disconnectRoom(){
        // To disconnect from a Room, we call:
        self.localVideoTrack    = nil
        self.localAudioTrack    = nil
        self.localDataTrack     = nil
        self.room?.disconnect()
    }
    
    func connectToRoom(accessToken: String, roomName: String){
        
        let connectOptions = ConnectOptions(token: accessToken) { (builder) in
               
            builder.roomName = roomName
//            builder.isAutomaticSubscriptionEnabled = false

            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
            builder.dataTracks = self.localDataTrack != nil ? [self.localDataTrack!] : [LocalDataTrack]()
            
        }
        self.room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
    }
    
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
                publication.isTrackSubscribed {
                //setupRemoteVideoView()
                self.vwCamera1.contentMode = .scaleAspectFit
                subscribedVideoTrack.addRenderer(self.vwCamera1)
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }

    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
                renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }

    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
//            self.remoteView?.removeFromSuperview()
//            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- Action Methods
    func manageActionMethods(){
        self.btnCancel.addTapGestureRecognizer {
            self.disconnectRoom()
            Alert.shared.showSnackBar(AppMessages.CallDisconnected)
//            self.navigationController?.popViewController(animated: true)
            PIPKit.dismiss(animated: true) {
                print("dismiss")
            }
        }
        
        self.btnBack.addTapGestureRecognizer {
            self.startPIPMode()
        }
       
        self.btnVideoFlip.addTapGestureRecognizer {
            self.flipCamera()
        }
        
        self.btnMute.addTapGestureRecognizer {
            if (self.localAudioTrack != nil) {
                self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
                self.btnMute.isSelected = !self.localAudioTrack!.isEnabled
                
                // Update the button title
//                if (self.localAudioTrack?.isEnabled == true) {
//                    self.btnMute.setTitle("Mute", for: .normal)
//                } else {
//                    self.btnMute.setTitle("Unmute", for: .normal)
//                }
            }
        }
        
        self.btnVideoOff.addTapGestureRecognizer {
            
            self.videoCall(setOn: self.btnVideoOff.isSelected)
            
            /*
             if (self.localVideoTrack != nil) {
                 self.localVideoTrack?.isEnabled = !(self.localVideoTrack?.isEnabled)!
                 self.btnVideoOff.isSelected = !self.localVideoTrack!.isEnabled
                 
                 // Update the button title
 //                if (self.localVideoTrack?.isEnabled == true) {
 //                    self.btnVideoOff.setTitle("Video off", for: .normal)
 //                } else {
 //                    self.btnVideoOff.setTitle("Video on", for: .normal)
 //                }
             } 
             */
           
        }
        
        self.btnSpeaker.addTapGestureRecognizer {
            
//            if self.audioDevice == DefaultAudioDevice() {
//                self.audioDevice.block = {
//                    do {
//                        DefaultAudioDevice.DefaultAVAudioSessionConfigurationBlock()
//
//                        let audioSession = AVAudioSession.sharedInstance()
//                        try audioSession.setMode(.voiceChat)
//                    } catch let error as NSError {
//                        print("Fail: \(error.localizedDescription)")
//                    }
//                }
//
//                self.audioDevice.block();
//            }
//            else {
//                self.audioDevice = DefaultAudioDevice()
//            }
        }
    }
    
    @objc func videoCall(setOn: Bool){
        
        if (self.localVideoTrack != nil) {
            self.localVideoTrack?.isEnabled = setOn
            self.btnVideoOff.isSelected = !setOn
            
            // Update the button title
//                if (self.localVideoTrack?.isEnabled == true) {
//                    self.btnVideoOff.setTitle("Video off", for: .normal)
//                } else {
//                    self.btnVideoOff.setTitle("Video on", for: .normal)
//                }
        }
    }
    
    @objc func flipCamera() {
        var newDevice: AVCaptureDevice?

        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }

            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        print("Error selecting capture device.\ncode = \(error.localizedDescription)")
                    } else {
                        self.vwCamera2.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setupViewModelObserver()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //WebengageManager.shared.navigateScreenEvent(screen: .HistoryRecord)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Appear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = self.parent?.parent as? TabbarVC {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        //FIRAnalytics.manageTimeSpent(on: .HistoryRecord, when: .Disappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

//MARK: --------------------- RoomDelegate methods ---------------------
extension VideoAppointmentVC : RoomDelegate {
    func roomDidConnect(room: Room) {
        self.initPanGesture()
        print("Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")

        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
            
            for audio in remoteParticipant.remoteAudioTracks {
                if audio.isTrackEnabled {
                    self.vwMuteUser.isHidden = true
                }
                else {
                    self.vwMuteUser.isHidden = false
                }
            }
        }
    }

    func roomDidDisconnect(room: Room, error: Error?) {
        print("Disconnected from room \(room.name), error = \(String(describing: error))")
        Alert.shared.showSnackBar(AppMessages.CallDisconnected)
//        self.navigationController?.popViewController(animated: true)
        PIPKit.dismiss(animated: true) {
            print("dismiss")
        }
        self.room = nil
        
        //self.showRoomUI(inRoom: false)
    }

    func roomDidFailToConnect(room: Room, error: Error) {
        let msg = "Failed to connect: \(String(describing: error))"
        print(msg)
        Alert.shared.showSnackBar(msg)
        self.room = nil
        
        //self.showRoomUI(inRoom: false)
    }

    func roomIsReconnecting(room: Room, error: Error) {
        let msg = "Reconnecting to room \(room.name), error = \(String(describing: error))"
        print(msg)
        Alert.shared.showSnackBar(msg)
    }

    func roomDidReconnect(room: Room) {
        print("Reconnected to room \(room.name)")
    }

    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self

         print("Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }

    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        print("""
"Room \(room.name),
participantDidDisconnect \(participant.identity)
""")
        
        if let remainingParticipants = self.room?.remoteParticipants {
            if remainingParticipants.count == 0 {
                Alert.shared.showSnackBar(AppMessages.CallDisconnected)
                self.disconnectRoom()
//                self.navigationController?.popViewController(animated: true)
                PIPKit.dismiss(animated: true) {
                    print("dismiss")
                }
            }
        }
    }
}

//MARK: --------------------- RemoteParticipantDelegate methods ---------------------
extension VideoAppointmentVC : RemoteParticipantDelegate {

    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        print("Participant \(participant.identity) published \(publication.trackName) video track")
    }

    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.

        print("Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }

    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.

        print("Participant \(participant.identity) published \(publication.trackName) audio track")
    }

    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.

        print("Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }

    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.

        print("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")

        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        print("""
"Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)
""")
        
        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()

            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
                let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }

    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        print("Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        print("Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }

    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("Participant \(participant.identity) enabled \(publication.trackName) video track")
    }

    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("Participant \(participant.identity) disabled \(publication.trackName) video track")
    }

    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        
        self.vwMuteUser.isHidden = true
        print("Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }

    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        
        self.vwMuteUser.isHidden = false
        print("Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }

    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }

    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

//MARK: --------------------- VideoViewDelegate methods ---------------------
extension VideoAppointmentVC : VideoViewDelegate {
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}

//MARK: --------------------- CameraSourceDelegate methods ---------------------
extension VideoAppointmentVC : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        print("Camera source failed with error: \(error.localizedDescription)")
    }
}

//MARK: --------------------- Draggable view methods ---------------------
extension VideoAppointmentVC {
    
    func initPanGesture(){
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        self.vwCamera2.isUserInteractionEnabled = true
        self.vwCamera2.addGestureRecognizer(self.panGesture)
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubviewToFront(self.vwCamera2)
        self.vwCamera2.layoutIfNeeded()
        self.vwCamera2Parent.layoutIfNeeded()
        
        switch sender.state {
        case .began, .changed :
            let translation = sender.translation(in: self.view)
            
            //            let nowPoint = translation
            //            let offsetX = nowPoint.x - self.vwCamera2.frame.origin.x
            //            let offsetY = nowPoint.y - self.vwCamera2.frame.origin.y
            //            self.vwCamera2.center = CGPoint(x: self.vwCamera2.center.x + offsetX, y: self.vwCamera2.center.y + offsetY)
            //
            //            self.vwCamera2.center = CGPoint(x: self.vwCamera2.center.x + translation.x,
            //                                      y: self.vwCamera2.center.y + translation.y)
            
            self.vwCamera2.center = CGPoint(x: self.vwCamera2.center.x + translation.x,
                                            y: self.vwCamera2.center.y + translation.y)
            
            sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            self.view.bringSubviewToFront(self.vwCamera2)
            break
        case .ended:
            
            //            let translation = sender.translation(in: self.view)
            
            UIView.animate(withDuration: 0.3, delay: 0) {
                ///Set horizontal position
                if self.vwCamera2.center.x  >= self.vwCamera2Parent.frame.width / 2 {
                    self.vwCamera2.center = CGPoint(x: (self.vwCamera2Parent.frame.width - self.vwCamera2.bounds.size.width / 2),
                                                    y: self.vwCamera2.center.y )
                } else {
                    self.vwCamera2.center = CGPoint(x: self.vwCamera2.bounds.size.width / 2,
                                                    y: self.vwCamera2.center.y )
                }
                
                ///Set vertical position
                if self.vwCamera2.center.y  < self.vwCamera2Parent.frame.size.height / 2 {
                    self.vwCamera2.center = CGPoint(x: self.vwCamera2.center.x,
                                                    y: self.vwCamera2Parent.bounds.origin.y + self.vwCamera2.bounds.size.height / 2)
                }
                else if self.vwCamera2.center.y  > self.vwCamera2Parent.frame.size.height / 2 {
                    self.vwCamera2.center = CGPoint(x: self.vwCamera2.center.x,
                                                    y: self.vwCamera2Parent.frame.height - self.vwCamera2.bounds.size.height / 2)
                }
            }
            self.view.bringSubviewToFront(self.vwCamera2)
            break
        default:
            break
        }
        
    }
}

//MARK: --------------------- PIPUsable methods ---------------------
extension VideoAppointmentVC: PIPUsable {
    
    func viewController() -> VideoAppointmentVC {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let viewController = storyboard.instantiateViewController(withIdentifier: "PIPXibViewController") as? PIPXibViewController else {
//            fatalError("PIPXibViewController is null")
//        }
//        return viewController
        
//        let vc = VideoAppointmentVC.instantiate(fromAppStoryboard: .carePlan)
        
        return self
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if PIPKit.isPIP {
            stopPIPMode()
        } else {
//            startPIPMode()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

    }
    
    func didChangedState(_ state: PIPState) {
        switch state {
        case .pip:
            self.vwBottom.isHidden      = true
            self.vwCamera2.isHidden     = true
            self.btnBack.isHidden       = true
            print("PIPViewController.pip")
        case .full:
            self.vwBottom.isHidden      = false
            self.vwCamera2.isHidden     = false
            self.btnBack.isHidden       = false
            print("PIPViewController.full")
        }
    }
    
}

