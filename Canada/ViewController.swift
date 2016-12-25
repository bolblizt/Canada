//
//  ViewController.swift
//  CodingAssignment
//
//  Created by Priority Wealth on 23/12/16.
//  Copyright © 2016 Priority Wealth. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    

    var arrayList:NSMutableArray!
    var dataProvider: TableDataListProvider?
    private let cellIdentifer = "Cell"
    var appTitle:String?
    var downloader:Downloader?
    var imageDownloadProgress:NSMutableDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("List Count: \(arrayList?.count)")
        self.title = "Rivera"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.PrepData()
         self.registerCellsForTableView(tableView: self.tableView)
        self.arrayList = NSMutableArray()
        
        DispatchQueue.global(qos: .default).async {
            
            self.imageDownloadProgress = NSMutableDictionary()
            
            
        }
        
        // NotificationCenter.default.addObserver(self, selector: #selector(ViewController.RefreshTable), name: NSNotification.Name(rawValue: "RefreshTable"), object: nil)
     
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rowCount:Int = 0
        
        if (self.arrayList?.count)! > 0 {
            rowCount = (self.arrayList?.count)!
        }
        
        return rowCount
    }
 

    
    func registerCellsForTableView(tableView: UITableView) {
       tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifer)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath)

       let rowCount = self.arrayList.count
        
        if rowCount == 0 &&  indexPath.row == 0 {
            
            //placeholder
            
        }
        else
        {
            
            let cellImage:ImageTableViewCell = ImageTableViewCell(style: .default, reuseIdentifier: "Cell")
            
            if rowCount > 0 {
                
    
                // Only load cached images; defer new downloads until scrolling ends
                let appIcon = self.arrayList.object(at: indexPath.row) as? AppImage
                cellImage.setCell(itemRecord: appIcon!)
                
                if (appIcon?.imageIcon == nil) {
                    
                    if tableView.isDragging  == false && tableView.isDecelerating == false{
                        
                        DispatchQueue.global(qos: .default).async {
                            self.StartDownLoader(imageRecord: appIcon!, path: indexPath)
                            
                        }
                        
                        
                    }
                    // if a download is deferred or in progress, return a placeholder image
                   cellImage.setCell(itemRecord: appIcon!)
                }
                else
                {
                    // image cell
                    cellImage.setCell(itemRecord: appIcon!)
                }

            }
            
            return cellImage
            
        }
        
        
        return cell
    }

    
    // MARK: - UITableView Add Delegate.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        return 60.0
    }

    
    
    //MARK: - Utility Functions
    
    
    func RefreshTable(){
        
        tableView.reloadData()
        
    }


    func PrepData(){
        
        let imageArray:NSMutableArray = NSMutableArray()
        let requestURL: URL = URL.init(string: "https://dl.dropboxusercontent.com/u/746330/facts.json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                do{
                    let tempStr:String = NSString(data: data!, encoding: 8) as! String
                    let newData = tempStr.data(using: .utf8)
                    if let jsonResult = try JSONSerialization.jsonObject(with: newData!, options: []) as? [String:AnyObject] {
                        
                        for json in jsonResult{
                            
                            
                            if let infoList = json.value as?  NSArray {
                                
                                
                                print ("provider_name: \(infoList.count)")
                                
                                
                                for infoItem in infoList  {
                                    
                                    let imageContainer = AppImage()
                                    
                                    if  let exactItem = infoItem as? [String:AnyObject] {
                                        if let  detailStr = exactItem["description"] as? String {
                                            
                                            // delegate.userRegInfo.mobileNumber = contact_no
                                            print ("description: \(detailStr)")
                                            imageContainer.descript = detailStr
                                            
                                        }
                                        
                                        if let  titleStr = exactItem["title"] as? String {
                                            
                                            // delegate.userRegInfo.mobileNumber = contact_no
                                            print ("Title: \(titleStr)")
                                            imageContainer.title = titleStr
                                            
                                        }
                                        
                                        if let  imageHref = exactItem["imageHref"] as? String {
                                            
                                            // delegate.userRegInfo.mobileNumber = contact_no
                                            print ("imagRef: \(imageHref)")
                                            imageContainer.imageURL = imageHref
                                            
                                        }
                                    }
                                    
                                    imageArray.add(imageContainer)
                                }
                                
                            }
                            else
                            {
                                print(json.value)
                                self.appTitle = (json.value as? String)!
                                
                        
                            }
                        }

                        if imageArray.count > 0 {
                            self.arrayList = imageArray
                            DispatchQueue.main.async {
                                self.dataProvider?.arrayList = imageArray
                                self.tableView.reloadData()
                            }

                        }
                        
                        
                    }
                    
                    
                }
                catch {
                    print("Error with Json: \(error)")
                }
                
                
            }
            
        }) 
        
        
        
        
        task.resume()
        
       
        
    }
    
    
    
    func StartDownLoader(imageRecord:AppImage, path:IndexPath){
        
        if (imageRecord.imageIcon == nil)
        {
            // Avoid the app icon download if the app already has an icon
            
            let myDownloader:Downloader = Downloader()
            myDownloader.StartDownload(thisRecord: imageRecord,  completion: {(newRecord) -> () in
                
                self.arrayList.replaceObject(at: path.row, with: newRecord)
                DispatchQueue.main.async {
                     self.tableView.reloadRows(at: [path], with: .fade)
                }
               
                
                
            })
            
            
        }
        
    }
    
    
    func loadImagesForOnscreenRows()
    {
       
        
        if (self.arrayList.count > 0)
        {
            let visiblePaths =  self.tableView.indexPathsForVisibleRows  //  [self.tableView indexPathsForVisibleRows];
            
            for indexPath in visiblePaths!
            {
                let appRecord:AppImage =  self.arrayList.object(at: indexPath.row) as! AppImage
                
                if (!(appRecord.imageIcon != nil))
                {
                    // Avoid the app icon download if the app already has an icon
                    self.StartDownLoader(imageRecord: appRecord, path: indexPath)
                }
            }
        }

        
    }
    
    

//MARK: - Scroll Delegates
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (!decelerate)
        {
            self.loadImagesForOnscreenRows()
        }
        
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    

}
