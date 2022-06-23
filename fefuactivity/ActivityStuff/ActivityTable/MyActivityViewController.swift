//
//  MyActivityViewController.swift
//  fefuactivity
//
//  Created by students on 25.05.2022.
//

import UIKit
import CoreData
import SwiftUI

struct my_section {
    var title: String
    var activity: ActivityData
    
 }

class MyActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var emptyState: UIView!
    
    var currentkm: String = "0"
    var currenttime: String = "0"
    var currentname: String = "Название"
    var currentlastedtime: String = "0"
    var data = [ActivityData]();
    var sections = [my_section(title: "Сегодня", activity: ActivityData())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let colour = UIColor(named: "TableViewColor")
        tableView.backgroundColor = colour
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "ActivityCellViewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ActivityCellView")
        tableView.delegate = self
        tableView.dataSource = self
    }
        
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetch()
        sectionWork()
        tableView.reloadData()
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
        } catch {
            print(error)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func sectionWork() {
        for active in data {
            let lastedTimed = abs(NSInteger(active.date!.timeIntervalSinceNow/3600))
            print(lastedTimed)
            switch lastedTimed {
                    case 0..<24 :
                        let section = my_section(title: "Сегодня", activity: active)
                        sections.append(section)
                    case 24..<48:
                        sections.append(my_section(title: "Вчера", activity: active))
                    case 48..<72:
                        let section = my_section(title: "Позавчера", activity: active)
                        sections.append(section)
                    case _:
                        let formatter = DateFormatter()
                        formatter.timeStyle = .none
                        formatter.dateStyle = .full
                        formatter.timeZone = TimeZone.current
                        let section = my_section(title: formatter.string(from: active.date!), activity: active)
                        sections.append(section)
            }
            sections = sections.sorted()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = data[indexPath.row]
        let lastedTimed = abs(NSInteger(activity.date!.timeIntervalSinceNow/3600))
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCellView", for: indexPath) as! ActivityCell
        cell.activityKM.text = String(format: "%.2f", activity.distance) + " м"
        cell.activityDT.text = String(format: "%.2f", activity.duration) + " с"
        cell.activityNM.text = activity.name
        let lastDigit = lastedTimed % 10
        
        switch lastDigit {
            case 0, 5, 6, 7, 8, 9:
                cell.activityLT.text =  String(lastedTimed) + " часов назад"
            case 1:
                cell.activityLT.text =  String(lastedTimed) + " час назад"
            case 2, 3, 4:
                cell.activityLT.text =  String(lastedTimed) + " часа назад"
            default:
                break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let mySection = sections[section]
        return mySection.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowActivity", sender: tableView.cellForRow(at: indexPath))
        let activity = data[indexPath.row]
        currentname = activity.name!
        currenttime = String(format: "%.2f", activity.duration) + " c"
        currentkm = String(format: "%.2f", activity.distance) + " м"
        let lastedTimed = abs(NSInteger(activity.date!.timeIntervalSinceNow/3600))
        let lastDigit = lastedTimed % 10
        switch lastDigit {
            case 0, 5, 6, 7, 8, 9:
                currentlastedtime =  String(lastedTimed) + " часов назад"
            case 1:
                currentlastedtime =  String(lastedTimed) + " час назад"
            case 2, 3, 4:
                currentlastedtime =  String(lastedTimed) + " часа назад"
            default:
                break
        }
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

extension my_section: Comparable {
    static func < (lhs: my_section, rhs: my_section) -> Bool {
           lhs.title < rhs.title
       }}

