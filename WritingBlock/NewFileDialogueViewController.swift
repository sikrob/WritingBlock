//
//  NewFileDialogueViewController.swift
//  WritingBlock
//
//  Created by Robert Sikorski on 2/19/16.
//  Copyright © 2016 Robert Sikorski. All rights reserved.
//

import Cocoa

class NewFileDialogueViewController: NSViewController {
    @IBOutlet weak var confirmButton: NSButton!
    var delegate: NewFileDialogueDelegate? = nil

    @IBAction func buttonPressed(_ sender: NSButton) {
        if (sender == confirmButton) {
            guard let unwrappedDelegate = delegate else {
                NSLog("NewFileDialogueViewController delegate:NewFileDialogueDelegate is nil")
                return
            }
            unwrappedDelegate.setUpNewWritingBlock()
        }
        self.dismissViewController(self)
    }
}

protocol NewFileDialogueDelegate {
    func setUpNewWritingBlock()
}
