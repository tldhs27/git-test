//
//  TabBarController.swift
//  개인과제(책)
//
//  Created by t2023-m0095 on 5/9/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = .systemCyan
        self.tabBar.backgroundColor = .systemGray5
        self.delegate = self
        
        addVC()

    }
    
    
    func addVC() {  //네비게이션
        let firstVC = ViewController()
        firstVC.view.backgroundColor = UIColor(hexCode: "E5F4FE")
        firstVC.title = "검색페이지"
        firstVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "mail.and.text.magnifyingglass.rtl"), selectedImage: UIImage(systemName: "mail.and.text.magnifyingglass.rtl"))
    
        let nav1 = UINavigationController(rootViewController: firstVC)
        
        let secondVC = ViewController2()
        secondVC.view.backgroundColor = UIColor(.white)
        secondVC.title = "위시리스트"
        secondVC.tabBarItem = UITabBarItem(title: "위시리스트", image: UIImage(systemName: "books.vertical"), selectedImage: UIImage(systemName: "books.vertical.fill"))
        
        self.viewControllers = [nav1, secondVC]
    }
    

    
}
