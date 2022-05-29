//
//  ActivityInformationController.swift
//  fefuactivity
//
//  Created by students on 25.05.2022.
//

import UIKit

class ActivityInformationController: UIViewController {
    
    var activityname = ""
    var activitykm = ""
    var activitylastedtime = ""
    var activityduration = ""
    
    @IBOutlet var activityName: UILabel!
    @IBOutlet var activityKm: UILabel!
    @IBOutlet var activityLT: UILabel!
    @IBOutlet var activityDuration: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityName.text = activityname
        activityKm.text = activitykm + " км"
        activityLT.text = activitylastedtime + " часов"
        activityDuration.text = activityduration + " часов назад"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
}
