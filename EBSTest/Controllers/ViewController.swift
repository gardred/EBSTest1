//
//  ViewController.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 18.04.2022.
//

import UIKit

var favoriteProducts = [Products]() 
var cartProducts = [Products]()

class ViewController: UIViewController {
    //MARK: -UIElements
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    //MARK: -Variables
    private var products = [Products]()
    private var defaults = UserDefaults.standard
    private var current_page = 1
    private var isFetchingData = false
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNetworkConnection()
        
        fetchAllProducts()
        configureNavBar()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductListCollectionViewCell.nib(), forCellWithReuseIdentifier: "ProductListCollectionViewCell")
    }
    //MARK: - Functions
    private func configureNavBar() {
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        navigationItem.titleView = imageView
    }
    
    //Refresh controll action
    @objc func refresh(_ sender : UIRefreshControl) {
        products.removeAll()
        current_page = 1
        fetchAllProducts()
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    //Check internet connection
    private func checkNetworkConnection() {
        if NetworkMonitor.shared.isConnected {
            print("Connected")
        } else {
            let alert = UIAlertController(title: "Failure", message: "You are not connected to the internet", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    //API call
    private func fetchAllProducts() {
        APICaller.shared.getProducts(atPage: current_page) { [self] result in
            switch result {
            case .success(let getProducts) :
                products.append(contentsOf: getProducts)
                isFetchingData = false
                current_page += 1
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(_) :
                print("Error")
            }
        }
    }
    
    //Change collection view cell size
    @objc func horizontalCollection(_ sender : UITapGestureRecognizer) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = .init(width: collectionView.frame.width , height: 206)
        collectionView.reloadData()
    }
    
    @objc func squareCollection(_ sender : UITapGestureRecognizer) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = .init(width: 128 , height: 128)
        collectionView.reloadData()
    }
    
    //Save favorite products to UserDefaults
    private func saveProduct() {
        if let encode = try? JSONEncoder().encode(favoriteProducts) {
            defaults.set(encode, forKey: favoriteKey)
        }
    }
    
}

//MARK: -UICollectionView Extension
extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionViewCell", for: indexPath) as! ProductListCollectionViewCell
        cell.configure(with: products[indexPath.row])
        
        //Mark as favorite product
        cell.addToFavoriteProduct = { [self] in
            favoriteProducts.append(products[indexPath.row])
            saveProduct()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.id = products[indexPath.row].id
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProductListHeaderrCollectionReusableView", for: indexPath) as? ProductListHeaderrCollectionReusableView else { return UICollectionReusableView() }
        
        let horizontalGesture = UITapGestureRecognizer(target: self, action: #selector(horizontalCollection))
        headerView.horizontalButton.addGestureRecognizer(horizontalGesture)
        
        let squareGesture = UITapGestureRecognizer(target: self, action: #selector(squareCollection))
        headerView.squareButton.addGestureRecognizer(squareGesture)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastProduct = products.count - 1
        if indexPath.row == lastProduct && !isFetchingData{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.isFetchingData = true
                self?.fetchAllProducts()
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


        return CGSize(width: 345, height: 213)
    }
}




