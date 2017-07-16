//
//  SRFontCellView.swift
//  SpeedReader
//
//  Created by Bright on 7/16/17.
//  Copyright © 2017 Kay Yin. All rights reserved.
//

import Cocoa

class SRFontCellView: SRGeneralPrefCellView {
    @IBOutlet weak var disclosureTriangle: NSButton!
    @IBOutlet weak var topLabel: NSButton!

    
    @IBOutlet weak var fontNamePopUp: NSPopUpButton!
    @IBOutlet weak var fontSubFamilyPopUp: NSPopUpButton!
    @IBOutlet weak var fontSizeComboBox: NSComboBox!
    
    let allFontNames = NSFontManager.shared().availableFontFamilies
    let allFontSizes = [9, 10, 11, 12, 13, 14, 18, 24, 36, 48, 64, 72, 96]

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    @IBAction func fontNameChanged(_ sender: NSPopUpButton) {
        fontSubFamilyPopUp.removeAllItems()
        if let selectedFamily = fontNamePopUp.titleOfSelectedItem {
            if let arrayofSubs = NSFontManager.shared().availableMembers(ofFontFamily: selectedFamily)  {
                var resultingSub:[String] = []
                for i in 0..<arrayofSubs.count {
                    if let nameOfSubFamily = arrayofSubs[i][1] as? String {
                        resultingSub.append(nameOfSubFamily)
                    }
                }
                fontSubFamilyPopUp.addItems(withTitles: resultingSub)
            }
        }
    
    }
    
    @IBAction func fontSubFamilyChanged(_ sender: NSPopUpButton) {
    }
    
    @IBAction func fontSizeChanged(_ sender: NSComboBox) {
    }
    
    @IBAction func collapse(_ sender: Any) {
        if let delegate = delegate {
            delegate.collapseFont = !(delegate.collapseFont)
        }
    }
    
    override func configure() {
        fontNamePopUp.removeAllItems()
        fontNamePopUp.addItem(withTitle: "System Font")
        fontNamePopUp.addItems(withTitles: allFontNames)
        
        fontSubFamilyPopUp.removeAllItems()
        fontSizeComboBox.removeAllItems()
        fontSizeComboBox.addItems(withObjectValues: allFontSizes)
    }

}
