//
//  ProductDetailsCollectionViewCell.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 29.04.2022.
//

import UIKit

class ProductDetailsCollectionViewCell: UICollectionViewCell {

    
    static let identificator = "ProductDetailsCollectionViewCell"
    
//    @IBOutlet weak var productNameLabel : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
//    @IBOutlet weak var productDetailsLabel : UILabel!
//    @IBOutlet weak var productPriceLabel : UILabel!
//    @IBOutlet weak var informationLabel : UILabel!
//    @IBOutlet weak var productInfoLabel : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    public func configure(with model : Products) {
        DispatchQueue.main.async {
            let image = model.icon
            self.productImageView.image = UIImage(named: image ?? "")
//            self.productNameLabel.text = model.name
//            self.productDetailsLabel.text = model.details
//            self.productPriceLabel.text = "$\(model.price)"
//            self.informationLabel.text = model.details
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ProductDetailsCollectionViewCell", bundle: nil)
    }

}
