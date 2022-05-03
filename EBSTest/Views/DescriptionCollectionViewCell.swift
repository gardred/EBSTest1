//
//  DescriptionCollectionViewCell.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 29.04.2022.
//

import UIKit

class DescriptionCollectionViewCell: UICollectionViewCell {

    static let identifier = "DescriptionCollectionViewCell"
    
    @IBOutlet weak var informationLabel : UILabel!
    @IBOutlet weak var productInformationLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DescriptionCollectionViewCell", bundle: nil)
    }

}
