//
//  ViewController.swift
//  위시리스트_숙련
//
//  Created by t2023-m0095 on 4/15/24.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            guard let currentProduct = self.currentProduct else {return}
            
            // 메인 페이지 상품 데이터 JSON Dummy API 활용해서 노출하기  (썸네일, 상품명, 설명, 가격)
            DispatchQueue.main.async {
                self.productImage.image = nil
                self.productTitle.text = currentProduct.title
                self.productDiscription.text = currentProduct.description
//                self.productPrice.text = "\(currentProduct.price)$"
                self.setPriceLabel(self.productPrice)
            }
            
            // 불러올 데이터 - 썸네일, 이미지를 데이터화 -> UIImage로
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: currentProduct.thumbnail), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.productImage.image = image}
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRemoteProduct()
    }
    
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDiscription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var saveProductButton: UIButton!
    @IBOutlet weak var otherProduct: UIButton!
    @IBOutlet weak var lookatWishList: UIButton!
    
    
    @IBOutlet var mainTableView: UITableView!
    
    // 위시리스트에 저장(담기)
    @IBAction func tappedSaveProductButton(_ sender: UIButton) {
        self.saveWishProduct()   // 저장 버튼 누르면, 위시리스트에 저장되는 함수 호출
    }
    
    // 다른 상품 보기 -> 클릭 시 랜덤한 아이디 생성 및 다른 상품 보여주기.
    @IBAction func tappedotherProductButton(_ sender: UIButton) {
        self.fetchRemoteProduct()  // 다른 새로운 상품을 불러오기
    }
    
    // 위시리스트 보기 -> 다음 화면으로 이동 (화면 전환)
    @IBAction func tappedLookatWishList(_ sender: UIButton) {
        guard let nextVC = self.storyboard?
          .instantiateViewController(
            identifier: "WishListViewController"
          ) as? WishListViewController else { return }
        
        // PresentationStyle
         self.modalPresentationStyle = .fullScreen
        
         // NextViewController를 present 합니다.
         self.present(nextVC, animated: true)

      }
    

    // 현재 상품을 위시리스트에 저장 : Coredata에 저장
    private func saveWishProduct() {
        guard let context = self.persistentContainer?.viewContext else {return}
        
        guard let currentProduct = self.currentProduct else {return}
                
        let wishProduct = Product(context: context)   // Coredata에 저장해둔 Entity
        
        // 현재 상품의 데이터가 위시리스트 상품의 데이터로
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = currentProduct.price
        
        try? context.save()
            
    }
    
    
    // 1000단위 별로 쉼표 찍기
    func setPriceLabel(_ productPrice : UILabel) {
        guard let price = self.currentProduct?.price else { return }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        print(price)
        let setProductPrice = numberFormatter.string(for: price)
        productPrice.text = " \(setProductPrice!)$ "
    }
    
    
    //URL Session
    private func fetchRemoteProduct() {
        let productID = Int.random(in: 1...100) // 1~100까지 랜덤한 숫자
        
        if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
            // URLSessionDataTask를 사용하여 비동기적으로 데이터 요청
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        self.currentProduct = product
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }
            }
            
            // 네트워크 요청 시작
            task.resume()
        }
    }
    
} // class
