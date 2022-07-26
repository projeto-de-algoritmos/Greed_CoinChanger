import Foundation
import SwiftUI

class CoinModel: Identifiable, ObservableObject {
    let value: Int
    @Published var didPress: Bool = false
    @Published var timesAdded = 0
    
    var id: Int {
        value
    }
    
    init(value: Int) {
        self.value = value
    }
    
    func userDidAdd() {
        withAnimation {
            self.didPress = true
            timesAdded += 1
        }
    }
    
    func userDidRemove() {
        withAnimation {
            if didPress && timesAdded > 0{
                timesAdded -= 1
            }
        }
    }
}
