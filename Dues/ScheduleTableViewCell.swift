//
//  ScheduleTableViewCell.swift
//  Dues
//
//  Created by DadiousA on 2016/12/3.
//  Copyright © 2016年 DadiousA. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    var schedule : Schedule?
    @IBOutlet weak var scheduleDeadlineLabel: UILabel!
    @IBOutlet weak var scheduleNameLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(){
        // Configure the cell...
        scheduleNameLabel.text = schedule!.name
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        scheduleDeadlineLabel.text = formatter.string(from: schedule!.deadline)
        formatter.dateFormat = "a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        ampmLabel.text = formatter.string(from: schedule!.deadline)
        updateDSC()
        startTimer()
    }
    
    func startTimer(){
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDSC), userInfo: nil, repeats: true);
    }
    
    func updateDSC(){
            if let diffDC = schedule!.DateComponentsSinceNow(){
                descriptionLabel.textColor = UIColor.black
                if diffDC.day != 0{
                    if diffDC.hour != 0{
                        descriptionLabel.text = String(describing: diffDC.day!) + " days " + String(describing: diffDC.hour!) + " hours left"
                    }else{
                        descriptionLabel.text = String(describing: diffDC.day!) + " days left"
                    }
                }else if diffDC.hour != 0{
                    if diffDC.minute != 0{
                        descriptionLabel.text = String(describing: diffDC.hour!) + " hours " + String(describing: diffDC.minute!) + " minutes left"
                    }else{
                        descriptionLabel.text = String(describing: diffDC.hour!) + " hours left"
                    }
                }else if diffDC.minute != 0{
                    descriptionLabel.text = String(describing: diffDC.minute!) + " minutes " + String(describing: diffDC.second!) + " seconds left"
                }else{
                    descriptionLabel.text = String(describing: diffDC.second!) + " seconds left"
                }
            }else{
                descriptionLabel.textColor = UIColor.red
                descriptionLabel.text = "Passed"
                
            }
        
    }
}
