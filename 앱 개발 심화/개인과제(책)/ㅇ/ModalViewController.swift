//
//  ButtonManager.swift
//  개인과제(책)
//
//  Created by t2023-m0095 on 5/8/24.
//

import UIKit
import SnapKit
import Alamofire
import CoreData


class ModalViewController: UIViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    
    let bookNameLabel = UILabel()
    let writerNameLabel = UILabel()
    let bookImage = UIImageView()
    let priceLabel = UILabel()

    
    private let descriptionScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.isScrollEnabled = true
            scrollView.indicatorStyle = .black
            scrollView.backgroundColor = .white
            scrollView.showsVerticalScrollIndicator = false
            return scrollView
        }()
    
    let descriptionView = UIView()

    let descriptionLabel = UILabel()
    
    
    let xButton = UIButton()
    let addButton = UIButton()
    
    let networkManager = NetworkManager()
    
    var detailBook : BookData? = nil {
        didSet {
            guard let book = self.detailBook else {return}
            // 메인 페이지 상품 데이터 JSON Dummy API 활용해서 노출하기
            DispatchQueue.main.async {
                self.bookNameLabel.text = book.title
                self.writerNameLabel.text = book.authors.joined(separator: ", ")
//                self.priceLabel.text = "\(String(describing: book.salePrice))원"
                self.descriptionLabel.text = book.contents
            }
        }
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
            setPriceLabel(priceLabel)
            setUI(data: detailBook!)

        }

    
    
    
    //MARK: - 화면 구현
    
    func setPriceLabel(_ label: UILabel) {
        let price: Int = detailBook!.salePrice
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let bookPrice = numberFormatter.string(from: NSNumber(value: price))
    
        priceLabel.text = "\(String(describing: bookPrice ?? "0"))원"
    }
    
    
    func setUI(data: BookData) {
        
        bookNameLabel.layer.masksToBounds = true
        bookNameLabel.textAlignment = .center
        
        
        writerNameLabel.layer.masksToBounds = true
        writerNameLabel.textAlignment = .center
        
        priceLabel.layer.masksToBounds = true
        
        networkManager.downloadImage(thumnail: data.thumbnail) { image in
            // UI 작업은 메인 스레드에서 실행
            DispatchQueue.main.async {
                if let downloadedImage = image {
                    // UIImageView에 이미지 설정
                    self.bookImage.image = downloadedImage
                } else {
                    // 이미지 로딩 실패 처리
                    print("Image download failed")
                }
            }
        }
        

        [bookNameLabel, bookImage, writerNameLabel, priceLabel, descriptionScrollView, xButton, addButton].forEach {
            view.addSubview($0)
        }
        
        descriptionScrollView.addSubview(descriptionView)
        descriptionView.addSubview(descriptionLabel)
        
  
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        
        
        bookNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        writerNameLabel.snp.makeConstraints {
            $0.top.equalTo(bookNameLabel.snp_bottomMargin).offset(20)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        bookImage.contentMode = .scaleAspectFit
        
        bookImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(writerNameLabel.snp_bottomMargin).offset(30)
            $0.left.right.equalToSuperview().inset(40)
            $0.height.equalTo(300)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bookImage.snp_bottomMargin).offset(25)
        }
        
  
        descriptionScrollView.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp_bottomMargin).offset(40)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.centerX.equalTo(0)
            $0.bottom.equalTo(addButton.snp_topMargin).offset(-20)
        }
        
        descriptionView.snp.makeConstraints {
            $0.edges.equalTo(descriptionScrollView)
            $0.width.equalTo(descriptionScrollView.snp.width)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(descriptionView)
            $0.bottom.equalToSuperview().priority(.low)// descriptionScrollView의 contentSize에 맞게 동적으로 조절될 수 있도록 설정
        }
        
        
        xButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalTo(addButton)
        }
        
        
        addButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.equalTo(xButton.snp.rightMargin).offset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
        
        
        
        bookNameLabel.textColor = .black
        bookNameLabel.font = .systemFont(ofSize: 25, weight: .bold)
        
        writerNameLabel.textColor = .systemGray2
        writerNameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        priceLabel.textColor = .systemBlue
        priceLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        
        
        xButton.backgroundColor = UIColor(hexCode: "EFCFD1", alpha: 0.5)
        xButton.setTitleColor(.systemPink, for: .normal)
        xButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        xButton.setTitle("X", for: .normal)
        xButton.layer.cornerRadius = 5
        xButton.layer.masksToBounds = true
        
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        
        addButton.backgroundColor = UIColor(hexCode: "E5F4FE", alpha: 1.0)
        addButton.setTitleColor(.systemCyan, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        addButton.setTitle("담기", for: .normal)
        addButton.layer.cornerRadius = 5
        addButton.layer.masksToBounds = true
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }
    
    //MARK: - x버튼 클릭 시
    
    @objc func xButtonTapped(_ button: UIButton) {
        print("X 클릭")
        
        ViewController().horizontalCollectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped(_ button: UIButton) {
        print("담기")
        
        //코어데이터에 저장
       guard let context = persistentContainer?.viewContext else { return }
       
       let addBook = Book(context: context)
        addBook.bookTitle = detailBook?.title
        addBook.bookPrice = Int64(detailBook!.salePrice)
        addBook.bookAuthor = detailBook?.authors.joined(separator: ", ")
        addBook.bookThumbnail = detailBook?.thumbnail
        
       try? context.save()
       
       let request = Book.fetchRequest()
       _ = try? context.fetch(request)
       print(addBook)
        
        
        ViewController().horizontalCollectionView.reloadData()
        // 모달 닫기
        dismiss(animated: true, completion: nil)
        
        
    
    }
    
}
