//
//  SingleDue.swift
//  Dues
//
//  Created by DadiousA on 16/11/12.
//  Copyright © 2016年 DadiousA. All rights reserved.
//

import UIKit

class Schedule: NSObject {
    
    var name: String
    var deadline: Date
    var isCompleted: Bool
    var memo: String
    
    
    init(name: String, deadline: Date, isCompleted:Bool = false, memo: String = "" ){
        self.name = name
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.memo = memo
    }
    
    func indexDate() -> Date{
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self.deadline)!
    }
    
    func DateComponentsSinceNow() -> DateComponents?{
        let now = Date(timeIntervalSinceNow: 0)
        let DC = Calendar.current.dateComponents([.day,.hour,.minute,.second], from: now, to: self.deadline)
        if DC.second! < 0 || DC.minute! < 0 || DC.hour! < 0 || DC.day! < 0 {return nil}
            else{return DC}
    }
}
