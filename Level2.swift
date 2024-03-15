//
//  Level2.swift
//  숫자야구게임 level2
//
//  Created by t2023-m0095 on 3/15/24.
//

import Cocoa

class Level2: NSObject {
    func start() {
        print("게임을 시작합니다. 1~9까지의 숫자 중 중복되지 않는 서로 다른 숫자 3개를 입력하세요.")
        let answer = makeAnswer()
        while true {
            guard let input = readLine(), let inputInt = Int(input), input.count == 3,
                  !input.contains("0"), Set(input).count == 3
            else {print("1~9까지의 서로 다른 숫자 3개를 다시 입력하세요."); continue}
            
            if inputInt == answer {
                return print("level 2 : 정답입니다!")
            }
            else {
                let inputArray = fillArray(arrayInput: inputInt)
                let answerArray = fillArray(arrayInput: answer)
                compareAnswer(inputArray: inputArray, answerArray: answerArray) //호출
            }
            
            func fillArray(arrayInput:Int) -> [Int] {
                var inputArray : [Int] = []
                var inputNum = arrayInput
                
                while inputNum > 0 {
                    inputArray.append(inputNum % 10)
                    inputNum = inputNum/10
                }
                inputArray.reverse()
//                print(inputArray)
                return inputArray
            }
            
            func compareAnswer(inputArray:[Int], answerArray:[Int]) {
                var strNum = 0
                var ballNum = 0
                
                for index in 0...2 {
                    if inputArray[index] == answerArray[index] {
                        strNum += 1
                    }
                    else if answerArray.contains(inputArray[index]) {
                        ballNum += 1
                    }
                }
                return print("\(strNum) 스트라이크, \(ballNum) 볼")
            } // func compareAnswer
        }
    }
    func makeAnswer() -> Int {
        var array1 = [1,2,3,4,5,6,7,8,9]
        var array2 : [Int] = []
        var answer = 0
        
        array1.shuffle()
        for number in 0...2 {
            array2.append(array1[number])
        }
        answer = array2[0] * 100 + array2[1] * 10 + array2[2]
//        print(answer)
        return answer
    }
}
