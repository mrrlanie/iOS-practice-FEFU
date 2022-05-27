//
//  SegueController.swift
//  fefuactivity
//
//  Created by students on 27.05.2022.
//

import UIKit

class SegueController: UIStoryboardSegue {

    override func perform() {
        if let navigationController = self.source.navigationController {
            navigationController.isNavigationBarHidden = true
            navigationController.setViewControllers([self.destination], animated: true)
            }
    }
}
