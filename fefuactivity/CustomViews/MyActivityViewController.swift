//
//  MyActivityViewController.swift
//  fefuactivity
//
//  Created by students on 25.05.2022.
//

import UIKit

class MyActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var emptyState: UIView!
    
    var currentkm: String = "0"
    var currenttime: String = "0"
    var currentname: String = "Название"
    var currentlastedtime: String = "0"
    let activitykm = ["15.4", "21"]
    let activitydurations = ["4", "15"]
    let activitynames = ["Велосипед", "Бег"]
    let activitylastedtime = ["5", "0"]
    var sectionnames = ["22.05.2022"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.lightGray
        let nib = UINib(nibName: "ActivityCellViewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ActivityCellView")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func activityButton(_ sender: UIButton){
        emptyState.isHidden = true
        tableView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitykm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCellView", for: indexPath) as! ActivityCell
        cell.activityKM.text = activitykm[indexPath.row] + " км"
        cell.activityDT.text = activitydurations[indexPath.row] + " часов"
        cell.activityNM.text = activitynames[indexPath.row]
        cell.activityLT.text = activitylastedtime[indexPath.row] + " часов назад"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sectionnames[section]
        return section
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionnames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowActivity", sender: tableView.cellForRow(at: indexPath))
        
        currentname = activitynames[indexPath.row]
        currenttime = activitydurations[indexPath.row]
        currentkm = activitykm[indexPath.row]
        currentlastedtime = activitylastedtime[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowActivity" else { return }
        guard let destination = segue.destination as? ActivityInformationController else {return}
        destination.activityduration = String(currenttime)
        destination.activityname = String(currentname)
        destination.activitylastedtime = String(currentlastedtime)
        destination.activitykm = String(currentkm)
    }
}
