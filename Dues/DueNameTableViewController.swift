//
//  DueNameTableViewController.swift
//  Dues
//
//  Created by DadiousA on 16/10/19.
//  Copyright © 2016年 DadiousA. All rights reserved.
//

import UIKit

class DueNameTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: Properties
    
    @IBOutlet weak var DueNameTextField: UITextField!
    var dueName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        DueNameTextField.delegate = self
        DueNameTextField.becomeFirstResponder()
        DueNameTextField.text = dueName
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: UITextFieldDelegate
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
   
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DueTableViewController{
            if DueNameTextField.text != nil{
                destinationVC.due?.dueName = DueNameTextField.text!
            }
        }
        
        
    }
    

}
