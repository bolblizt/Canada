//
//  TableDataListProvider.swift
//  CodingAssignment
//
//  Created by Priority Wealth on 23/12/16.
//  Copyright © 2016 Priority Wealth. All rights reserved.
//

import UIKit

class TableDataListProvider: NSObject,UITableViewDataSource {
    
    var listCount:Int = 0
     var arrayList:NSArray!
    private let cellIdentifer = "Cell"
    
    func registerCellsForTableView(tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifer)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rowCount:Int = 0
        
        if (self.arrayList?.count)! > 0 {
            rowCount = (self.arrayList?.count)!
        }
        
        return rowCount
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath)
        
        cell.textLabel?.text = "Row: \(indexPath.row)"
        print("dominic")
        return cell
    }

    
    
    

}
