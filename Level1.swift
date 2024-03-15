//
//  Level1.swift
//  숫자야구게임 level2
//
//  Created by t2023-m0095 on 3/15/24.
//

import Cocoa

class Level1: NSObject {
    func start() {
        print("게임을 시작합니다. 1~9까지의 숫자 중 중복되지 않는 서로 다른 숫자 3개를 입력하세요.")
        _ = readLine()
        let answer = makeAnswer()
        print("정답은 \(answer)입니다.")
    }
    
    func makeAnswer() -> Int {
        var array1 = [1,2,3,4,5,6,7,8,9]
        var array2 : [Int] = []
        
        array1.shuffle()
        for number in 0...2 {
            array2.append(array1[number])
        }
        let answer = array2[0] * 100 + array2[1] * 10 + array2[2]   // for - in 문 안이 아니라 밖에 뒀어야. 0,1 만 있을 때 작동이 안됨.
        return answer
    }
}

