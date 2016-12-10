//
//  Due.swift
//  Dues
//
//  Created by DadiousA on 16/11/8.
//  Copyright © 2016年 DadiousA. All rights reserved.
//

import UIKit
import CoreData

class Due: NSObject, NSCoding{
    
    // MARK: properties
    var dueName: String
    private var deadline: Date
    var isRepeat : Bool
    var repeatDeadline: Date
    //    var scheduleList = [Schedule]()
    
    override public var description: String { return "\(dueName): [deadline: \(deadline)] [isRepeat: \(isRepeat)] [repeatDeadline: \(repeatDeadline)]\n" }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Due")
    
    init(dueName: String, deadline: Date, isRepeat: Bool = false, repeatDeadline: Date = Date()) {
        self.dueName = dueName
        self.deadline = Date()
        self.isRepeat = isRepeat
        if isRepeat{
            assert(deadline < repeatDeadline)
            self.repeatDeadline = repeatDeadline
        }else{
            self.repeatDeadline = Date()
        }
        super.init()
        self.set(deadline: deadline)
    }
    
    struct propertyKey{
        static let name = "name"
        static let deadline = "deadline"
        static let isRepeat = "isRepeat"
        static let repDeadline = "repDeadline"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dueName, forKey: propertyKey.name)
        aCoder.encode(deadline, forKey: propertyKey.deadline)
        aCoder.encode(isRepeat, forKey: propertyKey.isRepeat)
        aCoder.encode(repeatDeadline, forKey: propertyKey.repDeadline)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let dueName = aDecoder.decodeObject(forKey: propertyKey.name) as! String
        let deadline = aDecoder.decodeObject(forKey: propertyKey.deadline) as! Date
        let isRepeat = aDecoder.decodeBool(forKey: propertyKey.isRepeat)
        let repeatDeadline = aDecoder.decodeObject(forKey: propertyKey.repDeadline) as! Date
        self.init(dueName: dueName, deadline: deadline, isRepeat: isRepeat, repeatDeadline: repeatDeadline)
    }
    
    
    func set(deadline: Date){
        self.deadline = self.roundDateToMinutes(date: deadline, minuteInterval: 5)
    }
    
    func getDeadline() -> Date{
        return self.deadline
    }
    
    func roundDateToMinutes( date: Date,minuteInterval: Double) -> Date{
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour,.minute], from: date)
        var minute = Int(ceil(Double(dateComponents.minute!)/minuteInterval)*minuteInterval)
        var hour = dateComponents.hour!
        var date = date
        if minute == 60{
            minute = 0
            hour = hour + 1
            if hour == 24 {
                hour = 0
                //print("wtf")
                date.addTimeInterval(300)
            }
        }
        
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
    }
    
    func toSchedule() -> [Schedule]{
        var scheduleList = [Schedule]()
        if !isRepeat{
            let schedule = Schedule(name:self.dueName, deadline: self.deadline)
            scheduleList.append(schedule)
            //print(schedule.deadline)
        }else{
            let startDate = self.deadline
            let finalDate = self.repeatDeadline.addingTimeInterval(86399)
            var loopDate = startDate
            while loopDate.compare(finalDate) == .orderedAscending {
                let schedule = Schedule(name:self.dueName, deadline: loopDate)
                //print(schedule.deadline)
                scheduleList.append(schedule)
                loopDate.addTimeInterval(604800)
            }
        }
        return scheduleList
    }
    
}
