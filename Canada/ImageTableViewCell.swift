//
//  ImageTableViewCell.swift
//  Canada
//
//  Created by user on 24/12/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    var title: UILabel!
     var detailInfo:UILabel!
    var imgV: UIImageView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: .default , reuseIdentifier: reuseIdentifier)
        title = UILabel(frame: CGRect(x: 40.0, y: 5.0, width: 150.0 , height: 20.0 ))
        detailInfo = UILabel(frame: CGRect(x: 40, y: 50, width: 200, height: 34))
        detailInfo.numberOfLines = 0
        detailInfo.font = UIFont(name: "Hevetica Nue", size: 13.0)
        
        //title.backgroundColor = UIColor.yellowColor();
        self.addSubview(title)
        imgV = UIImageView(frame: CGRect(x: 5, y: 5.0, width: 44.0, height: 44.0))
        self.addSubview(imgV)
        self.addSubview(detailInfo)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCell(itemRecord:AppImage){
        title.text = itemRecord.title
        detailInfo.text = itemRecord.descript
        if itemRecord.imageIcon != nil{
            imageView?.image = itemRecord.imageIcon
        }
        else{
            imageView?.image = UIImage(named: "Placeholder")
        }
        
        
    }
    
    

}
