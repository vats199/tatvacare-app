//
//  SocialLoginManager.swift
//  VisBiLiTi
//
//  Created by KISHAN_RAJA on 24/03/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

//import Foundation
//import FBSDKCoreKit
//import FBSDKLoginKit
//import AuthenticationServices
//import GoogleSignIn
//import CryptoKit
//import FirebaseAuth
//import Firebase
//
//enum SocialLoginType: String {
//    case Google
//    case Facebook
//    case Apple
//    case Normal
//}
//
//struct SocialLoginDataModel {
//
//    init() {
//
//    }
//
//    var socialId: String!
//    var loginType: SocialLoginType!
//    var firstName: String!
//    var lastName: String!
//    var email: String!
//    var profileImage: String?
//}
//
//protocol SocialLoginDelegate: AnyObject {
//    func socialLoginData(data: SocialLoginDataModel)
//}
//
//class SocialLoginManager: NSObject {
//
//    //MARK: Class Variable
////    static let shaared: SocialLoginManager = SocialLoginManager()
//    weak var delegate: SocialLoginDelegate? = nil
//    var AppleLoginByFirebase: Bool = false
//    fileprivate var currentNonce: String?
//
//    //init
//    override init() {
//
//    }
//}
//
////MARK : Apple Login
//extension SocialLoginManager {
//
//    //MARK: Apple Login Methods
//    /// Open apple login view
//    @available(iOS 13.0, *)
//    func performAppleLogin() {
//
//        self.AppleLoginByFirebase = false
//        //request
//        let appleIdProvider = ASAuthorizationAppleIDProvider()
//        let authoriztionRequest = appleIdProvider.createRequest()
//        authoriztionRequest.requestedScopes = [.fullName, .email]
//
//        //Apple’s Keychain sign in // give the resukt of save id - password for this app
//        let passwordProvider = ASAuthorizationPasswordProvider()
//        let passwordRequest = passwordProvider.createRequest()
//
//
//        //create authorization controller
//        let authorizationController = ASAuthorizationController(authorizationRequests: [authoriztionRequest]) //[authoriztionRequest, passwordRequest]
//        authorizationController.presentationContextProvider = self
//        authorizationController.delegate = self
//        authorizationController.performRequests()
//    }
//
//    @available(iOS 13.0, *)
//    func performFirebaseAppleLogin() {
//        self.AppleLoginByFirebase = true
//
//        let firebaseAuth = Auth.auth()
//        do {
//          try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//          print("Error signing out: %@", signOutError)
//        }
//
//        //request
//        let nonce = randomNonceString()
//        currentNonce = nonce
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//        request.nonce = sha256(nonce)
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//
//    //apple button
//    @available(iOS 13.0, *)
//    func getAppleButton() -> ASAuthorizationAppleIDButton {
//        let btnLoginButton = ASAuthorizationAppleIDButton()//(authorizationButtonType: .continue, authorizationButtonStyle: .whiteOutline)// (type: .signIn, style: .whiteOutline)
//
//        //add action
//        btnLoginButton.addAction(for: .touchUpInside) { [weak self] in
//            guard let self = self else { return }
//
//            //request
//            let appleIdProvider = ASAuthorizationAppleIDProvider()
//            let authoriztionRequest = appleIdProvider.createRequest()
//            authoriztionRequest.requestedScopes = [.fullName, .email]
//
//            //Apple’s Keychain sign in
//            let passwordProvider = ASAuthorizationPasswordProvider()
//            let passwordRequest = passwordProvider.createRequest()
//
//
//            //create authorization controller
//            let authorizationController = ASAuthorizationController(authorizationRequests: [authoriztionRequest]) //[authoriztionRequest, passwordRequest]
//            authorizationController.presentationContextProvider = self
//            authorizationController.delegate = self
//            authorizationController.performRequests()
//
//        }
//        return btnLoginButton
//    }
//
//    @available(iOS 13.0, *)
//    private func handleAppleIDAuthorization(appleIDCredential: ASAuthorizationAppleIDCredential?, passwordCredential: ASPasswordCredential?) {
//        if let appleIDCredential = appleIDCredential { // normal system login
//
//            let userIdentifier = appleIDCredential.user
//
//            //            if let authorizationCode = appleIDCredential.authorizationCode,
//            //                let identifyToken = appleIDCredential.identityToken {
//            //                print("Authorization Code: \(authorizationCode)")
//            //                print("Identity Token: \(identifyToken)")
//            //
//            //                //First time user, perform authentication with the backend
//            //                //TODO: Submit authorization code and identity token to your backend for user validation and signIn
//            //
//            //
//            //
//            //
//            //                return
//            //            }
//
//            if let identityTokenData = appleIDCredential.identityToken,
//                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
//                print("Identity Token \(identityTokenString)")
//            }
//
//
//            //Check apple credential state
//            let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
//
//            authorizationAppleIDProvider.getCredentialState(forUserID: userIdentifier) { [weak self] (credentialState: ASAuthorizationAppleIDProvider.CredentialState, error: Error?) in
//                guard let self = self else { return }
//
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
//
//                    if let error = error {
//                        print(error)
//                        // Something went wrong check error state
//                        Alert.shared.showAlert(message: AppMessages.somethingWentWrong, completion: nil)
//                        return
//                    }
//
//                    switch (credentialState) {
//                    case .authorized:
//                        //User is authorized to continue using your app
//                        // The Apple ID credential is valid. Show Home UI Here
//
//                        if appleIDCredential.email != nil {
//                            //KeychainItem.currentUserIdentifier = appleIDCredential.user
//                            KeychainItem.currentUserFirstName = appleIDCredential.fullName?.givenName
//                            KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
//                            KeychainItem.currentUserEmail = appleIDCredential.email
//
//                        }
//
//                        //Call delegate
//                        if let delegate = self.delegate {
//
//                            var dataObj: SocialLoginDataModel = SocialLoginDataModel()
//                            dataObj.socialId = userIdentifier
//                            dataObj.loginType = .Apple
//                            dataObj.firstName =  KeychainItem.currentUserFirstName ?? ""//myUserDefault.string(forKey: kFirstName) ?? ""
//                            dataObj.lastName = KeychainItem.currentUserLastName ?? ""//myUserDefault.string(forKey: kLastName) ?? ""
//                            dataObj.email = KeychainItem.currentUserEmail ?? ""//myUserDefault.string(forKey: kEmail) ?? ""
//                            delegate.socialLoginData(data: dataObj)
//
//                        }
//
//                    case .revoked:
//                        //User has revoked access to your app
//                        // The Apple ID credential is revoked. Show SignIn UI Here.
//                        //Logout user
//                        UIApplication.shared.forceLogOut()
//                        break
//
//                    case .notFound:
//                        Alert.shared.showAlert(message: AppMessages.somethingWentWrong, completion: nil)
//                        //User is not found, meaning that the user never signed in through Apple ID
//                        // No credential was found. Show SignIn UI Here.
//
//                    default: break
//                    }
//                }
//            }
//
//        } else if let passwordCredential = passwordCredential {
//            print("User: \(passwordCredential.user)")
//            print("Password: \(passwordCredential.password)")
//
//            //TODO: Fill your email/password fields if you have it and submit credentials securely to your server for authentication
//
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
//                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
//                let alertController = UIAlertController(title: "Keychain Credential Received",
//                                                        message: message,
//                                                        preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//                UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
//            }
//        }
//    }
//}
//
////MARK : Apple Login Delegate
//
//@available(iOS 13.0, *)
//extension SocialLoginManager: ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return UIApplication.topViewController()!.view.window!
//    }
//}
//
//@available(iOS 13.0, *)
//extension SocialLoginManager: ASAuthorizationControllerDelegate {
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//
//        if self.AppleLoginByFirebase {
//            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//                guard let nonce = currentNonce else {
//                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
//                }
//                guard let appleIDToken = appleIDCredential.identityToken else {
//                    print("Unable to fetch identity token")
//                    return
//                }
//                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                    return
//                }
//                // Initialize a Firebase credential.
//                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
//
//                // Sign in with Firebase.
//                Auth.auth().signIn(with: credential) { (authResult, error) in
//                    if (error != nil) {
//                        print(error?.localizedDescription ?? "")
//                        return
//                    }
//                    guard let userEmail = authResult?.user.email else {
//                        return
//                    }
//
//                    let name = authResult?.user.displayName ?? "No name"
//
//                    let userIdentifier = authResult?.user.uid ?? ""
//
//                    KeychainItem.currentUserFirstName = name
//                    KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
//                    KeychainItem.currentUserEmail = userEmail
//
//                    //Call delegate
//                    if let delegate = self.delegate {
//
//                        var dataObj: SocialLoginDataModel = SocialLoginDataModel()
//                        dataObj.socialId    = userIdentifier
//                        dataObj.loginType   = .Apple
//                        dataObj.firstName   =  KeychainItem.currentUserFirstName ?? ""
//                        dataObj.lastName    = KeychainItem.currentUserLastName ?? ""
//                        dataObj.email       = KeychainItem.currentUserEmail ?? ""
//                        delegate.socialLoginData(data: dataObj)
//                    }
//                }
//            }
//        }
//        else {
//            switch authorization.credential {
//            case let appleIDCredential as ASAuthorizationAppleIDCredential:
//                self.handleAppleIDAuthorization(appleIDCredential: appleIDCredential, passwordCredential: nil)
//
//            case let passwordCredential as ASPasswordCredential:
//                self.handleAppleIDAuthorization(appleIDCredential: nil, passwordCredential: passwordCredential)
//
//            default: break
//
//            }
//        }
//
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("Authorization returned an error: \(error.localizedDescription)")
//    }
//}
//
////MARK: Facebook Login
//extension SocialLoginManager {
//    //MARK: Facebook login methods
//    /// Open facebook login view
//    func performFacebookLogin() {
////        AccessToken.current = nil
////        Profile.current = nil
//        let loginManager = LoginManager()
//        loginManager.logOut()
//
//        loginManager.logIn(permissions: ["public_profile","email"], from: UIApplication.topViewController()) { (loginResult, error) in
//
//            if loginResult?.isCancelled ?? false {
//                return
//            }
//
//            if error == nil {
//                let req = GraphRequest(graphPath: "me", parameters: ["fields":  "id, name, first_name, last_name, gender, email, birthday, picture.type(large)"])
//                req.start(completionHandler: { (connection, response, error) in
//
//                    let resData = JSON(response as Any)
//
//                    //Call delegate
//                    if let delegate = self.delegate {
//
//                        var dataObj: SocialLoginDataModel = SocialLoginDataModel()
//                        dataObj.socialId = resData["id"].stringValue
//                        dataObj.loginType = .Facebook
//                        dataObj.firstName = resData["first_name"].stringValue
//                        dataObj.lastName = resData["last_name"].stringValue
//                        dataObj.email = resData["email"].stringValue
//
//                        dataObj.profileImage = resData["picture"]["data"]["url"].stringValue
//                        delegate.socialLoginData(data: dataObj)
//                    }
//
//                })
//            } else if error != nil {
//                Alert.shared.showAlert(message: error?.localizedDescription ?? "", completion: nil)
//            }
//        }
//    }
//}
//
////MARK: Google Login
//extension SocialLoginManager {
//    //MARK: Google login methods
//    /// Open google login view
//    func performGoogleLogin() {
//        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.topViewController()
//        GIDSignIn.sharedInstance()?.delegate = self
//        GIDSignIn.sharedInstance().signOut()
//        GIDSignIn.sharedInstance().signIn()
//    }
//}
//
////MARK: Google login delegate
//extension SocialLoginManager : GIDSignInDelegate{
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            print(error.localizedDescription)
//
//        } else {
//            //Call delegate
//            if let delegate = self.delegate {
//
//                var dataObj: SocialLoginDataModel = SocialLoginDataModel()
//                dataObj.socialId = user.userID
//                dataObj.loginType = .Google
//                dataObj.firstName = user.profile.givenName
//                dataObj.lastName = user.profile.familyName
//                dataObj.email = user.profile.email
//                if user.profile.hasImage {
//                    dataObj.profileImage = user.profile.imageURL(withDimension: 100)?.description
//                }
//
//                delegate.socialLoginData(data: dataObj)
//            }
//        }
//    }
//}
//
//extension SocialLoginManager {
//
//    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
//    private func randomNonceString(length: Int = 32) -> String {
//      precondition(length > 0)
//      let charset: Array<Character> =
//          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
//      var result = ""
//      var remainingLength = length
//
//      while remainingLength > 0 {
//        let randoms: [UInt8] = (0 ..< 16).map { _ in
//          var random: UInt8 = 0
//          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
//          if errorCode != errSecSuccess {
//            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
//          }
//          return random
//        }
//
//        randoms.forEach { random in
//          if remainingLength == 0 {
//            return
//          }
//
//          if random < charset.count {
//            result.append(charset[Int(random)])
//            remainingLength -= 1
//          }
//        }
//      }
//
//      return result
//    }
//
//    @available(iOS 13, *)
//    private func sha256(_ input: String) -> String {
//      let inputData = Data(input.utf8)
//      let hashedData = SHA256.hash(data: inputData)
//      let hashString = hashedData.compactMap {
//        return String(format: "%02x", $0)
//      }.joined()
//
//      return hashString
//    }
//}
