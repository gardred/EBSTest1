//
//  DetailsViewController.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 20.04.2022.
//

import UIKit
import SkeletonView


//MARK: -DetailsViewCOntroller
class DetailsViewController: UIViewController {
    private var model : ProductDetails!
    
//    class func construct(model : ProductDetails) -> DetailsViewController {
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let detailsVC = storyboard.instantiateViewController(withIdentifier: "detailsView") as! DetailsViewController
//
//        detailsVC.model = model
//        print(detailsVC.model!)
//        return detailsVC
//    }
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var productDetails : UILabel!
    @IBOutlet weak var productPrice : UILabel!
    @IBOutlet weak var informationLabel : UILabel!
    @IBOutlet weak var informationProductLabel : UILabel!
    @IBOutlet weak var errorLabel : UILabel!
    
    var id : Int!
    private var product : Products!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getSingleProduct()
        errorLabel.isHidden = true
        productImageView.isSkeletonable = true
        productImageView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
        
        productName.isSkeletonable = true
        productName.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
        
        productDetails.isSkeletonable = true
        productDetails.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
        
        productPrice.isSkeletonable = true
        productPrice.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
        
        informationProductLabel.isSkeletonable = true
        informationProductLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBAr()
        errorLabel.isHidden = true
//        informationTextView.isEditable = true
//        informationTextView.isScrollEnabled = true

                                                            
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            productImageView.stopSkeletonAnimation()
            productImageView.hideSkeleton()
            
            productName.stopSkeletonAnimation()
            productName.hideSkeleton()
            
            productDetails.stopSkeletonAnimation()
            productDetails.hideSkeleton()
            
            productPrice.stopSkeletonAnimation()
            productPrice.hideSkeleton()
            
            informationProductLabel.stopSkeletonAnimation()
            informationProductLabel.hideSkeleton()
        }
    }
    
    private func configureNavBAr() {
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        navigationItem.titleView = imageView
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: nil)

        
    }
    
//    func position(for bar: UIBarPositioning) -> UIBarPosition {
//     return .topAttached
//    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func getSingleProduct() {
        APICaller.shared.getSingleProduct(id: id) {[weak self] (result) in
            switch result {
            case .success(let products) :
                self?.product = products
                if self?.product.id == self!.id {
                    DispatchQueue.main.async {
                        self?.productName.text = self?.product.name
                        self?.productDetails.text = self?.product.details
                        self?.productPrice.text = "$\(self!.product.price)"
                        self?.informationProductLabel.text = self?.product.details
                        if self?.productImageView.image == nil {
                            self?.errorLabel.isHidden = false
                            self?.errorLabel.text = "Error"
                        } else {
                            self?.productImageView.image = UIImage(named: "\(self!.product.icon ?? "")")
                        }
                    }
                }
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
