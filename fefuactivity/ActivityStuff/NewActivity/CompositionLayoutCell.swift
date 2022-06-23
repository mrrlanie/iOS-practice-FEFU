//
//  CompositionalLayoutCell.swift
//  fefuactivity
//
//  Created by students on 21.06.2022.
//

import UIKit

class CompositionalLayoutCell: UICollectionViewCell {
    @IBOutlet weak var ActivityName: UILabel!
    @IBOutlet weak var ActivityImage: UIImageView!
    
    static let reuseId = "CompositionalLayoutCell"
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true{
                self.layer.borderWidth = 2
                self.layer.borderColor = UIColor.systemPurple.cgColor
            } else {
            }
            ActivityImage.isHidden = !isSelected
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CompositionalLayoutCell", bundle: nil)
    }
    
    func configure(title: String, image: UIImage){
        ActivityName.text = title
        ActivityImage.image = image
    }
    
    func returnLabel() -> String {
        return ActivityName.text!
    }
    

}
