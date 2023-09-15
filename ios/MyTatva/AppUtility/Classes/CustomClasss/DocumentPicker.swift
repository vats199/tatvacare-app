//
//  DocumentPicker.swift
//  DocumentPicker
//
//

import UIKit
import MobileCoreServices

class DocumentPicker: NSObject {
    
    // MARK: - Internal Properties
    private var documentPickerController: UIDocumentPickerViewController?
    
    // MARK: - Closure Completion Blocks
    
    /// Closure block for picked file
    private var onPicked: (([URL]) -> Void)?
    
    /// Closure block for cancel picker
    private var onCancelled: (() -> Void)?
    
    // MARK: - Init
    override init() {
        super.init()
    }
    
    /// Creates and returns a document picker that can open the specified file types.
    /// - Parameters:
    ///   - documentTypes: Document file types.
    ///   - allowsMultipleSelection: Flag to allow multiple selection. Default false.
    init(documentTypes: [DocumentType], allowsMultipleSelection: Bool = false) {
        self.documentPickerController = UIDocumentPickerViewController(documentTypes: documentTypes.map({$0.type}), in: .import)
        super.init()
        self.documentPickerController?.allowsMultipleSelection = allowsMultipleSelection
        self.documentPickerController?.delegate = self
    }
    
    // MARK: - Class Custom Function
    /// Present the UIDocumentPickerViewController.
    /// - Parameters:
    ///   - controller: Target controller to present on.
    ///   - modalPresentationStyle: Controller presentation style. Default formSheet.
    ///   - completion: Completion block execute after the presenting picker controller.
    /// - Returns: Return Document Picker.
    @discardableResult
    func present(on controller: UIViewController, with modalPresentationStyle: UIModalPresentationStyle = .formSheet, completion: (() -> Void)? = nil) -> Self {
        self.documentPickerController?.modalPresentationStyle = modalPresentationStyle
        if let documentPickerController = documentPickerController {
            controller.present(documentPickerController, animated: true, completion: completion)
        }
        return self
    }
    
    /// Gives the URLs of file.
    /// - Parameter block: Completion block of URLs
    /// - Returns: Return Document Picker.
    @discardableResult
    func onPicked(_ block: @escaping (([URL]) -> Void)) -> Self {
        self.onPicked = block
        return self
    }
    
    /// Execute on cancel document picker action.
    /// - Parameter block: Completion block.
    /// - Returns: Return Document Picker.
    @discardableResult
    func onCancelled(_ block: @escaping (() -> Void)) -> Self {
        self.onCancelled = block
        return self
    }
}

// MARK: - UIDocumentPicker Delegate
extension DocumentPicker: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.onPicked?(urls)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: onCancelled)
    }
}

// MARK: - Document Picker File Type
extension DocumentPicker {
    
    /// Document file types of documents.
    enum DocumentType {
        case all
        case image
        case spreadsheet
        case presentation
        case database
        case folder
        case zipArchive
        case video
        case audiovisualContent
        case custom(String)
        case contact
        case text
        case plainText
        case html
        case script
        case json
        case pdf
        case jpeg
        case rtfd
        case webArchive
        case gif
        case png
        case rawImage
        case movie
        case audio
        case quickTimeMovie
        case aVIMovie
        case waveformAudio
        case calendarEvent
        case emailMessage
        case internetLocation
        case inkText
        case font
        case bookmark
        case log
        
        var type: String {
            switch self {
            case .all: return "public.item"
            case .audiovisualContent: return String(kUTTypeAudiovisualContent)
            case .database: return String(kUTTypeDatabase)
            case .folder: return String(kUTTypeFolder)
            case .image: return String(kUTTypeImage)
            case .presentation: return String(kUTTypePresentation)
            case .spreadsheet: return String(kUTTypeSpreadsheet)
            case .video: return String(kUTTypeVideo)
            case .zipArchive: return String(kUTTypeZipArchive)
            case .contact: return String(kUTTypeContact)
            case .text: return String(kUTTypeText)
            case .plainText: return String(kUTTypePlainText)
            case .html: return String(kUTTypeHTML)
            case .script: return String(kUTTypeScript)
            case .json: return String(kUTTypeJSON)
            case .pdf: return String(kUTTypePDF)
            case .rtfd: return String(kUTTypeRTFD)
            case .webArchive: return String(kUTTypeWebArchive)
            case .gif: return String(kUTTypeGIF)
            case .png: return String(kUTTypePNG)
            case .jpeg: return String(kUTTypeJPEG)
            case .rawImage: return String(kUTTypeRawImage)
            case .movie: return String(kUTTypeMovie)
            case .audio: return String(kUTTypeAudio)
            case .quickTimeMovie: return String(kUTTypeQuickTimeMovie)
            case .aVIMovie: return String(kUTTypeAVIMovie)
            case .waveformAudio: return String(kUTTypeWaveformAudio)
            case .calendarEvent: return String(kUTTypeCalendarEvent)
            case .emailMessage: return String(kUTTypeEmailMessage)
            case .internetLocation: return String(kUTTypeInternetLocation)
            case .inkText: return String(kUTTypeInkText)
            case .font: return String(kUTTypeFont)
            case .bookmark: return String(kUTTypeBookmark)
            case .log: return String(kUTTypeLog)
            case .custom(let type): return type
            }
        }
    }
}
