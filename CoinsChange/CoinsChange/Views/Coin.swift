//
//  Coin.swift
//  CoinsChange
//
//  Created by Guilherme Fernandes - pessoal on 25/07/22.
//

import SwiftUI

struct Coin: View {
    @ObservedObject var coinModel: CoinModel
    let id = UUID()
    
    var size: CGFloat {
        switch coinModel.value {
        case _ where coinModel.value >= 10 && coinModel.value < 100:
            return 60
        case _ where coinModel.value >= 100:
            return 40
        default:
            return 80
        }
    }
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.init(red: 1.00, green: 0.80, blue: 0.00))
                Circle()
                    .frame(width: 92, height: 92)
                    .foregroundColor(.init(red: 0.85, green: 0.58, blue: 0.00))
                    .shadow(
                        color: .init(red: 0.81, green: 0.54, blue: 0.01),
                        radius: 2
                    )
                Text(String(coinModel.value))
                    .font(.system(size: size).weight(.black))
                    .foregroundColor(.init(red: 1.00, green: 0.80, blue: 0.00))
                    .shadow(radius: 1)
            }
            .shadow(radius: 5, x: 3, y: 2)
            .overlay(content: {
                if coinModel.didPress && coinModel.timesAdded != 0 {
                    Text("\(coinModel.timesAdded)")
                        .transition(.scale)
                        .font(.title2)
                        .padding(6)
                        .background(.green, in: Circle())
                        .overlay(content: {
                            Circle()
                                .stroke(.black)
                        })
                        .shadow(radius: 3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
            })
            .simultaneousGesture(DragGesture(minimumDistance: 30, coordinateSpace: .local).onEnded({ value in
                if value.translation.height < 0 {
                    coinModel.userDidAdd()
                }
                
                if value.translation.height > 0 {
                    coinModel.userDidRemove()
                }
            }))
        }
    }
}

//struct Coin_Previews: PreviewProvider {
//    static var previews: some View {
//        Coin(coinModel: .init(value: 2))
//    }
//}
