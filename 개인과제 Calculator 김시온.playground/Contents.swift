//-------------------------------------- 레벨 1---------------------------------//
class Calculator1 {
    var Calculate : String
    
    init(Calculate: String) {
        self.Calculate = Calculate
    }
    
    func Calculate(_ num1:Double, Operator:String, _ num2:Double) -> Double{
        switch Operator {
        case "+":
            return num1 + num2
        case "-":
            return num1 - num2
        case "*":
            return num1 * num2
        case "/":
            if num2 == 0 {
                print("error")
                return 0
            } else {
                return num1 / num2 }
        default:
            print("계산식을 입력하세요.")
            return 0
            
        }
    }
}
let result1 = Calculator1 (Calculate: "계산식을 입력하세요.")

print(result1.Calculate)
print("계산결과는 \(result1.Calculate(10, Operator: "+", 3))입니다.")
print("계산결과는 \(result1.Calculate(10, Operator: "-", 3))입니다.")
print("계산결과는 \(result1.Calculate(10, Operator: "*", 3))입니다.")
print("계산결과는 \(result1.Calculate(10, Operator: "/", 3))입니다.")


//-------------------------------- 레벨 1 (2번재 버전)----------------------------//
class Calculator0 {
    var name : String
    
    init(name: String) {
        self.name = name
    }
    
    func addOperation(_ num1:Double, _ num2:Double) -> Double{
        return num1 + num2
    }
    func subtractOperation(_ num1:Double, _ num2:Double) -> Double{
        return num1 - num2
    }
    func multiplyOperation(_ num1:Double, _ num2:Double) -> Double{
        return num1 * num2
    }
    func divisionOperation(_ num1:Double, _ num2:Double) -> Double{
        if num2 == 0 {
            print("error")
            return 0
        } else {
            return num1 / num2}
    }
}
let result0 = Calculator0(name: "계산식을 입력하세요.")

print(result0.name)
print("계산결과는 \(result0.addOperation(10,3))입니다.")
print("계산결과는 \(result0.subtractOperation(10,3))입니다.")
print("계산결과는 \(result0.multiplyOperation(10,3))입니다.")
print("계산결과는 \(result0.divisionOperation(10,3))입니다.")



// //-------------------------------- 레벨 2 ----------------------------//

class Calculator2 {
        var Calculate : String
        
        init(Calculate: String) {
            self.Calculate = Calculate
        }
        
        func Calculate(_ num1:Double, Operator:String, _ num2:Double) -> Double{
            switch Operator {
            case "+":
                return num1 + num2
            case "-":
                return num1 - num2
            case "*":
                return num1 * num2
            case "/":
                return num1 / num2
            case "%":
                if num2 == 0 {
                    print("error")
                    return 0
                } else {
                    // return Double(Int(num1)/Int(num2))
                    // return abs((num1/num2) * num2 - num1)
                    return num1.truncatingRemainder(dividingBy: num2)
                }
            default:
                print("계산식을 입력하세요.")
                return 3
                
            }
        }
    }
    let result2 = Calculator2(Calculate: "계산식을 입력하세요.")

    print(result2.Calculate)
    print("계산결과는 \(result2.Calculate(10, Operator: "+", 3))입니다.")
    print("계산결과는 \(result2.Calculate(10, Operator: "-", 3))입니다.")
    print("계산결과는 \(result2.Calculate(10, Operator: "*", 3))입니다.")
    print("계산결과는 \(result2.Calculate(10, Operator: "/", 3))입니다.")
    print("나머지는 \(result2.Calculate(10.5, Operator: "%", 3))입니다.")



//-------------------------------- 레벨 3----------------------------//

class Calculator3 {
     var addOperation : AddOperation3
     var subtractOperation : SubtractOperation3
     var multiplyOperation : MultiplyOperation3
     var divideOperation : DivideOperation3
     
     
     init(addOperation: AddOperation3, subtractOperation: SubtractOperation3, multiplyOperation: MultiplyOperation3, divideOperation: DivideOperation3) {
         self.addOperation = addOperation
         self.subtractOperation = subtractOperation
         self.multiplyOperation = multiplyOperation
         self.divideOperation = divideOperation
     }
 }
             
     
     class AddOperation3 {
         func add(_ num1: Double,_ num2: Double) -> Double {
             return num1 + num2
         }
     }
     
     class SubtractOperation3 {
         func subtract(_ num1: Double,_ num2: Double) -> Double {
             return num1 - num2
         }
     }
     
     class MultiplyOperation3 {
         func multiply(_ num1: Double,_ num2: Double) -> Double {
             return num1 * num2
         }
     }
     
     class DivideOperation3 {
         func divide(_ num1: Double,_ num2: Double) -> Double? {
             if num2 == 0 {
                 print("error")
                 return nil
             } else {
                 return num1 / num2
             }
         }
     }
        
let result3 = Calculator3(addOperation: AddOperation3(), subtractOperation: SubtractOperation3(), multiplyOperation: MultiplyOperation3(), divideOperation: DivideOperation3())

print("계산결과는 \(result3.addOperation.add(6,5))입니다.")
print("계산결과는 \(result3.subtractOperation.subtract(6,5))입니다.")
print("계산결과는 \(result3.multiplyOperation.multiply(6,5))입니다.")
print("계산결과는 \(String(describing: result3.divideOperation.divide(6,5)))입니다.")


// ------------------------------- 미완성: 레벨 4  ----------------------------//

class AbstractOperation {
    var addOperation : AddOperation4
    var subtractOperation : SubtractOperation4
    var multiplyOperation : MultiplyOperation4
    var divideOperation : DivideOperation4
    
    
    init(addOperation: AddOperation4, subtractOperation: SubtractOperation4, multiplyOperation: MultiplyOperation4, divideOperation: DivideOperation4) {
        self.addOperation = addOperation
        self.subtractOperation = subtractOperation
        self.multiplyOperation = multiplyOperation
        self.divideOperation = divideOperation
    }
    func add4(_ num1:Double, _ num2:Double) -> Double{
        return num1 + num2
    }
    func subtract4(_ num1:Double, _ num2:Double) -> Double{
        return num1 - num2
    }
    func multiply4(_ num1:Double, _ num2:Double) -> Double{
        return num1 * num2
    }
    func division4(_ num1:Double, _ num2:Double) -> Double{
        return num1 / num2
    }
}

    class AddOperation4: AbstractOperation {
    override func add4(_ num1:Double, _ num2:Double) -> Double{
        let resultAdd4 = super.add4(6, 5)
        print("계산결과는 \(resultAdd4)입니다.")
        return resultAdd4
        }
    }
    
    class SubtractOperation4: AbstractOperation {
        override func subtract4(_ num1:Double, _ num2:Double) -> Double{
           let resultSubtract4 = super.subtract4(6, 5)
            print("계산결과는 \(resultSubtract4)입니다.")
            return resultSubtract4
        }
    }
    
    class MultiplyOperation4: AbstractOperation {
        override func multiply4(_ num1:Double, _ num2:Double) -> Double{
            let resultMultiply4 = super.multiply4(6, 5)
            print("계산결과는 \(resultMultiply4)입니다.")
            return resultSubtract4
        }
    }
    
    class DivideOperation4: AbstractOperation {
        override func division4(_ num1:Double, _ num2:Double) -> Double{
            let resultDivide4 = super.division4(6, 5)
            print("계산결과는 \(resultDivide4))입니다.")
        }
    }

class Calculator4 {
    var num1 : Double
    var num2 : Double
    
    init(num1: Double, num2: Double) {
        self.num1 = num1
        self.num2 = num2
    }
    let result4 = Calculator4(num1: 6, num2: 5)
}
