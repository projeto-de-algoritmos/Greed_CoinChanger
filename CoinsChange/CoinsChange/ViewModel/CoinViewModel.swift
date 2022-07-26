import Foundation

class CoinViewModel: ObservableObject {
    @Published var coins: [CoinModel] = []
    @Published var number: Int = 0
    let change: Change = .init()
    @Published var bestChange: [Int]?
    
    func populateCoins() {
        coins = [
            .init(value: 1),
            .init(value: 2),
            .init(value: 5),
            .init(value: 10),
            .init(value: 25),
            .init(value: 50),
            .init(value: 75),
            .init(value: 100),
            .init(value: 200)
        ]
    }
    
    func getBestChange() {
        let numbers: [Int] = coins.map { $0.value }
        bestChange = change.minNumOfCoins(numbers, numbers.count, number)
    }
    
    func getSelectedCoins() -> [Int] {
        var selectedCoins: [Int] = []
        for coin in coins {
            for _ in 0..<coin.timesAdded {
                selectedCoins.append(coin.value)
            }
        }
        
        return selectedCoins.sorted().reversed()
    }
    
    func generateNumber() {
        number = .random(in: 2...1000)
    }
    
    func cleanSelections() {
        coins.removeAll()
        populateCoins()
    }
}
