//
//  SRWordsCellView.swift
//  SpeedReader
//
//  Created by Bright on 7/16/17.
//  Copyright © 2017 Kay Yin. All rights reserved.
//

import Cocoa

class SRWordsCellView: SRGeneralPrefCellView {
    @IBOutlet weak var disclosureTriangle: NSButton!
    @IBOutlet weak var topLabel: NSButton!


    @IBOutlet weak var wordsPerRoll: NSSegmentedControl!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func configure() {
        if delegate?.article == nil {
            wordsPerRoll.isEnabled = false
        } else {
            wordsPerRoll.isEnabled = true
        }
        if let wordsPref = self.delegate?.article?.preference?.wordsPerRoll {
            wordsPerRoll.selectedSegment = Int(wordsPref - 1)
        }
    }
    
    @IBAction func wordsPerRollChanged(_ sender: NSSegmentedControl) {
        self.delegate?.article?.preference?.wordsPerRoll = Int16(sender.selectedSegment + 1)
        (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
    }
    
    @IBAction func collapse(_ sender: NSButton) {
        if (sender != disclosureTriangle) {
            if (disclosureTriangle.state == .on) {
                disclosureTriangle.state = .on
            } else {
                disclosureTriangle.state = .on
            }
        }
        if let delegate = delegate {
            delegate.collapseWords = !(delegate.collapseWords)
            delegate.updateHeight()
        }
    }
}
