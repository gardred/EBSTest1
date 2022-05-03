//
//  APICaller.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 18.04.2022.
//

import Foundation
import UIKit

class APICaller {
    
    static let shared = APICaller()
    var products = [Products]()
    var model : ProductsResponse?
    var imageCache = NSCache<NSString,UIImage>()
    
    struct Constants {
        static let baseURL = "http://mobile-shop-api.hiring.devebs.net/products"
    }
    
    enum APIError : Error {
        case failedToGetData
    }
    
    func getProducts(atPage page : Int,completion : @escaping (Result<[Products] , Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)?page=\(page)&page_size=10") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(ProductsResponse.self, from: data)
                completion(.success(results.results))
            } catch  {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getSingleProduct (id : Int , completion : @escaping (Result<Products , Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/\(id)") else { return }
        print("URL : \(url)")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(Products.self, from: data)
                completion(.success(results))
            } catch  {
                print(error.localizedDescription)
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    //Cache image
    func downloadImage(url : URL , completion : @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString  as NSString) {
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil , data != nil ,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200
                else {
                    return
                }
                guard let image = UIImage(data: data!) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            dataTask.resume()
        }
        
    }
    
    
}


