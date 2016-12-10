//
//  DueListTableViewController.swift
//  Dues
//
//  Created by DadiousA on 16/10/12.
//  Copyright © 2016年 DadiousA. All rights reserved.
//

import UIKit

class DueListTableViewController: UITableViewController {

    // MARK: properties
    var dueList = [Due]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedDueList = load(){
            dueList.append(contentsOf: savedDueList)
            print("load success")
        }else{
            loadDefaultDues()
        }
    }

    func printDueList(){
        for due in dueList{
            print(due)
        }
    }
    
    func loadDefaultDues(){
        let today = Date(timeIntervalSinceNow: 500)
        dueList += [Due(dueName: "Sample Due", deadline: today)]
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
        return dueList.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "dueListToDue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Due", for: indexPath) as! DueListTableViewCell
        let due = dueList[indexPath.row]
        
        // Configure the cell...
        cell.DueNameLabel.text = due.dueName
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a  MMM dd, yyyy"
        if let nextDeadline = nextDue(for:due){
            cell.DeadlineLabel.text = "Next on "+formatter.string(from: nextDeadline)
        }else{
            cell.DeadlineLabel.text = "Due has passed"
            cell.DeadlineLabel.textColor = UIColor.red
        }
        
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
    */
    
    @IBAction func unwindToDueList(segue: UIStoryboardSegue) {
        //   print("unwinding: status of due 3"+String(dueList[2].isRepeat))
        
        if let DueVC = segue.source as? DueTableViewController {
            if let due = DueVC.due{
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    // Update .
                    dueList[(selectedIndexPath as NSIndexPath).row] = due
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    //    print("update")
                } else {
                    // Add a new .
                    let newIndexPath = IndexPath(row: dueList.count, section: 0)
                    dueList.append(due)
                    tableView.insertRows(at: [newIndexPath], with: .bottom)
                    //     print("add")
                }
            }else{
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    dueList.remove(at:(selectedIndexPath as NSIndexPath).row)
                    tableView.reloadData()
                    //      print("delete")
                }
            }
            
        }
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier! {
        case "DueList:NewDue":
            break
        case "DueList:Details":
            if let DueTableViewController = segue.destination.childViewControllers[0] as? DueTableViewController{
                if let selectedCell = sender as? DueListTableViewCell{
                    let indexPath = tableView.indexPath(for: selectedCell)!
                    let due = dueList[indexPath.row]
                    DueTableViewController.due = Due(dueName: due.dueName, deadline: due.getDeadline(), isRepeat: due.isRepeat, repeatDeadline: due.repeatDeadline)
                }
            }
        case "DueList:Schedule":
            if let ScheduleVC = segue.destination.childViewControllers[0] as? ScheduleTableViewController{
                ScheduleVC.scheduleList = dueListToScheduleList()
            }
        default:
            break
        }
    }
 
    func nextDue(for due: Due) -> Date?{
        var nextDue: Date?
        let schedules = due.toSchedule()
        let now = Date(timeIntervalSinceNow: 0)
        for schedule in schedules{
            if schedule.deadline >= now{
                nextDue = schedule.deadline
                break
            }
        }
        return nextDue
    }
    
    func dueListToScheduleList() -> [Schedule]{
        
        func sortSchedule(s1: Schedule, s2: Schedule) -> Bool{
            return s1.deadline < s2.deadline
        }
        
        var scheduleList = [Schedule]()
        
        for due in dueList{
            scheduleList.append(contentsOf:due.toSchedule())
        }
        
        scheduleList.sort(by: sortSchedule)
        
        return scheduleList
    }
    
    func save() {
        //print(dueList)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dueList, toFile: Due.ArchiveURL.path)
        if isSuccessfulSave {
            //    print("save success")
        }else{
            //      print("Failed to save")

        }
    }
    
    func load() -> [Due]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Due.ArchiveURL.path) as? [Due]
    }
}
