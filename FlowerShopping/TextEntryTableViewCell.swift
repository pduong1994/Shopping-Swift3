//
//  TextEntryTableViewCell.swift
//  FlowerShopping
//
//  Created by DUONG PHAM on 5/15/17.
//  Copyright © 2017 DUONGPHAM. All rights reserved.
//

import UIKit

let TEXT_ENTRY_CELL_REUSE_IDENTIFIER = "textEntryCell"


protocol TextEntryTableViewCellDelegate {
    func textEnteredInCell(_ cell: TextEntryTableViewCell, cellId:String, text: String)
}

class TextEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField:DataEntryTextField?
    
    var cellId:String?
    
    var delegate:TextEntryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        if delegate != nil {
            delegate!.textEnteredInCell(self, cellId: cellId!, text: textField.text!)
        }
        
    }
    
    func hideCursor() {
        // Set the cursor colour to white in the text field to 'hide' it.
        textField?.tintColor = UIColor.clear
    }
    
    
}
