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
        

        let maleItem = UIAction(title: "Мужчина", image: UIImage(systemName: "hand.wave.fill")?.withTintColor(.systemIndigo).withRenderingMode(.alwaysOriginal)) { (action) in

            self.genderButton.setTitle("Мужчина", for: .normal)
            self.genderButton.setTitleColor(.systemIndigo, for: .normal)
            
        }
        
        let femaleItem = UIAction(title: "Женщина", image: UIImage(systemName: "hands.clap.fill")?.withTintColor(.systemTeal).withRenderingMode(.alwaysOriginal)) { (action) in

            self.genderButton.setTitle("Женщина", for: .normal)
            self.genderButton.setTitleColor(.systemTeal, for: .normal)
         }
        
        let helicopterItem = UIAction(title: "Вертолет", image: UIImage(systemName: "hands.sparkles.fill")?.withTintColor(.systemPurple).withRenderingMode(.alwaysOriginal)) { (action) in

            self.genderButton.setTitle("Вертолет", for: .normal)
            self.genderButton.setTitleColor(.systemPurple, for: .normal)
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
