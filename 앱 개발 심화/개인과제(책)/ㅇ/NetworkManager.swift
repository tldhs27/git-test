//
//  NetworkManager.swift
//  개인과제(책)
//
//  Created by t2023-m0095 on 5/10/24.
//

import UIKit
import Kingfisher
import Alamofire

class NetworkManager {
    
    
    func BookData(keyword: String, completion: @escaping (Result<[BookData], Error>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "KakaoAK 6eb7bb297bcb908f208ce213fbfd6ac8"]
        let parameters: Parameters = ["query": keyword]
        let url = "https://dapi.kakao.com/v3/search/book.json"
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: KakaoAPIResponse.self) { response in
            switch response.result {
            case .success(let responseData):
                completion(.success(responseData.documents))
            case .failure(let error):
                print("Error: 데이터 받아오기 실패, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    
    func downloadImage(thumnail: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: thumnail) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                // 이미지 다운로드 성공, UIImage 반환
                DispatchQueue.main.async {
                    completion(value.image)
                }
            case .failure(let error):
                // 이미지 다운로드 실패
                print("Error downloading image: \(error)")
                DispatchQueue.main.async {
                    completion(UIImage(named: "NoImage"))
                }
            }
        }
    }
    
    
}
