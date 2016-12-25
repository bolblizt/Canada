//
//  Downloader.swift
//  CodingAssignment
//
//  Created by Priority Wealth on 23/12/16.
//  Copyright © 2016 Priority Wealth. All rights reserved.
//

import UIKit


class Downloader: NSObject {
    
    var record:AppImage?
    var queue:OperationQueue!
    
    override init() {
        
        record = AppImage()
        
    }
    

    func StopDownload(){
        
        
    }
    
    /*
    func DownloadOperation(){
        queue = OperationQueue()
        
        let operation1 = BlockOperation(block: {
            let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            OperationQueue.main.addOperation({
                self.imageView1.image = img1
            })
        })
    }
    */
    
    func StartDownload(thisRecord:AppImage, completion: (_ result: AppImage)->()) ->() {
        
        /*
          if thisRecord.imageURL != ""{
         
        URLSession.shared.dataTask( with: NSURL(string:thisRecord.imageURL!)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    let  kAppIconSize:CGFloat = 44.0
                    let imageIcon = UIImage(data: data)
                    if imageIcon?.size.width != kAppIconSize || imageIcon?.size.height != kAppIconSize{
                        
                        let iconSize = CGSize(width: kAppIconSize, height: kAppIconSize)
                        UIGraphicsBeginImageContextWithOptions(iconSize, false, 0.0)
                        let imageRect = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
                        imageIcon?.draw(in: imageRect)
                        thisRecord.imageIcon = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                    }
                    
                    
                }
                
                
            }
            
        }).resume()
        }
    */
        
        if thisRecord.imageURL != ""{
            let requestURL: URL = URL.init(string: thisRecord.imageURL!)!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            
            let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
                
                if error == nil {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    if (statusCode == 200) {
                        print("Everyone is fine, file downloaded successfully.")
                        
                        if let data = data {
                            
                            let  kAppIconSize:CGFloat = 44.0
                            let imageIcon = UIImage(data: data)
                            if imageIcon?.size.width != kAppIconSize || imageIcon?.size.height != kAppIconSize{
                                
                                let iconSize = CGSize(width: kAppIconSize, height: kAppIconSize)
                                UIGraphicsBeginImageContextWithOptions(iconSize, false, 0.0)
                                let imageRect = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
                                imageIcon?.draw(in: imageRect)
                                thisRecord.imageIcon = UIGraphicsGetImageFromCurrentImageContext()
                                UIGraphicsEndImageContext()
 
                           // let imageIcon = UIImage(data: data)
                           // thisRecord.imageIcon = imageIcon
                            
                            }
                            else
                            {
                                thisRecord.imageIcon = imageIcon
                            }
                            
                        }
                        
                    }

                }
                
            })
            
            task.resume()
            
            
        }

    }
        
}




