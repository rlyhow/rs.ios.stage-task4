import Foundation

public extension Int {
    
    var roman: String? {
        var romanNumberResult = ""
        let numberToString = String(self)
        
        let thousandsArray = ["M", "MM", "MMM"]
        let hundredsArray = ["C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"]
        let dozensArray = ["X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"]
        let unitsArray = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]
        let array = [unitsArray, dozensArray, hundredsArray, thousandsArray]
        
        if self < 1 || self > 3999 {
            return nil
        }
        
        var cnt: Int = numberToString.count
        var indexElement: Int
        
        for element in numberToString {
            indexElement = Int(String(element)) ?? 0
            if indexElement == 0 {
                cnt-=1
                continue
            }
            romanNumberResult.append(array[cnt - 1][indexElement - 1])
            cnt-=1
        }
        
        return romanNumberResult
    }
}
