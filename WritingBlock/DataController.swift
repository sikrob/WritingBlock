//
//  DataController.swift
//  WritingBlock
//
//  Created by Robert Sikorski on 2/19/16.
//  Copyright © 2016 Robert Sikorski. All rights reserved.
//

import Cocoa

class DataController {
    let preferences = UserDefaults.standard

    func setUpNewDocument() {
        if preferences.url(forKey: "currentDocumentPath") != nil {
            preferences.set(nil, forKey: "currentDocumentPath")
        }
    }

    func getCurDocumentUrl() -> URL? {
        return preferences.url(forKey: "currentDocumentPath")
    }

    func setCurDocumentUrl(_ newUrl: URL) {
        preferences.set(newUrl, forKey: "currentDocumentPath")
    }

    func curDocumentContents() -> String {
        let fileUrl = preferences.url(forKey: "currentDocumentPath") as URL?
        if fileUrl != nil {
            if FileManager.default.fileExists(atPath: (fileUrl?.path)!) {
                var fileContents = "" as String?
                do {
                    let fileHandle = try FileHandle(forReadingFrom: fileUrl!)
                    fileContents = String(data: fileHandle.readDataToEndOfFile(), encoding: String.Encoding.utf8) // TODO: Check if there is a non NSFileHandle way to do this
                } catch {
                    NSLog("Error on curDocuementContents() call for extant currentDocumentPath URL")
                }
                if fileContents != nil {
                    return fileContents!
                }
            }
        }
        return "" // TODO: return completely empty string? Or even nil?
    }

    func createNewDocument() {
        let fileUrl = preferences.url(forKey: "currentDocumentPath") as URL?
        if fileUrl != nil {
            do {
                try "".write(to: fileUrl!, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                NSLog("Error on createNewDocument")
            }
        }
    }

    func saveDocument(_ documentPath: URL?, textStorage: NSTextStorage?) {
        var path = nil as URL?
        if documentPath == nil {
            path = preferences.url(forKey: "currentDocumentPath")
            if (path == nil) {
                NSLog("no path is available to save the file")
                return
            }
        } else {
            path = documentPath
        }
        guard let unwrappedTextStorage = textStorage else {
            NSLog("testStorage is nil, text can not be saved to document")
            return
        }
        do {
            try unwrappedTextStorage.string.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            NSLog("Error on saveDocument(…) call for extant filePath and textStorage")
        }
    }
}
