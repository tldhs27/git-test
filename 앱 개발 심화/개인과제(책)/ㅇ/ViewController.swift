//
//  ViewController.swift
//  ㅇ
//
//  Created by t2023-m0095 on 5/7/24.
//

import UIKit
import SnapKit
import CoreData


class ViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating  {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    
    let networkManager = NetworkManager()
    var searchDebounceTimer: Timer?
    let searchBar = UISearchBar()
  
    var cellNumber = 0
    let tableView = UITableView()
    
    var result: [BookData] = []
    var recent: [Book] = []
    

    lazy var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 7
        layout.itemSize = CGSize(width: 85, height: 120)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HorizontalCell.self, forCellWithReuseIdentifier: HorizontalCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        return collectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        setSearchController(searchBar)
        
        searchViewUI()
        
        setTableView()
        
    
        // 코어 데이터 불러오기
        guard let context = self.persistentContainer?.viewContext else {return}
        
        let request = NSFetchRequest<Book>(entityName: "Book")
        request.propertiesToFetch = ["bookThumbnail"]
        
        if let thumbnail = try? context.fetch(request) {
            self.recent = thumbnail  // recent에 불러온 데이터를 넣고,
            self.horizontalCollectionView.reloadData()   // -> 코어데이터에 저장했으니 껐다 켜도 남아있음.
        }
        
    
    }
    

    
    
    // MARK: - leve1 1 화면 구성
    
    
    //검색화면 구현
    func searchViewUI() {
        
        let view1 = UIView()
        view1.backgroundColor = .white
        view.addSubview(view1)
        view1.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.left.right.equalToSuperview().inset(18)
            $0.height.equalTo(170)
        }
        
        
        let recentBookLabel = UILabel()
        recentBookLabel.text = "최근 본 책"
        view.addSubview(recentBookLabel)
        
        recentBookLabel.snp.makeConstraints {
            $0.top.equalTo(view1.snp.top).inset(10)
            $0.leading.equalToSuperview().inset(35)
        }
        
        //컬렉션뷰
        view.addSubview(horizontalCollectionView)
        horizontalCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentBookLabel.snp.bottom)
            $0.bottom.equalTo(view1.snp.bottom)
            $0.left.right.equalToSuperview().inset(30)
        }
        
        
        
        //View2
        let view2 = UIView()
        view2.backgroundColor = .white
        view.addSubview(view2)
        view2.snp.makeConstraints {
            $0.top.equalTo(view1.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        let searchResultLabel = UILabel()
        searchResultLabel.text = "검색 결과"
        view.addSubview(searchResultLabel)
        searchResultLabel.snp.makeConstraints {
            $0.top.equalTo(view2.snp.top).inset(15)
            $0.leading.equalToSuperview().inset(35)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchResultLabel.snp.bottom).offset(15)
            $0.bottom.equalTo(view2.snp.bottom).inset(20)
            $0.left.right.equalToSuperview().inset(40)
            
        }
        
    } // searchView(검색화면)

    
    
    
    
    //MARK: - level 2 검색화면 구성
    func setSearchController( _ searchBar : UISearchBar ) {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = true
        
        searchController.searchResultsUpdater = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchController.searchBar.placeholder = "검색어를 입력하세요."
        self.navigationItem.title = "SPARTA BOOKCLUB"
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        // 검색 결과를 업데이트하는 뷰 컨트롤러로 searchController를 설정
        navigationItem.searchController = searchController
    }

    
    // 텍스트 검색 시
    func updateSearchResults(for searchController: UISearchController) {
        dump(searchController.searchBar.text) // 디버깅을 위한 출력
                
        guard let text = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        performSearch(with: text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // 키보드를 숨깁니다.
        
        guard let text = searchBar.text?.lowercased() else {
            return
        }
        
        performSearch(with: text)
    }
    
    func performSearch(with text: String) {
        searchDebounceTimer?.invalidate()  // 기존 타이머를 취소합니다.
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.networkManager.BookData(keyword: text) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let a):
                        self?.result = a
                        self?.tableView.reloadData()
                    case .failure(_):
                        // 에러 처리
                        break
                    }
                }
            }
            
            self?.setTableView()
        })
    }
    
    
} // class


//MARK: - 검색결과 테이블뷰

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WishTableViewCell.self, forCellReuseIdentifier: WishTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishTableViewCell.identifier, for: indexPath) as! WishTableViewCell
        
        let searchBook = result[indexPath.row]
        cell.bookNameLabel.text = searchBook.title
        cell.writerNameLabel.text = searchBook.authors.joined(separator: ",")
        cell.priceLabel.text = String(searchBook.salePrice) + "원"
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // 클릭하면 모달 화면 뜨게 하기
        let modalVC = ModalViewController()
        
        // 모달 화면에 뜨는 데이터 전달
        modalVC.detailBook = self.result[indexPath.row]
        
        // 화면 표출
        present(modalVC, animated: true, completion: nil)
        
    
        
    }
    
    
    
}

//MARK: - CollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recent.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as? HorizontalCell else {
            return UICollectionViewCell()
        }
        
        let recentBook = self.recent[indexPath.row]
        
        if let thumbnailUrl = recentBook.bookThumbnail {
            cell.confidureImagefromURL(thumbnailUrl)
        }
            
        return cell
    }
    
} // 컬렉션뷰


//MARK: - hex color 설정
extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

