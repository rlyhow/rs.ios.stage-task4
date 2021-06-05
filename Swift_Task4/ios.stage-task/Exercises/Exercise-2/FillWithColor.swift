import Foundation

final class FillWithColor {
    
    static var bylo: Int?
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        
        if row < 0 || column < 0 || newColor >= 65536 {
            return image
        } else if image.count < 1 || row >= image.count {
            return image
        } else if image[row].count > 50 || column >= image[row].count {
            return image
        } else if image[row][column] < 0 {
            return image
        }
        
        
        let oldColor = image[row][column]
        var mutableImage = image
        mutableImage[row][column] = newColor
        
        if (image[row].count - 1 > column) {
            if image[row][column + 1] == oldColor && FillWithColor.bylo != newColor {
                FillWithColor.bylo = image[row][column]
                mutableImage = fillWithColor(mutableImage, row, column + 1, newColor)
            }
        }
        
        if (0 < column) {
            if image[row][column - 1] == oldColor && FillWithColor.bylo != newColor {
                FillWithColor.bylo = image[row][column]
                mutableImage = fillWithColor(mutableImage, row, column - 1, newColor)
            }
        }
        
        if (image.count - 1 > row) {
            if image[row + 1][column] == oldColor && FillWithColor.bylo != newColor {
                FillWithColor.bylo = image[row][column]
                mutableImage = fillWithColor(mutableImage, row + 1, column, newColor)
            }
        }
        
        if (0 < row) {
            if image[row - 1][column] == oldColor && FillWithColor.bylo != newColor {
                FillWithColor.bylo = image[row][column]
                mutableImage = fillWithColor(mutableImage, row - 1, column, newColor)
            }
        }
        
        return mutableImage
    }
}
