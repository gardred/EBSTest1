//
//  Products.swift
//  EBSTest
//
//  Created by Сережа Присяжнюк on 18.04.2022.
//

import Foundation
import UIKit

struct ProductsResponse : Codable {
    let results : [Products]
}

struct Products : Codable {
    let id : Int
    let name : String
    let icon : String?
    let details : String
    let price : Int
}

struct ProductDetails : Codable {
    var id : Int
    var name : String
    var details : String
    var price : String
    var icon : String?
    var index : Int
}
