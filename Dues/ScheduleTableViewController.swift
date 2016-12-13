//
//  ScheduleTableViewController.swift
//  Dues
//
//  Created by DadiousA on 2016/12/3.
//  Copyright © 2016年 DadiousA. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {

    @IBAction func gotoToday(_ sender: UIBarButtonItem) {
        if !scheduleList.isEmpty{
            let now = Date(timeIntervalSinceNow: 0)
            tableView.scrollToRow(at: IndexPath(row: 0, section:NextScheduleDateIndex(since: now)), at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    var scheduleList = [Schedule]()
    var scheduleIndexDate = [Date]()
    var scheduleTable = [Date:[Schedule]]()
    
    func scheduleListToTable(){
        
        //print("wtf")
        var scheduleInSameDate = [Schedule]()
        for schedule in scheduleList{
            if (!scheduleInSameDate.isEmpty) && (schedule.indexDate() != scheduleInSameDate[0].indexDate()){
                scheduleTable[scheduleInSameDate[0].indexDate()] = scheduleInSameDate
                scheduleIndexDate.append(scheduleInSameDate[0].indexDate())
                scheduleInSameDate.removeAll()
            }
            scheduleInSameDate.append(schedule)
        }
        if !scheduleInSameDate.isEmpty{
            scheduleTable[scheduleInSameDate[0].indexDate()] = scheduleInSameDate
            scheduleIndexDate.append(scheduleInSameDate[0].indexDate())
            scheduleInSameDate.removeAll()
        }
    }
    
    

    func printScheduleTable(){
        for date in scheduleIndexDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            print("{"+formatter.string(from: date), terminator: " : ")
            for schedule in scheduleTable[date]!{
                print("["+schedule.name+" "+formatter.string(from: schedule.deadline)+"]",terminator:" ")
            }
            print("}")
        }
    }
    
    func NextScheduleDateIndex(since date: Date) -> Int{
        var index = 0
        while index < scheduleIndexDate.count {
            if scheduleIndexDate[index] > date || Calendar.current.isDate(scheduleIndexDate[index] , inSameDayAs: date){
                break
            }
            index = index + 1
        }
        // all past
        if index == scheduleIndexDate.count{
            index = index - 1
        }
        return index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleListToTable()
        if !scheduleList.isEmpty{
            let now = Date(timeIntervalSinceNow: 0)
            tableView.scrollToRow(at: IndexPath(row: 0, section:NextScheduleDateIndex(since: now)), at: UITableViewScrollPosition.top, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return scheduleIndexDate.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE  MMM dd,yyyy"
        if Calendar.current.isDateInToday(scheduleIndexDate[section]){
            return "Today"
        }
        return formatter.string(from: scheduleIndexDate[section])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return scheduleTable[scheduleIndexDate[section]]!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Schedule", for: indexPath) as! ScheduleTableViewCell

        cell.schedule = scheduleTable[scheduleIndexDate[indexPath.section]]![indexPath.row]
        
        cell.update()

        return cell

    }


}
