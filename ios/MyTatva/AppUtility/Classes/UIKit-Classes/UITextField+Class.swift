//
//  UITextField+Class.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class CustomSkyTextField: SkyFloatingLabelTextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setStyle()
    }
    
    func setStyle() {
        self.lineHeight = 0
        self.backGroundColor(color: .clear)
        self.borderStyle = .none
        self.textColor(color: .themeBlack)
        self.placeHolderColor = .themeGray
        self.font(name: .medium, size: 16)
        
        self.titleFont = UIFont(name: "Poppins-Regular", size: 14)!
        self.placeholderFont = UIFont(name: "Poppins-Regular", size: 14)!
        self.titleFormatter = { $0 }
        selectedLineHeight = 0
        selectedTitleColor = .themeGray
        
        titleColor = .themeGray
    }
    
//    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
//        return CGRect(x: 0, y: -12, width: self.bounds.width, height: self.bounds.height)
//    }
}

class ThemeTextField: TextFieldPedding {
    private var padding: UIEdgeInsets           = UIEdgeInsets()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        padding = UIEdgeInsets(top: 18, left: 10, bottom: 18, right: 10)
        //self.layer.cornerRadius = 5
        self.textColor = UIColor.themeBlack
        self.font = UIFont.customFont(ofType: .medium, withSize: 15)
        self.placeHolderColor = UIColor.themeGray// #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1)
//        self.backgroundColor = UIColor.white
//        self.borderColor(color: UIColor.ThemeBorder, borderWidth: 1)
        self.applyThemeTextfieldBorderView(withError: false)
        self.autocorrectionType = .no
    }
}

class ThemeTextFieldNoBorder: TextFieldPedding {
    private var padding: UIEdgeInsets           = UIEdgeInsets()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        padding = UIEdgeInsets(top: 18, left: 10, bottom: 18, right: 10)
        self.layer.cornerRadius = 5
        self.textColor = UIColor.themeBlack
        self.font = UIFont.customFont(ofType: .medium, withSize: 15)
        self.placeHolderColor = #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1)
        self.backgroundColor = UIColor.white
        self.borderColor(color: UIColor.clear, borderWidth: 0)
        self.autocorrectionType = .no
    }
    
}

class ThemeTextFieldNoBorderCenter: TextFieldPedding {
    private var padding: UIEdgeInsets = UIEdgeInsets()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        padding = UIEdgeInsets(top: 18, left: 10, bottom: 18, right: 10)
        self.layer.cornerRadius = 5
        self.textAlignment = .center
        self.textColor = UIColor.themeBlack
        self.font = UIFont.customFont(ofType: .medium, withSize: 15)
        self.placeHolderColor = #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1)
        self.backgroundColor = UIColor.white
        self.borderColor(color: UIColor.ThemeBorder, borderWidth: 0)
    }
}

class TextFieldPedding: UITextField {
    @IBInspectable var leftPadding : CGFloat = 7
    @IBInspectable var rightPadding : CGFloat = 7
    
    @IBInspectable var isCopyEditEnabled: Bool  = true
    
    private var padding: UIEdgeInsets = UIEdgeInsets()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if Bundle.main.isArabicLanguage {
            padding = UIEdgeInsets(top: 0, left: rightPadding, bottom: 0, right: leftPadding)
        } else {
            padding = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: rightPadding)
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
//    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: bounds.width - 50, y: 0, width: 40 , height: bounds.height)
//    }
//    
//    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: 10, y: 0, width: 20 , height: bounds.height)
//    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if #available(iOS 16.0, *) {
            if  action == #selector(UIResponderStandardEditActions.findAndReplace(_:)){
                return isCopyEditEnabled
            }
        }
        
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)) where !isCopyEditEnabled,
            #selector(UIResponderStandardEditActions.select(_:)) where !isCopyEditEnabled,
            #selector(UIResponderStandardEditActions.selectAll(_:)) where !isCopyEditEnabled,
            #selector(UIResponderStandardEditActions.copy(_:)) where !isCopyEditEnabled,
            #selector(UIResponderStandardEditActions.cut(_:)) where !isCopyEditEnabled,
            #selector(UIResponderStandardEditActions.delete(_:)) where !isCopyEditEnabled:
            return false
        default:
            //return true : this is not correct
            return super.canPerformAction(action, withSender: sender)
        }
    }
}

//dont select action in textfield
class RestrictionTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.autocorrectionType = .no
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    //    override func caretRect(for position: UITextPosition) -> CGRect {
    //        return CGRect.zero
    //    }
    
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.select(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)){
            return false
        }
        else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
}

class OTPTextField: UITextField {
    //    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.borderColor(color: UIColor.colorFromHex(hex: 0xC8C8C8).withAlphaComponent(0.6), borderWidth: 1)
        self.borderStyle = .none
        self.keyboardType = .asciiCapableNumberPad
     //   self.isSecureTextEntry = true
        self.textColor = UIColor.themeBlack
        self.font = UIFont.customFont(ofType: .bold, withSize: 25)
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.themeGray,
            NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 35)!
        ]

        self.attributedPlaceholder = NSAttributedString(string: "\u{2022}", attributes:attributes)
        
        self.textAlignment = .center
//        self.placeholder = "\u{2022}"
//        self.placeHolderColor = UIColor.themeGray
        self.delegate = self
        self.addTarget(self, action: #selector(textfieldIsEditing(_:)), for: .editingChanged)
        self.addTarget(self, action: #selector(textfieldIsEditing(_:)), for: .editingChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
    }
    
    //
    //    override open func textRect(forBounds bounds: CGRect) -> CGRect {
    //        return bounds.inset(by: padding)
    //    }
    //
//        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//            return bounds.inset(by: UIEdgeInsets(top: -17, left: 0, bottom: 0, right: 0))
//        }
    //
    //    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    //        return bounds.inset(by: padding)
    //    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("--------------------------------")
        if string.isEmpty {
            return true
        }
        if textField.text?.count == 1{
            textField.text = ""
            return true && string.isValid(.number)
        }
        print("--------------------------------")
        return true && string.isValid(.number)
    }
    
    @objc func textfieldIsEditing(_ textField:UITextField) {
        if !textField.text!.isEmpty{
            if IQKeyboardManager.shared.canGoNext{
                IQKeyboardManager.shared.goNext()
            } else {
                self.resignFirstResponder()
            }
           // self.borderColor(color: UIColor(named: "ThemeGreen") ?? .green, borderWidth: 1)
        } else {
           // self.borderColor(color: UIColor.colorFromHex(hex: 0xC8C8C8).withAlphaComponent(0.6), borderWidth: 1)
        }
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        if IQKeyboardManager.shared.canGoPrevious{
            IQKeyboardManager.shared.goPrevious()
        }
    }
}


class ThemeFloatingTextField: SkyFloatingLabelTextField {
    
    override func awakeFromNib() {
        self.titleFormatter = { $0 }
        super.awakeFromNib()
        
        self.textColor(color: .themeBlack2)
//        self.borderColor = .themeBorder2
//        self.borderWidth = 1.0
        self.tintColor = .themeBlack2
        self.backgroundColor = .white
        self.font = UIFont.customFont(ofType: .semibold, withSize: 14)
        self.titleFont = UIFont.customFont(ofType: .regular, withSize: 10)
        self.placeholderFont = UIFont.customFont(ofType: .regular, withSize: 14)
        self.placeholderColor = .themeGray4
        self.selectedLineColor = .clear
        self.selectedTitleColor = .themeGray5
        self.titleColor =  .themeGray5
        self.cornerRadius(cornerRadius: 12)
        self.lineHeight = 0
        self.delegate = self
    }
    
    var padding  = UIEdgeInsets(top: 6, left: 16, bottom: -8, right: 16)
    var editingPadding  = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.text!.isEmpty ? bounds.inset(by: editingPadding) : bounds.inset(by: padding) //bounds.inset(by: editingPadding)
    }
    
    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        if editing {
            return CGRect(x: padding.left, y: padding.top, width: titleWidth() + 10, height: titleHeight())
        }
        return CGRect(x: padding.left, y: titleHeight(), width: titleWidth(), height: titleHeight())
    }
 
    /*func textFieldDidBeginEditing(_ textField: UITextField) {
        self.editingPadding = self.padding
    }*/
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
//        self.editingPadding = self.padding
        self.editingPadding =  textField.text!.isEmpty ? self.editingPadding : self.padding
        
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        self.editingPadding = updatedText.isEmpty ? UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) : self.padding
        textField.editingRect(forBounds: textField.bounds.inset(by: self.editingPadding))
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
}
