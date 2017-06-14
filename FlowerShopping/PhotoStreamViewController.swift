//
//  PhotoStreamViewController.swift
//  FlowerShopping
//
//  Created by DUONG on 25/05/2017.
//  Copyright © 2017 DUONGPHAM. All rights reserved.
//

import UIKit
import AVFoundation
import Moltin

let reuseIdentifier = "AnnotatedPhotoCell"

class PhotoStreamViewController: UICollectionViewController ,UISearchBarDelegate{
    
    //Add by Duong
    fileprivate var products:NSMutableArray = NSMutableArray()
    
    fileprivate var paginationOffset:Int = 0
    
    fileprivate var showLoadMore:Bool = true
    
    fileprivate let PAGINATION_LIMIT:Int = 10
    
    fileprivate var selectedProductDict:NSDictionary?
    
    fileprivate var collections:NSArray?
    
    fileprivate let PRODUCT_DETAIL_VIEW_SEGUE_IDENTIFIER = "productDetailSegue"

    var collectionId:String?
    
    //var photos = Photo.allPhotos()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        print("havadu- Test - 0")
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Added by Duong
        loadProducts(true)
        
        print("havadu - Test - 1")
        // Set controller as delegate for layout
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        //collectionView!.backgroundColor = UIColor.clear
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
    }
    // Added by Duong
    fileprivate func loadProducts(_ showLoadingAnimation: Bool){
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Nội thất yêu thương"
        
        // Show loading UI
        SwiftSpinner.show("Nội thất yêu thương")
        collectionId = "1524667571888980480"
        
        //1524667571888980480
        
        // All for collection not use
        
        // Get collections, async
       /* Moltin.sharedInstance().brand.listing(withParameters: ["status": NSNumber(value: 1), "limit": NSNumber(value: 20)], success: { (response) -> Void in
            // We have collections - show them!
            SwiftSpinner.hide()
            
            self.collections = response?["result"] as? NSArray
            
            self.collectionView?.reloadData()
            
        }) { (response, error) -> Void in
            // Something went wrong; hide loading UI and display warning.
            SwiftSpinner.hide()
            
            AlertDialog.showAlert("Error", message: "Couldn't load collections", viewController: self)
            print("Something went wrong...")
            print(error)
        }*/
        
        
        // Detail product
        Moltin.sharedInstance().product.listing(withParameters: ["brand": collectionId!, "limit": NSNumber(value: PAGINATION_LIMIT), "offset": paginationOffset], success: { (response) -> Void in
            // Let's use this response!
            SwiftSpinner.hide()
            
            
            if let newProducts:NSArray = response?["result"] as? NSArray {
                self.products.addObjects(from: newProducts as [AnyObject])
                
            }
            
            
            let responseDictionary = NSDictionary(dictionary: response!)
            
            //if let newOffset:NSNumber = responseDictionary.value(forKeyPath: "pagination.offsets.next") as? NSNumber {
            //   self.paginationOffset = newOffset.intValue
            
            //}
            
            if let totalProducts:NSNumber = responseDictionary.value(forKeyPath: "pagination.total") as? NSNumber {
                // If we have all the products already, don't show the 'load more' button!
                if totalProducts.intValue >= self.products.count {
                    self.showLoadMore = false
                }
                
            }
            
            self.collectionView?.reloadData()
            
        }) { (response, error) -> Void in
            // Something went wrong!
            SwiftSpinner.hide()
            
            AlertDialog.showAlert("Error", message: "Couldn't load products", viewController: self)
            
            print("Something went wrong...")
            print(error)
        }
        
    }
    
}

extension PhotoStreamViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Added by Duong
        if collections != nil {
            print("havadu - Test - 7")
            return products.count
        }
        
        print("havadu - Test - 8 => products.count= ",products.count)
        return products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AnnotatedPhotoCell
        //cell.photo = photos[indexPath.item]
        
        //Added by Duong
        let row = (indexPath as NSIndexPath).row
        print("havadu - Test - 9 => row= ",indexPath.item)
        
        //let collectionDictionary = collections?.object(at: indexPath.item) as! NSDictionary
        
        //cell.setCollectionDictionary(collectionDictionary)

        
       let product:NSDictionary = products.object(at: indexPath.item) as! NSDictionary
        
       cell.configureWithProduct(product)
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        print(sender)
        print("havadu: prepare ")
        if(segue.identifier == PRODUCT_DETAIL_VIEW_SEGUE_IDENTIFIER){
            print("havadu: prepare 11")
            
            // for get the seasion
            let cell = sender as! AnnotatedPhotoCell
            let indexPath = collectionView?.indexPath(for: cell)
            
            // Push a product detail view controller for the selected product.
            let product:NSDictionary = products.object(at: (indexPath as! NSIndexPath).row) as! NSDictionary
            selectedProductDict = product
            
            // Set up product detail view
            let newViewController = segue.destination as! ProductDetailViewController
            
            newViewController.title = selectedProductDict!.value(forKey: "title") as? String
            newViewController.productDict = selectedProductDict

        }
    }

}

extension PhotoStreamViewController : PinterestLayoutDelegate {
    
    // This provides the height of the photos
    
    /* It uses AVMakeRectWithAspectRatioInsideRect() from AVFoundation to calculate a height that retains the photo’s aspect ratio, restricted to the cell’s width.
     */
    
    func collectionView(_ collectionView:UICollectionView,
                        heightForPhotoAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        
        /*let photo = photos[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: photo.image.size, insideRect: boundingRect)
        
        return rect.size.height*/
        return 126
    }
    
    // This calculates the height of the photo’s comment based on the given font and the cell’s width
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        
        /*let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        let photo = photos[indexPath.item]
        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let commentHeight = photo.heightForComment(font, width: width)
        
        /* You then add that height to a hard-coded annotationPadding value for the top and bottom, as well as a hard-coded annotationHeaderHeight that accounts for the size of the annotation title.
         */
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        
        return height*/
        return 53
    }
}

