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
        title = UILabel(frame: CGRect(x: 70.0, y: 7.0, width: 250.0 , height: 20.0 ))
        detailInfo = UILabel(frame: CGRect(x: 70.0, y: 30.0, width: 250.0 , height: 34.0 )) //UILabel(frame: CGRect.zero)
        detailInfo.translatesAutoresizingMaskIntoConstraints = false
        detailInfo.numberOfLines = 0
        detailInfo.font = UIFont(name: "Hevetica Neue", size: 11.0)
        

        self.addSubview(title)
        imgV = UIImageView(frame: CGRect(x: 5, y: 5.0, width: 45.0, height: 45.0))
       
        self.addSubview(imgV)
        self.addSubview(detailInfo)
        
        
        //add contraints to make the label have dynamic width
     //  let views = Dictionary(dictionaryLiteral: ("detailInfo", detailInfo))
      //  self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(70)-[detailInfo(300)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
       // self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(40)-[detailInfo]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
      //  self.detailInfo.sizeThatFits(CGSize(width: 300.0, height: 34.0))
       // self.detailInfo.preferredMaxLayoutWidth = 400
        
        
        
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
