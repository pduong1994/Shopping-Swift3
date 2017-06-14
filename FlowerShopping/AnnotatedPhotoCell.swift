//
//  AnnotatedPhotoCell.swift
//  FlowerShopping
//
//  Created by DUONG on 25/05/2017.
//  Copyright © 2017 DUONGPHAM. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var captionLabel: UILabel!
    @IBOutlet fileprivate weak var commentLabel: UILabel!
    
    var photo: Photo? {
        didSet {
            if let photo = photo {
                imageView.image = photo.image
                captionLabel.text = photo.caption
                commentLabel.text = photo.comment
            }
        }
    }
    
    /*  This code calls the super implementation to make sure that the standard attributes are applied. Then, it casts the attributes object into an instance of PinterestLayoutAttributes to obtain the photo height and then changes the image view height by setting the imageViewHeightLayoutConstraint constant value.
     */
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            //imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
    
    // Added by Duong
    func configureWithProduct(_ productDict: NSDictionary) {
        // Setup the cell with information provided in productDict.
        captionLabel?.text = productDict.value(forKey: "title") as? String
        
        commentLabel?.text = productDict.value(forKeyPath: "price.data.formatted.with_tax") as? String
        print("WRRRR - Test - 11 => captionLabel?.text= ",captionLabel?.text)
        
        var imageUrl = ""
        
        if let images = productDict.object(forKey: "images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = (images.firstObject as! NSDictionary).value(forKeyPath: "url.https") as! String
            }
            
        }
        print("WRRRR - Test - 12")
        imageView?.sd_setImage(with: URL(string: imageUrl))
        
    }
    func setCollectionDictionary(_ dict: NSDictionary) {
        // Set up the cell based on the values of the dictionary that we've been passed
        
        commentLabel?.text = dict.value(forKey: "title") as? String
        
        // Extract image URL and set that too...
        var imageUrl = ""
        
        if let images = dict.value(forKey: "images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = (images.firstObject as! NSDictionary).value(forKeyPath: "url.https") as! String
            }
        }
        
        imageView?.sd_setImage(with: URL(string: imageUrl))
        
        
    }
}
