//
//  CollectionViewCell.swift
//  개인과제(책)
//
//  Created by t2023-m0095 on 5/7/24.
//

import UIKit
import Alamofire
import CoreData


class HorizontalCell: UICollectionViewCell {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }

    
    static let identifier = "HorizontalCell"
    
    let recentBookImageView = UIImageView()
    
   
    private var recentBook : BookData? = nil {
        didSet {
            guard let recentBook = self.recentBook else {return}
            
            // 메인 페이지 상품 데이터 JSON Dummy API 활용해서 노출하기  (썸네일, 상품명, 설명, 가격)
            DispatchQueue.main.async {
                self.recentBookImageView.image = nil
            }
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCell()
    
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell() {
            

        contentView.addSubview(recentBookImageView)

        recentBookImageView.backgroundColor = .clear
        recentBookImageView.layer.cornerRadius = 10
        
        recentBookImageView.contentMode = .scaleAspectFit
        
        recentBookImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        

    }
    

    func confidureImagefromURL(_ thumbnail: String) {
            guard let thumbnail = URL(string: thumbnail) else {return}
            
            let request = AF.request(thumbnail, method: .get)
            
            request.responseData{ [weak self] response in
                switch response.result {
                case .success(let imageData):
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: imageData) else {return}
                        self?.recentBookImageView.image = image
                    }
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    
    
} // class
