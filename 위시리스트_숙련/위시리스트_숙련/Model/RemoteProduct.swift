//
//  RemoteProduct.swift
//  위시리스트_숙련
//
//  Created by t2023-m0095 on 4/16/24.
//

import Foundation

struct RemoteProduct: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: URL
}

//{
//    "id": 1,
//    "title": "iPhone 9",
//    "description": "An apple mobile which is nothing like apple",
//    "price": 549,
//    "discountPercentage": 12.96,
//    "rating": 4.69,
//    "stock": 94,
//    "brand": "Apple",
//    "category": "smartphones",
//    "thumbnail": "https://i.dummyjson.com/data/products/1/thumbnail.jpg",
//    "images": [
//        "https://i.dummyjson.com/data/products/1/1.jpg",
//        "https://i.dummyjson.com/data/products/1/2.jpg",
//        "https://i.dummyjson.com/data/products/1/3.jpg",
//        "https://i.dummyjson.com/data/products/1/4.jpg",
//        "https://i.dummyjson.com/data/products/1/thumbnail.jpg"
//    ]
//}
    
