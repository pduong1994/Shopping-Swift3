//
//  ProductsListTableViewCell.swift
//  FlowerShopping
//
//  Created by DUONG PHAM on 5/15/17.
//  Copyright © 2017 DUONGPHAM. All rights reserved.
//

import UIKit

class ProductsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel:UILabel?
    @IBOutlet weak var productPriceLabel:UILabel?
    @IBOutlet weak var productImageView:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureWithProduct(_ productDict: NSDictionary) {
        // Setup the cell with information provided in productDict.
        productNameLabel?.text = productDict.value(forKey: "title") as? String
        
        productPriceLabel?.text = productDict.value(forKeyPath: "price.data.formatted.with_tax") as? String
        
        var imageUrl = ""
        
        if let images = productDict.object(forKey: "images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = (images.firstObject as! NSDictionary).value(forKeyPath: "url.https") as! String
            }
            
        }
        
        productImageView?.sd_setImage(with: URL(string: imageUrl))
        
        
    }
    
}
