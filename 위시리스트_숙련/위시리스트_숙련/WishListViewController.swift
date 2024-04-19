//
//  WishListViewController.swift
//  위시리스트_숙련
//
//  Created by t2023-m0095 on 4/16/24.
//

import UIKit
import CoreData

class WishListViewController: UITableViewController {
    
    @IBOutlet var wishList: UITableView!
    private var data : [Product] = []
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wishList.dataSource = self
        wishList.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setWishList()
    }
    
    //데이터 조회
    private func setWishList() {
        guard let context = self.persistentContainer?.viewContext else {return}
        
        let request = Product.fetchRequest()
        if let products = try? context.fetch(request) {
            self.data = products  // 상품들을 데이터로 넘겨주기
        }
        print(data)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count  // 데이터 개수 = 행 수
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let product = self.data[indexPath.row]
        
        let id = product.id
        let title = product.title
        let price = product.price
        
        cell.textLabel?.text = "[\(id)] \(title ?? "") - \(price)"
        return cell
    }
    
    
    // 삭제 버튼 누를 시
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteData(indexPath.row) // 삭제 먼저
            tableView.deleteRows(at: [indexPath], with: .fade)  // 페이드 처리
        }
    }
    
    func deleteData(_ indexPathNum : Int) {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let product = self.data[indexPathNum]
        let request = Product.fetchRequest()
        
        guard (try? context.fetch(request)) != nil else { return }
        
        context.delete(product)
        
        try? context.save()
        self.data.remove(at: indexPathNum) // 데이터 소스에서 해당 셀의 데이터 삭제
    }
}
