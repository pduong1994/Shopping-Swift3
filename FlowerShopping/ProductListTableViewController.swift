//
//  ProductListTableViewController.swift
//  FlowerShopping
//
//  Created by DUONG PHAM on 5/16/17.
//  Copyright © 2017 DUONGPHAM. All rights reserved.
//

import UIKit
import Moltin

enum selectedScope:Int{
    case name = 0
    case descript = 1
}

class ProductListTableViewController: UITableViewController ,UISearchBarDelegate{
    
    fileprivate let CELL_REUSE_IDENTIFIER = "ProductCell"
    
    fileprivate let LOAD_MORE_CELL_IDENTIFIER = "ProductsLoadMoreCell"
    
    fileprivate let PRODUCT_DETAIL_VIEW_SEGUE_IDENTIFIER = "productDetailSegue"
    
    fileprivate var products:NSMutableArray = NSMutableArray()
    
    fileprivate var paginationOffset:Int = 0
    
    fileprivate var showLoadMore:Bool = true
    
    fileprivate let PAGINATION_LIMIT:Int = 10
    
    fileprivate var selectedProductDict:NSDictionary?
    
    var collectionId:String?
    
    var searchActive : Bool = false
	
    var isCheckDoubleClick = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SearchBarSettup()
        loadProducts(true)
        
    }
    
    fileprivate func loadProducts(_ showLoadingAnimation: Bool){
        assert(collectionId != nil, "Collection ID is required!")
        
        // Load in the next set of products...
        
        // Show loading if neccesary?
        if showLoadingAnimation {
            SwiftSpinner.show("Loading sản phẩm ..")
        }
        
        print("WR -- collectionId= ",collectionId)
        Moltin.sharedInstance().product.listing(withParameters: ["collection": collectionId!, "limit": NSNumber(value: PAGINATION_LIMIT), "offset": paginationOffset], success: { (response) -> Void in
            // Let's use this response!
            SwiftSpinner.hide()
            
            
            if let newProducts:NSArray = response?["result"] as? NSArray {
                self.products.addObjects(from: newProducts as [AnyObject])
                
            }
            let responseDictionary = NSDictionary(dictionary: response!)
            if let totalProducts:NSNumber = responseDictionary.value(forKeyPath: "pagination.total") as? NSNumber {
                // If we have all the products already, don't show the 'load more' button!
                if totalProducts.intValue >= self.products.count {
                    self.showLoadMore = false
                }
                
            }
            
            self.tableView.reloadData()
            
        }) { (response, error) -> Void in
            // Something went wrong!
            SwiftSpinner.hide()
            
            AlertDialog.showAlert("Error", message: "Couldn't load products", viewController: self)
            
            print("Something went wrong...")
            print(error)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        if showLoadMore {
            return (products.count + 1)
        }
        
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (showLoadMore && (indexPath as NSIndexPath).row > (products.count - 1)) {
            // it's the last item - show a 'Load more' cell for pagination instead.
            let cell = tableView.dequeueReusableCell(withIdentifier: LOAD_MORE_CELL_IDENTIFIER, for: indexPath) as! ProductsLoadMoreTableViewCell
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_REUSE_IDENTIFIER, for: indexPath) as! ProductsListTableViewCell
        
        let row = (indexPath as NSIndexPath).row
        
        let product:NSDictionary = products.object(at: row) as! NSDictionary
        
        cell.configureWithProduct(product)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (showLoadMore && (indexPath as NSIndexPath).row > (products.count - 1)) {
            // Load more products!
            loadProducts(false)
            return
        }
        
        
        // Push a product detail view controller for the selected product.
        let product:NSDictionary = products.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        selectedProductDict = product
        
        performSegue(withIdentifier: PRODUCT_DETAIL_VIEW_SEGUE_IDENTIFIER, sender: self)
        
    }
    
    override func tableView(_ _tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == PRODUCT_DETAIL_VIEW_SEGUE_IDENTIFIER {
            // Set up product detail view
            let newViewController = segue.destination as! ProductDetailViewController
            
            newViewController.title = selectedProductDict!.value(forKey: "title") as? String
            newViewController.productDict = selectedProductDict
            
        }
    }
    
    //***** Search bar *********
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func SearchBarSettup(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        searchBar.showsScopeBar = true
        //searchBar.scopeButtonTitles = ["Tên","Mô tả"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isCheckDoubleClick = false
        if searchText.isEmpty {
            //getBookArea()
            loadProducts(true)
            self.tableView.reloadData()
        }else{
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    func filterTableView(ind: Int, text:String){
        switch ind {
        case selectedScope.name.rawValue:
            print("havadu: Test searchbar")
            //self.products = self.products.filter(using: { mod -> Bool in
            //    return (mod.name?.lowercased().localizedStandardContains(text.lowercased()))!
            //})
        case selectedScope.descript.rawValue:
            print("havadu: Test searchbar => 1")
           /* bookarea =  bookarea.filter({ mod -> Bool in
                //return (mod.descript?.lowercased().contains(text.lowercased()))!
                return (mod.descript?.lowercased().localizedStandardContains(text.lowercased()))!
            })*/
            self.tableView.reloadData()
        default:
            print("Không có dữ liệu")
        }
    }
    
    //****** End searchBar ********
    
}
