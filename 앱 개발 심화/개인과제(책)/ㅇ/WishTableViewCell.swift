//
//  WishTableViewCell.swift
//  개인과제(책)
//
//  Created by t2023-m0095 on 5/8/24.
//

import UIKit

class WishTableViewCell: UITableViewCell {
    
    static let identifier = "WishTableViewCell"
    
    let bookNameLabel = UILabel()
    let writerNameLabel = UILabel()
    let priceLabel = UILabel()
    
    let containerView = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //여백 만들기
        contentView.addSubview(containerView)
        [bookNameLabel, writerNameLabel, priceLabel].forEach {
            containerView.addSubview($0)
        }
        
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = UIColor(hexCode: "EFA3BD", alpha: 0.2)
        containerView.clipsToBounds = true
        
       
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(hexCode: "EFA3BD", alpha: 1.0).cgColor
        
        selectionStyle = .none
            
        setUI()
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    func setUI() {
    
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        
        bookNameLabel.layer.masksToBounds = true
        writerNameLabel.layer.masksToBounds = true
        priceLabel.textAlignment = .right

        
        bookNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.width.equalTo(160)
        }
        
        writerNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(bookNameLabel.snp.trailing).offset(20)
            $0.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-20)
            
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.greaterThanOrEqualTo(20)
        }
        
        bookNameLabel.textColor = .black
        bookNameLabel.font = UIFont.systemFont(ofSize: 18)
        
        writerNameLabel.textColor = .darkGray
        writerNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        priceLabel.textColor = .systemBlue
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        
    }

    
    
}
