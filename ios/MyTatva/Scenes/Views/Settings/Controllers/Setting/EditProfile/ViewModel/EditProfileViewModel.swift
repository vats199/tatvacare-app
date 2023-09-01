
//  Created by 2020M03 on 16/06/21.
//

import Foundation
import UIKit

class EditProfileViewModel {
    
    //MARK:- Class Variable
    
    private(set) var vmResult = Bindable<Result<String?, AppError>>()
    private var strProfileImage = ""
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        GFunction.shared.deinitWithClass(className: self)
        
    }
}

// MARK: Validation Methods
extension EditProfileViewModel {
    
    /// Validate login fields
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView( profileImage: UIImage,
                              name: String,
                              email: String,
                              dob: String) -> AppError? {
        
        if name.trim() == "" {
            return AppError.validation(type: .enterName)
        }
        else if !Validation.isAtleastOneAlphabaticString(txt: name) {
            return AppError.validation(type: .enterValidName)
        }
        else if email.trim() == "" {
            return AppError.validation(type: .enterEmail)
        }
        else if !email.isValid(.email) {
            return AppError.validation(type: .enterValidEmail)
        }
       
        return nil
    }
}

// MARK: Web Services
extension EditProfileViewModel {
    
    func apiUpdatePatientDetails(vc: UIViewController,
                          profileImage: UIImage,
                          name: String,
                          email: String,
                          dob: String) {
        
        // Check validation
        if let error = self.isValidView(profileImage: profileImage,
                                        name: name,
                                        email: email,
                                        dob: dob) {
            //Set data for binding
            self.vmResult.value = .failure(error)
            return
        }
        
        func updateData(){
            GlobalAPI.shared.updateProfileAPI(dob: dob,
                                              name: name,
                                              email: email,
                                              profile_pic: self.strProfileImage,
                                              address: "") { [weak self] (isDone) in
                guard let self = self else {return}
                if isDone {
                    self.vmResult.value = .success(nil)
                }
            }
          
        }
        
        func imageUploadSetup(){
            ApiManager.shared.addLoader()
            let dispatchGroup = DispatchGroup()
            
            
            //For attach note upload
            dispatchGroup.enter()
            ImageUpload.shared.uploadImage(true,
                                           profileImage,
                                           nil,
                                           BlobContainer.kAppContainer,
                                           prefix: .user) { (str1, str2) in
//                print(str1)
//                print(str2)
                self.strProfileImage = str2 ?? ""
                dispatchGroup.leave()
            }
           
            
            dispatchGroup.notify(queue: .main) {
                //When media images upload done
                ApiManager.shared.removeLoader()
                updateData()
            }
        }
        
        //----------------------------------------------
        if profileImage != UIImage(named: "defaultUser") {
            imageUploadSetup()
        }
        else {
            updateData()
        }
    }
}

