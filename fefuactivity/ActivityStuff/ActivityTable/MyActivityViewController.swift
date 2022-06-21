//
//  MyActivityViewController.swift
//  fefuactivity
//
//  Created by students on 25.05.2022.
//

import UIKit
import CoreData

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
    var data = [ActivityData]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let colour = UIColor(named: "TableViewColor")
        tableView.backgroundColor = colour
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "ActivityCellViewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ActivityCellView")
        tableView.delegate = self
        tableView.dataSource = self
        
        fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    @IBAction func activityButton(_ sender: UIButton){
        emptyState.isHidden = true
        tableView.isHidden = false
    }
    private func fetch(){
        let context = CoreContainer.instance.context
        let fetchRequest = NSFetchRequest<ActivityData>(entityName: "ActivityData")
        
        do {
            let activity = try context.fetch(fetchRequest)
            data = activity.self
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCellView", for: indexPath) as! ActivityCell
        cell.activityKM.text = String(round(activity.distance)) + " км"
        cell.activityDT.text = String(round(activity.duration)) + " часов"
        cell.activityNM.text = activity.name
        //cell.activityLT.text = hours
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
        let activity = data[indexPath.row]
        currentname = activity.name!
        currenttime = String(round(activity.duration))
        currentkm = String(round(activity.distance))
        //currentlastedtime =
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
