//
//  ViewController.swift
//  CodingAssignment
//
//  Created by Priority Wealth on 23/12/16.
//  Copyright © 2016 Priority Wealth. All rights reserved.
//

import UIKit

 let urlStr:String = "https://dl.dropboxusercontent.com/u/746330/facts.json"

class ViewController: UITableViewController {
    
    
   
    
    var arrayList:NSMutableArray!
    var dataProvider: TableDataListProvider?
    private let cellIdentifer = "Cell"
    var appTitle:String?
    var downloader:Downloader?
    var queue:OperationQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("List Count: \(arrayList?.count)")
        self.title = "Loading..."
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerCellsForTableView(tableView: self.tableView)
        //get data from server
        self.PrepData()
        
        self.arrayList = NSMutableArray()
        self.tableView.rowHeight = 80.0
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
      let cellImage:ImageTableViewCell = ImageTableViewCell(style: .subtitle, reuseIdentifier: "Cell")

       let rowCount = self.arrayList.count
        
        if rowCount == 0 &&  indexPath.row == 0 {
            
            //set initial cell place holder while data is being retrieve
            let placeHolder = AppImage()
            cellImage.setCell(itemRecord:placeHolder )
            
        }
        else
        {
            
            
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
                    // set new image after download
                    cellImage.setCell(itemRecord: appIcon!)
                }

            }
            
            
        }
        
         let sizeCell:CGSize = (cellImage.contentView.systemLayoutSizeFitting(CGSize.zero))
        print("cell size\(sizeCell.height)")
        self.tableView.rowHeight = 100.0
        
        
        
        return cellImage
    }

    
    // MARK: - UITableView Add Delegate.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.layoutIfNeeded()
           // self.tableView(<#T##tableView: UITableView##UITableView#>, cellForRowAt: <#T##IndexPath#>)
            
            let sizeCell:CGSize = (cell?.contentView.systemLayoutSizeFitting(CGSize.zero))!
        
        
             return 80.0
    }

    
    //MARK: - Utility Functions
    func RefreshTable(){
        
        tableView.reloadData()
        
    }


    func PrepData(){
        
        let imageArray:NSMutableArray = NSMutableArray()
        let requestURL: URL = URL.init(string:urlStr )!
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
                                            
                                           
                                            //print ("description: \(detailStr)")
                                            imageContainer.descript = detailStr
                                            
                                        }
                                        
                                        if let  titleStr = exactItem["title"] as? String {
                                            
                                            //print ("Title: \(titleStr)")
                                            imageContainer.title = titleStr
                                            
                                        }
                                        
                                        if let  imageHref = exactItem["imageHref"] as? String {
                                            
                                           
                                           // print ("imagRef: \(imageHref)")
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
                                self.title = self.appTitle
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
                    
                    
                    queue = OperationQueue()
                    
                    let operation = BlockOperation(block: {
                      self.StartDownLoader(imageRecord: appRecord, path: indexPath)
                        OperationQueue.main.addOperation({
                         //   self.imageView1.image = img1
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                        })
                    })
                    
                    operation.completionBlock = {
                        print("Operation  Done, cancelled:\(operation.isCancelled)")
                    }
                    queue.addOperation(operation)
                    
                    
                    
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
        self.loadImagesForOnscreenRows()
    }
    

}
