//
//  customPopUp.swift
//  fefuactivity
//
//  Created by students on 29.05.2022.
//

import UIKit

protocol CustomPopUpDelegate: AnyObject
{
    func customPopupViewExtention(sender: customPopUp, didSelectNumber: Int)
}

class customPopUp: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
