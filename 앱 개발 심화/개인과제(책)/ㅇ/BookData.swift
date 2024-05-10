//
//  SearchBookData.swift
//  개인과제(책)
//
//  Created by t2023-m0095 on 5/10/24.
//

import Foundation


struct KakaoAPIResponse: Decodable {
    let documents: [BookData]
}

struct BookData: Decodable {
    let authors: [String]    // 도서 저자 리스트
    let contents: String    // 도서 소개
    let price: Int    // 도서 정가
    let url: String    // 도서 상세 URL
    let salePrice: Int    // 도서 판매가
    let thumbnail: String    //도서 표지 미리보기 URL
    let title: String       // 도서 제목

    
    enum CodingKeys: String, CodingKey {
        case authors,contents, price
        case salePrice = "sale_price"
        case thumbnail, title, url
    }
    
    
}

