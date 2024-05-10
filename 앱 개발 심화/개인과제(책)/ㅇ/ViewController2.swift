//
//  ViewController2.swift
//  개인과제(책)
//
//  Created by t2023-m0095 on 5/8/24.
//

import UIKit
import SnapKit
import CoreData



class ViewController2: UIViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    
    let deleteButton = UIButton()
    let wishViewLabel = UILabel()
    let addButton = UIButton()
    let view1 = UIView()
    
    
    let tableView = UITableView()
    let cellSpacingHeight: CGFloat = 3
    
    var array: [Book] = []  //코어데이터 전체
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setProductList()
        
        setUI()
        
        setTableView()
        
        self.tableView.reloadData()
        
        
    } // override
    
    
    // 한번만 reloadData 하는 게 아닌, 뷰가 나타날 때마다 업데이트
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setProductList()
        
        tableView.reloadData()
    }
    
    
    // 코어데이터에 저장된 데이터를 불러오기 (데이터조회)
    private func setProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Book.fetchRequest()
        
        if let array = try? context.fetch(request) {
            self.array = array
        }
    }
    
    
    
    func setUI() {
        
        view1.backgroundColor = .white
        
        
        deleteButton.backgroundColor = UIColor(hexCode: "EFCFD1", alpha: 0.3)
        deleteButton.setTitleColor(.systemPink, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        deleteButton.setTitle(" 전체 삭제 ", for: .normal)
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.masksToBounds = true
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        wishViewLabel.text = "내가 담은 책"
        wishViewLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        
        
        
        addButton.backgroundColor = UIColor(hexCode: "E5F4FE", alpha: 0.5)
        addButton.setTitleColor(.systemCyan, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addButton.setTitle("추가 +", for: .normal)
        addButton.layer.cornerRadius = 5
        addButton.layer.masksToBounds = true
        
        
        [view1, deleteButton, wishViewLabel, addButton].forEach {
            view.addSubview($0)
        }
        
        view1.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(35)
            
        }
        
        deleteButton.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(30)
            $0.height.equalTo(20)
            $0.centerY.equalTo(view1)
            
        }
        
        wishViewLabel.snp.makeConstraints {
            $0.centerY.equalTo(view1)
            $0.centerX.centerY.equalTo(view1)
        }
        
        addButton.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(30)
            $0.centerY.equalTo(view1)
        }
        
    }
    
    @objc func deleteButtonTapped(_ button: UIButton) {
        
        array = []

        //코어데이터 전체 삭제
        guard let context = self.persistentContainer?.viewContext else { return }
        
        // 삭제할 데이터를 가져오는 NSFetchRequest를 생성합니다.
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Book.fetchRequest()
        
        // 모든 데이터를 삭제하는 NSBatchDeleteRequest를 생성합니다.
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            // NSBatchDeleteRequest를 실행하여 모든 데이터를 삭제합니다.
            try context.execute(batchDeleteRequest)
            
            try context.save()
            
            print("전체 삭제")
        } catch {
            print("error")
        }
        
        tableView.reloadData()
    }
    
}


//MARK: - 테이블뷰
extension ViewController2: UITableViewDataSource, UITableViewDelegate {
    
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WishTableViewCell.self, forCellReuseIdentifier: WishTableViewCell.identifier)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view1.snp.bottom).offset(20)
            $0.bottom.left.right.equalToSuperview().inset(20)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishTableViewCell.identifier, for: indexPath) as! WishTableViewCell
        
        let addList = array[indexPath.row]
        cell.bookNameLabel.text = addList.bookTitle
        cell.writerNameLabel.text = addList.bookAuthor
        cell.priceLabel.text = String(addList.bookPrice) + "원"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
