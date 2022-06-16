//
//  RegistrationController.swift
//  fefuactivity
//
//  Created by students on 20.05.2022.
//

import UIKit

class RegistrationController: UIViewController {
    @IBOutlet weak var genderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
        
        let maleItem = UIAction(title: "Мужчина", image: UIImage(systemName: "suit.heart.fill")?.withTintColor(.systemBlue)) { (action) in

            self.genderButton.setTitle("Мужчина", for: .normal)
         }
        
        let femaleItem = UIAction(title: "Женщина", image: UIImage(systemName: "suit.heart.fill")?.withTintColor(.systemRed)) { (action) in

            self.genderButton.setTitle("Женщина", for: .normal)

         }
        
        let helicopterItem = UIAction(title: "Вертолет", image: UIImage(systemName: "suit.heart.fill")?.withTintColor(.systemIndigo)) { (action) in

            self.genderButton.setTitle("Вертолет", for: .normal)
            
        }
        
        let gendermenu = UIMenu(title: "Выберите пол", options: .displayInline, children: [maleItem, femaleItem, helicopterItem])
        
        if #available(iOS 14.0, *) {
            genderButton.menu = gendermenu
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 14.0, *) {
            genderButton.showsMenuAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
    }
}
