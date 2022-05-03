//
//  FavoritesViewController.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 18.04.2022.
//

import UIKit
let favoriteKey : String = "favorite_items"
class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesProducts : UICollectionView!
    private let defaults = UserDefaults.standard
    //MARK: -Lifecycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesProducts.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBAr()
        
        favoritesProducts.register(ProductListCollectionViewCell.nib(), forCellWithReuseIdentifier: "ProductListCollectionViewCell")
        favoritesProducts.delegate = self
        favoritesProducts.dataSource = self
        
        if let data = defaults.data(forKey: favoriteKey) {
            if let decoded = try? JSONDecoder().decode([Products].self, from: data) {
                favoriteProducts = decoded
            }
        }
    }
    
    //MARK: -Functions
    private func configureNavBAr() {
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        navigationItem.titleView = imageView
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: nil)

        
    }
    
    
}

//MARK: -Extension
extension FavoritesViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoritesProducts.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionViewCell", for: indexPath) as! ProductListCollectionViewCell
        let image = UIImage(named: "Active")
        
        cell.heartButton.setImage(image, for: .normal)
        cell.configure(with: favoriteProducts[indexPath.row])
        
        cell.removeFavoriteProduct = { [self] in
            favoriteProducts.remove(at: indexPath.row)
            favoritesProducts.reloadData()
            if let encode = try? JSONEncoder().encode(favoriteProducts) {
                defaults.set(encode, forKey: favoriteKey)
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let index : Int = 0
//        let data = ProductDetails(id: favoriteProducts[indexPath.row].id, name: favoriteProducts[indexPath.row].name,
//                                  details: favoriteProducts[indexPath.row].details,
//                                  price: "\(favoriteProducts[indexPath.row].price)", icon: favoriteProducts[indexPath.row].icon,
//                                  index: index)
////        let detailsVC = DetailsViewController.construct(model: data)
//        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FavoritesCollectionReusableView", for: indexPath) as? FavoritesCollectionReusableView else { return UICollectionReusableView() }
        headerView.countLabel.layer.cornerRadius = headerView.countLabel.frame.height / 2
        headerView.countLabel.layer.masksToBounds = true
        headerView.countLabel.text = "\(favoriteProducts.count)"
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 345, height: 206)
    }
}


extension UIViewController {
    
}
