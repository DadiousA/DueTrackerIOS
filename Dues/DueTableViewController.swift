//
//  DueTableViewController.swift
//  Dues
//
//  Created by DadiousA on 16/11/7.
//  Copyright © 2016年 DadiousA. All rights reserved.
//

import UIKit

class DueTableViewController: UITableViewController {
    
    // MARK: properties
    var due : Due?

    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //print("dismissing: "+String(describing: due?.isRepeat))
        due = nil
        dismiss(animated: true, completion: nil)

//        if navigationItem.title == "New Due"{
//            dismiss(animated: true, completion: nil)
//        }else{
//            navigationController!.popViewController(animated: true)
//        }
    }
    
    @IBAction func deadlinePickerAction(_ sender: Any) {
        due?.set(deadline: deadlinePicker.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let now = Date(timeIntervalSinceNow: 0)
        
        if let edditingDue = due{
            navigationItem.title = "Edit Due"
            due!.set(deadline: edditingDue.getDeadline())
        }else{
            //print(deadlinePicker.date)
            due = Due(dueName: "New Due", deadline: now)
        }
        
        deadlinePicker.date = due!.getDeadline()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        if let due = due{
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = due.dueName
            case 2:
                if due.isRepeat{
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEE"
//                    let calendar = Calendar.current
//                    let dueDay = calendar.component(.weekday, from: due.getDeadline())
//                    print(String(describing: dueDay))
                    cell.detailTextLabel?.text = "Every " + formatter.string(from: due.getDeadline())
                }else{
                    cell.detailTextLabel?.text = "Never"
                }
            default:
                break
            }
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch navigationItem.title! {
        case "New Due":
            return 1
        default:
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 3
        default:
            return 1
        }
        
    }

//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Due:NameCell", for: indexPath) as!DueListTableViewCell
//
//        return cell
//    }
//    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1{
//            due = nil
//            print(due)
//        }
////        }else{
////            switch indexPath.row {
////            case 0:
////                performSegue(withIdentifier: "Due:Name", sender: self)
////            case 2:
////                break
////            default:
////                break
////            }
////        
////        }
//    }
    
    @IBAction func unwindToDue(segue: UIStoryboardSegue) {
        //      print(due?.isRepeat)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
//        if let DueNameViewController = segue.source as? DueNameTableViewController {
//            
//            print("tttttt")
//            
//            if let dueName = DueNameViewController.DueNameTextField.text{
//                // let index =
//                let cell = tableView.cellForRow(at: IndexPath(row:0, section:0))!
//                cell.detailTextLabel!.text = dueName
//            }
//            
//        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
        if let DueNameVC = segue.destination as? DueNameTableViewController {
            
            // update due name
            DueNameVC.dueName = due!.dueName
        }else if let DueRepeatTableVC = segue.destination as? DueRepeatTableViewController{
            
            // update due repeat
            DueRepeatTableVC.isRepeat = due!.isRepeat
            DueRepeatTableVC.minRepeatDeadline = due!.getDeadline().addingTimeInterval(518400)
            if due!.isRepeat{
                DueRepeatTableVC.initDeadline = due!.repeatDeadline
            }else{
                DueRepeatTableVC.initDeadline = DueRepeatTableVC.minRepeatDeadline
            }
        }else if segue.destination is DueListTableViewController{
            // print("begin to segue from DueTableVC")
            if sender is UITableViewCell{
                // deleting due
                due = nil
            }else{
            }
        }
    }
    
        
}
