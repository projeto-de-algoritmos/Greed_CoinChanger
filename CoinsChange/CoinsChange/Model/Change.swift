import Foundation

class Change {
    func minNumOfCoins(_ collection: [Int], _ n: Int, _ value: Int) -> [Int]? {
        if value <= 0 {
            return nil
        }
        
        let coins = collection.sorted()
        
        var record: [Int] = [Int]()
        
        var sum: Int = 0
        var i: Int = n - 1
        var c: Int = 0
        
        while i >= 0 && sum < value {
            // Get coin
            c = coins[i]
            while c + sum <= value {
                // Add coin
                record.append(c)
                // Update sum
                sum += c
            }
            // Reduce position of element
            i -= 1
        }
        if sum == value {
            return record
        }
        else
        {
            return nil
        }
    }
}
