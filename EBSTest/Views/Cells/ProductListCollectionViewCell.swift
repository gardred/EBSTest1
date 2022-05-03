//
//  ProductListCollectionViewCell.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 18.04.2022.
//

import UIKit

class ProductListCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDetails: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    var addToFavoriteProduct : (() -> ()) = {}
    var removeFavoriteProduct : (() -> ()) = {}
    var isFavorite : Bool = false
    var defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    public func configure(with model : Products) {
        DispatchQueue.main.async {
            self.productName.text = model.name
            self.productDetails.text = model.details
            self.productPrice.text = "$\(model.price)"
            if self.imageView.image == nil {
                self.errorLabel.isHidden = false
            } else {
                self.imageView.image = UIImage(named:"\(model.icon)")
            }
        }
    }
    
    
    
    @IBAction func markAsFavorite(_ sender: UIButton) {
        
        if !isFavorite {
            let image = UIImage(named: "Active")
            heartButton.setImage(image, for: .normal)
            addToFavoriteProduct()
            defaults.set(isFavorite, forKey: "isFav")
        } else {
            isFavorite = false
            let image = UIImage(named: "Normal1")
            heartButton.setImage(image, for: .normal)
        }
        
    }
    @IBAction func removeFromFavorite(_ sender: UIButton) {
        removeFavoriteProduct()
    }
    static func nib() -> UINib {
        return UINib(nibName: "ProductListCollectionViewCell", bundle: nil)
    }
    
}
