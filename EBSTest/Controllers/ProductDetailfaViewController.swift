//
//  ProductDetailfaViewController.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 29.04.2022.
//

import UIKit
import SkeletonView
class ProductDetailfaViewController: UIViewController {
    
    @IBOutlet weak var detailsCollectionView : UICollectionView!
    
    enum CellType {
        case gallery
        case price
        case description
        case loading
    }
    
    var cells: [CellType] = [.loading]
    
    var id : Int!
    private var product : Products!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getSingleProduct()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.detailsCollectionView.stopSkeletonAnimation()
            self.view.hideSkeleton()
        })
        
        detailsCollectionView.register(ProductDetailsCollectionViewCell.nib(),
                                       forCellWithReuseIdentifier: ProductDetailsCollectionViewCell.identificator)
        detailsCollectionView.register(PriceCollectionViewCell.nib(),
                                       forCellWithReuseIdentifier: PriceCollectionViewCell.identifier)
        detailsCollectionView.register(DescriptionCollectionViewCell.nib(),
                                       forCellWithReuseIdentifier: DescriptionCollectionViewCell.identifier)
        detailsCollectionView.delegate = self
        detailsCollectionView.dataSource = self
        
        
    }
    private func getSingleProduct () {
        APICaller.shared.getSingleProduct(id: id) {[weak self] (result) in
            switch result {
            case .success(let products) :
                self?.product = products
                self?.cells = [.gallery, .price, .description]
                
            case .failure(_) :
                let alert = UIAlertController(title: "Error loading this product", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
                    self?.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            }
        }
    }
}


extension ProductDetailfaViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailsCollectionViewCell.identificator, for: indexPath) as? ProductDetailsCollectionViewCell else { return UICollectionViewCell()}
        
        switch cells[indexPath.row] {
        case .gallery:
            guard let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailsCollectionViewCell.identificator, for: indexPath) as? ProductDetailsCollectionViewCell else { return UICollectionViewCell()  }
//            cell.configure(with: <#T##Products#>)
            return cell
            
        case .price:
            
            guard let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: PriceCollectionViewCell.identifier, for: indexPath) as? PriceCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        case .description:
            
            guard let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailsCollectionViewCell.identificator, for: indexPath) as? ProductDetailsCollectionViewCell else { return UICollectionViewCell()}
            
            return cell
            
            
        case .loading:
            
            detailsCollectionView.isSkeletonable = true
            detailsCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
        }
       

                return cell
//        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
}
