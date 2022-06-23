//
//  GenderPopup.swift
//  fefuactivity
//
//  Created by students on 17.06.2022.
//

import UIKit

protocol GenderPopupDelegate : class {
    func GenderPopupExtension(senderL GenderPopup, didSelectNumber: Int)
}

class GenderPopup: UIViewController {
     
     weak var delegate: GenderPopupDelegate?
    
     static func instantiate() -> GenderPopup? {
         return CustomPopupView(nibName: nil, bundle: nil)
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
     }
     
      @objc func doneButtonAction() {
         delegate?.customPopupViewExtension(sender: self, didSelectNumber: 1)
     }
}
