//
//  ViewController.swift
//  WritingBlock
//
//  Created by Robert Sikorski on 2/19/16.
//  Copyright © 2016 Robert Sikorski. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NewFileDialogueDelegate {
    @IBOutlet weak var backgroundImageView: NSImageView!
    @IBOutlet var writingBlockTextView: NSTextView!
    let dataController: DataController = DataController()


    override func viewDidLoad() {
        super.viewDidLoad()
        writingBlockTextView.font = NSFont(name: "Helvetica Neue", size: 24)
        loadCurrentDocument()

        let defaults = UserDefaults.standard
        defaults.addObserver(self, forKeyPath: "darkModeEnabled", options: .new, context: nil)
        backgroundImageView.wantsLayer = true
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "darkModeEnabled") {
            let darkModeEnabled = change?[.newKey] as! Bool
            updateUiFor(DarkModeEnabled: darkModeEnabled)
        }
    }

    func updateUiFor(DarkModeEnabled darkModeEnabled: Bool) {
        if (darkModeEnabled) {
            writingBlockTextView.backgroundColor = NSColor(red: 0.15, green: 0.12, blue: 0.10, alpha: 1.0)
            writingBlockTextView.textColor = NSColor(red: 0.9, green: 0.9, blue:0.9, alpha: 1.0)
            writingBlockTextView.insertionPointColor = NSColor(red: 0.9, green: 0.9, blue:0.9, alpha: 1.0)
            backgroundImageView.layer?.backgroundColor = CGColor(red: 0.07, green: 0.05, blue: 0.0, alpha: 1.0)
        } else {
            writingBlockTextView.backgroundColor = .white
            writingBlockTextView.textColor = .black
            writingBlockTextView.insertionPointColor = .black
            backgroundImageView.layer?.backgroundColor = CGColor.clear
        }
    }

    // MARK: - FirstResponder Methods
    func newDocument(_ sender: AnyClass) {
        let newFileDialogue = self.storyboard?.instantiateController(withIdentifier: "NewFileDialogueViewController") as! NewFileDialogueViewController
        newFileDialogue.delegate = self
        self.presentViewControllerAsSheet(newFileDialogue)
    }

    func saveDocument(_ sender: AnyClass) {
        let currentDocumentPath = dataController.getCurDocumentUrl()
        if currentDocumentPath == nil {
            selectSaveDocument()
            saveWritingBlock()
        } else {
            saveWritingBlock()
        }
    }

    func saveDocumentAs(_ sender: AnyClass) {
        selectSaveDocument()
        saveWritingBlock()
    }

    func selectSaveDocument() {
        let saveFileDialogue = NSSavePanel()
        saveFileDialogue.allowedFileTypes = ["txt"]
        saveFileDialogue.canCreateDirectories = true
        saveFileDialogue.allowsOtherFileTypes = false
        if saveFileDialogue.runModal() == NSModalResponseOK {
            let filePath = saveFileDialogue.url
            dataController.setCurDocumentUrl(filePath!)
            dataController.createNewDocument()
        }
    }

    func saveWritingBlock() {
        let preferences = UserDefaults.standard
        let currentDocumentPath = preferences.url(forKey: "currentDocumentPath")
        if currentDocumentPath != nil {
            dataController.saveDocument(currentDocumentPath, textStorage: writingBlockTextView.textStorage)
        }
    }

    func openDocument(_ sender: AnyClass) {
        // TODO: Implement openDocument
        let openFileDialogue = NSOpenPanel()
        openFileDialogue.canChooseFiles = true
        openFileDialogue.canChooseDirectories = false
        openFileDialogue.allowsMultipleSelection = false
        openFileDialogue.allowedFileTypes = ["txt"] // TODO: Implement rtf handling.
        if openFileDialogue.runModal() == NSModalResponseOK {
            let filePath = openFileDialogue.urls[0] // Is it fine to just assume we have a file (and only one) given the above events/constraints?
            dataController.setCurDocumentUrl(filePath)
            loadCurrentDocument()
        }
    }

    func loadCurrentDocument() {
        guard let unwrappedTextStorage = writingBlockTextView.textStorage else {
            NSLog("writingBlockTextView.textStorage could not be unwrapped")
            return
        }
        unwrappedTextStorage.beginEditing()
        unwrappedTextStorage.replaceCharacters(in: NSRange.init(location: 0, length: unwrappedTextStorage.length), with: dataController.curDocumentContents())
        unwrappedTextStorage.font = NSFont(name: "Helvetica Neue", size: 24)
        unwrappedTextStorage.endEditing()
    }

    // MARK: - NewFileDialogueDelegate Method
    func setUpNewWritingBlock() {
        dataController.setUpNewDocument()
        let writingBlockTextLength = self.writingBlockTextView.textStorage?.length
        if writingBlockTextLength != nil {
            self.writingBlockTextView.setSelectedRange(NSRange.init(location: 0, length: writingBlockTextLength!))
            self.writingBlockTextView.delete(nil)
        }
    }
}
