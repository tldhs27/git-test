//
//  TodoCell.swift
//  개인과제(todolist)
//
//  Created by t2023-m0095 on 3/27/24.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var completeButton: UISwitch!
    
    @IBOutlet weak var list: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUISwitch()
    }
    
    func setUISwitch(){
        completeButton.isOn = false // 스위치 초기 상태 설정
        completeButton.onTintColor = UIColor.green // 켜져있을 때의 배경 색상 설정
        completeButton.thumbTintColor = UIColor.white // 썸네일 색상 설정
        
        completeButton.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("Completed")
            list.attributedText = list.text?.strikeThrough()
        }
        else {
            list.attributedText = NSAttributedString(string: list.text ?? "")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
    extension String {
        func strikeThrough() -> NSAttributedString {
            let attributeString = NSMutableAttributedString(string: self)
            
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length)) // 취소선
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, attributeString.length))
            return attributeString
        }
    }


