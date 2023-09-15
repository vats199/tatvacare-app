//
//  GExtension+String.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension String {
    enum ValidationType: String {
        case alphabet = "[A-Za-z]+"
        case alphabetWithSpace = "[A-Za-z ]*"
        case alphabetNum = "[A-Za-z-0-9]*"
        case alphabetNumWithSpace = "[A-Za-z0-9 ]*"
        case userName = "[A-Za-z0-9 _]*"
        case name = "^[A-Z a-z]*$"
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        case number = "[0-9]+"
        case password = "^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$"
        case mobileNumber = "^[0-9]{8,11}$"
        case postalCode = "^[A-Za-z0-9- ]{1,10}$"
        case zipcode = "^[A-Za-z0-9]{4,}$"
        case currency = "^([0-9]+)(\\.([0-9]{0,2})?)?$"
        case amount = "^\\s*(?=.*[1-9])\\d*(?:\\.\\d{1,2})?\\s*$"
        case website = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    }
    
    func isContainsEmoji() -> Bool {
        return self.rangeOfCharacter(from: NSCharacterSet.symbols) == nil
    }
    
    func isValid(_ type: ValidationType) -> Bool {
        guard !isEmpty else { return false }
        let regTest = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        return regTest.evaluate(with: self)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var masked: String {
        if self.count >= 16 {
            let characters  = Array(self)
            var arrTemp     = [String]()
            for i in 0...characters.count - 1 {
//                if i % 4 == 0 && i != 0{
//                    arrTemp.insert("-", at: i)
//                }
                if i < 4 || i > 11 {
                    arrTemp.append(String(characters[i]))
                }
                else {
                    arrTemp.append("x")
                }
            }

            return arrTemp.joined().inserting(separator: "-", every: 4)
        }
        return ""
    }
    
    func url() -> URL {
        guard let url = URL(string: self) else {
            return URL(string : "www.google.co.in")!
        }
        return url
    }
    
    func isBackspace() -> Bool {
        let  char = self.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            return true
        }
        return false
    }
    
    func last(index: Int) -> String? {
        guard count > index else { return nil }
        return self.reversed()[index].description
    }
    
    /*func removeSpecialCharsFromString() -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        return String(self.characters.filter {okayChars.contains($0) })
    }*/
    
    func getAttributedText ( defaultDic : [NSAttributedString.Key : Any] , attributeDic : [NSAttributedString.Key : Any]?, attributedStrings : [String]) -> NSMutableAttributedString {
        
        let attributeText : NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: defaultDic)
        for strRange in attributedStrings {
            if let range = self.range(of: strRange) {
                let startIndex = self.distance(from: self.startIndex, to: range.lowerBound)
                let range1 = NSMakeRange(startIndex, strRange.count)
                attributeText.setAttributes(attributeDic, range: range1)
            }
        }
        return attributeText
    }
    
    func getAttributedText ( defaultDic : [NSAttributedString.Key : Any] , attributeDics : [[NSAttributedString.Key : Any]], attributedStrings : [String]) -> NSMutableAttributedString {
        
        let attributeText : NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: defaultDic)
        
        let hasDuplicates = attributedStrings.count != Set(attributedStrings).count

        
        let arrRange = self.rangesForWords(attributedStrings)
        if let arrRanges = arrRange,
           arrRanges.count == attributedStrings.count {
            
            for i in 0...attributedStrings.count - 1 {
                let strRange = attributedStrings[i]
                for j in 0...attributeDics.count - 1 {
                    let attributeDic = attributeDics[j]
                    if i == j {
                        attributeText.setAttributes(attributeDic, range: arrRanges[i])
                    }
                }
                
            }
        }
        else {
            for i in 0...attributedStrings.count - 1 {
                let strRange        = attributedStrings[i]
                if let range = self.range(of: strRange) {
                    let startIndex      = self.distance(from: self.startIndex,
                                                        to: range.lowerBound)
                    let range1          = NSMakeRange(startIndex, strRange.count)
                    
                    for j in 0...attributeDics.count - 1 {
                        let attributeDic = attributeDics[j]
                        if i == j {
                            attributeText.setAttributes(attributeDic, range: range1)
                        }
                    }
                }
            }
        }
        
        return attributeText
    }
    
    func rangesForWords(_ words: [String]) -> [NSRange]? {
        
        var ranges: [NSRange] = []
        
        let ptrn = words.joined(separator: "|")

        do {
            let regex = try NSRegularExpression(pattern: ptrn, options: [.caseInsensitive])
            let items = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            let arrRange = items.map{$0.range}
//            for i in 0...arrRange.count - 1 {
//                let range = arrRange[i]
//                ranges.append(NSMakeRange(range.location, words[i].count))
//            }
            
            for i in 0...words.count - 1 {
                if i <= arrRange.count - 1 {
                    let range = arrRange[i]
                    ranges.append(NSMakeRange(range.location, words[i].count))
                }
            }

        } catch {
            // regex was bad?
            return nil
        }
        
        return ranges
    }
    
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
              let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
              !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }

    func getHashtags() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.range(at: 1)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        })
    }
    
    func unescapeString() -> String {
        return self.replacingOccurrences(of: "\\", with: "", options: String.CompareOptions.literal, range: nil)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func sizeOfString (font : UIFont) -> CGSize {
        return self.boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude),
                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                 attributes: [NSAttributedString.Key.font: font],
                                 context: nil).size
    }
    
    func getFormatedNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let number =  Double(self) {
            if let strNumber = formatter.string(from: NSNumber(value: number)) {
                return strNumber
            }
        }
        return self
    }
    
    func fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /**
     To Get UIAlertAction from String
     
     - Parameter style: UIAlertAction Style
     - Parameter handler: To Handle events
     
     */
    func addAction(style : UIAlertAction.Style  = .default , handler : AlertActionHandlerd? = nil) -> UIAlertAction{
        return UIAlertAction(title: self.localized, style: style, handler: handler)
    }
    
    /**
     To get attributed underline text
     
     - Returns: attributed underline text
     */
    func addUnderline() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}

typealias AlertActionHandlerd = ((UIAlertAction) -> Void)

class StringResourceUtility {
    static func Localizer() -> (_ key: String, _ params: CVaListPointer) -> String {
        return { (key: String, params: CVaListPointer) in
            let content = NSLocalizedString(key, tableName: nil, bundle: Bundle.main.getBundleName(), value: "", comment: "")
            return NSString(format: content, arguments: params) as String
        }
    }
}

extension String {
    func numberToLocale(localeIdentifier: String = "EN") -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeIdentifier)
        guard let resultNumber = numberFormatter.number(from: self) else{
            return self
        }
        return resultNumber.stringValue
    }
}

// -----------------------------------------------------------------------------------------------------------------------------

// MARK: - Width Of String -

extension String {
    func heightForText(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension String {
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}

extension String {
    var digits: String {
        return String(filter(("0"..."9").contains))
    }
    
    func applyPatternOnNumbers(pattern: String = kPhonePattern, replacmentCharacter: Character = kPhonePatternReplaceChar) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}

extension String {
    
    func decimalRegex(maxLength: Int, decimalLength: Int) -> String {
        return "^([0-9][0-9]{0,\(maxLength - 1)}(\\.)?[0-9]{0,\(decimalLength)})?$"
    }
    /**
     Get attributed string from html string
     */
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding:String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToMutableAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSMutableAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding:String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
    /**
     Get string from html string
     */
    var htmlToString: String {
        return htmlToMutableAttributedString?.string ?? ""
    }
    
    public func isImageType() -> Bool {
        // image formats which you want to check
        let imageFormats = ["jpg", "png", "gif", "jpeg"]

        
        if self.isURL() {
            if let ext = self.getExtension() {
                return imageFormats.contains(ext)
            }
        }
        return false
    }
 
    public func getExtension() -> String? {
        let ext = (self as NSString).pathExtension
        
        if ext.isEmpty {
            return nil
        }
        
        return ext
    }
    
    public func isURL() -> Bool {
        return URL(string: self) != nil
    }
}

extension String {
    
    /// To get array from HTML text and separate by <li> tag.
    var htmlToStringArray: [String] {
        self.components(separatedBy: "<li>").map({$0.withoutHtmlTags.trim()}).filter({!$0.isEmpty})
        
    }
    
    /// To get pure string remove all HTML text from string
    var withoutHtmlTags: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with: " ", options:.regularExpression, range: nil)
    }
}


extension String {
    func changeTimeFormat(currentFormat: String, requireFormat: String) -> String {
        let df = DateFormatter()
        df.dateFormat = currentFormat
        df.timeZone = TimeZone(abbreviation: "UTC")
        guard let currentDate = df.date(from: self) else { return self }
        df.dateFormat = requireFormat
        df.timeZone = TimeZone.current
        return df.string(from: currentDate)
    }
}

extension String {
    /// Create unique random string with given string length. Default 10.
    /// - Parameter length: String length.
    /// - Returns: Return unique random string.
    static func uniqueRandom(length: Int = 10) -> Self {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        let timeStamp = Date().timeIntervalSince1970
        
        return randomString + "\(String(format: "%0.0f", timeStamp))"
    }
}

extension Collection {
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: maxLength, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return self[start..<end]
        }
    }

    func every(n: Int) -> UnfoldSequence<Element,Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            defer { index = self.index(index, offsetBy: n, limitedBy: endIndex) ?? endIndex }
            return self[index]
        }
    }

    var pairs: [SubSequence] { .init(unfoldSubSequences(limitedTo: 2)) }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.every(n: n).dropFirst().reversed() {
            insert(contentsOf: separator, at: index)
        }
    }
    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        .init(unfoldSubSequences(limitedTo: n).joined(separator: separator))
    }
}

extension NSAttributedString {
    convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            // not sure which is more reliable: String.Encoding.utf16 or String.Encoding.unicode
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}
