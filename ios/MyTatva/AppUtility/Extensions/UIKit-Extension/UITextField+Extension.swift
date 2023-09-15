//
//  UITextField+Extension.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

var kRegex = "kRegex"
var kdefaultCharacter = "kdefaultCharacter"
var kPatternCharacter = "kPatternCharacter"
var kMaxLength  =   "kMaxLength"


extension UITextField: UITextFieldDelegate {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 10.0, *) {
            self.adjustsFontForContentSizeCategory = true
        }

        if let placeHolderValue = self.placeholder {
            self.placeholder = placeHolderValue.localized
           // print("NSLocalizedString UITextField placeholder :::::::::::::::: \(placeHolderValue)")
        }
        
        self.semanticContentAttribute = Bundle.main.isArabicLanguage ? .forceRightToLeft : .forceLeftToRight
        self.textAlignment = Bundle.main.isArabicLanguage ? .right : self.textAlignment//.left
    }
    
//    var maxLength : Int? {
//        set {
//            self.delegate = self
//            objc_setAssociatedObject(self, &kMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//        get {
//            return objc_ge tAssociatedObject(self, &kMaxLength) as? Int
//        }
//    }
    
    var regex : String? {
        set {
            self.delegate = self
            objc_setAssociatedObject(self, &kRegex, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &kRegex) as? String
        }
    }
    
    var defaultcharacterSet : CharacterSet? {
        set {
            self.delegate = self
            objc_setAssociatedObject(self, &kdefaultCharacter, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &kdefaultCharacter) as? CharacterSet
        }
    }
    
    var patterText : String? {
        set {
            self.delegate = self
            objc_setAssociatedObject(self, &kPatternCharacter, newValue, .OBJC_ASSOCIATION_RETAIN)
            self.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
            if let pattern = self.patterText , !self.text!.isEmpty {
                self.text = self.text!.applyPatternOnNumbers(pattern: pattern, replacmentCharacter: "5")
            }
        }
        get {
            return objc_getAssociatedObject(self, &kPatternCharacter) as? String
        }
    }
    
    @objc func textDidChange(_ textField : UITextField){
        if let pattern = self.patterText , self.text!.count < pattern.count {
            self.text = self.text!.applyPatternOnNumbers(pattern: pattern, replacmentCharacter: "5")
        }
        else {
            self.resignFirstResponder()
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        
        let str = text + string
        guard str.count > 0 else {
            return false
        }
        
        if string.isEmpty && range.length > 0 {
            textField.text = text.count > range.length ? String(text.dropLast(range.length)) : ""
            return false
        }
        
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        
        if range.location == 0 && (string == " ") {
            return false
        }
        let isBackSpace         = strcmp(string, "\\b")
        if (isBackSpace == -92) {
            return true
        }
        
        
        
        if let rx = self.regex {
            let regexPattern = try! NSRegularExpression(pattern: rx, options: [.caseInsensitive])
            return regexPattern.matches(in: textField.text! + string, options: [], range: NSRange(location: 0, length: (textField.text! + string).count)).count > 0
        }
        
//        if regex != nil {
//            let textFieldText: NSString = self.text!as NSString
//            let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
//
//            if regex?.trim() != "" {
//                let test = NSPredicate(format: "SELF MATCHES %@", regex!)
//                if test.evaluate(with: txtAfterUpdate) {
//                    return true
//                }
//                return false
//            }
//            return true
//        }
        
        if let characters = self.defaultcharacterSet {

            if  self.maxLength != 0 , newLength > self.maxLength {
                return false
            }

            let inverseSet = characters.inverted

            let components = string.components(separatedBy: inverseSet)

            let filtered = components.joined(separator: "")

            return string == filtered

        }
        
//        if let length = self.maxLength , length != 0 , newLength > length{
//            return false
//        }
        if let pattern = self.patterText , newLength > pattern.count {
            return false
        }
        
        return true
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UITextField {
    
    func hasValid(_ type: String.ValidationType) -> Bool {
        guard let txt = text else { return false }
        return txt.isValid(type)
    }
    
    var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var cleanTrimmedText: String {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    var isEmpty: Bool {
        return text?.isEmpty == true
    }
    
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    func setLeftImage(img: UIImage?) {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgView.image = img
        imgView.contentMode = .center
        leftView = imgView
        leftViewMode = .always
    }
    
    func setRightImage(img: UIImage?, contentMode: ContentMode = .right) {
        let imgView         = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgView.image       = img
        imgView.contentMode = contentMode
        rightView           = imgView
        rightViewMode       = .always
    }
    
    func setBottomBorder(borderColor: UIColor) {
        
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 1.0
        
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - width, width: Double(self.frame.width), height: width)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
    func getWidth(text: String) -> CGFloat
    {
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
    
}


private var __maxLengths = [UITextField: Int]()
extension UITextField {
    var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
