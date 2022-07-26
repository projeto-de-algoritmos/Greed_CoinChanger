//
//  ResultView.swift
//  CoinsChange
//
//  Created by Guilherme Fernandes - pessoal on 25/07/22.
//

import SwiftUI
import NavigationBar
import AVFAudio

struct ResultView: View {
    let coinValues: [Int]?
    let userValues: [Int]?
    let resultViewModel: ResultViewModel = .init()
    @State var shouldShake: Bool = false
    @State var shouldShowAnswer: Bool = false
    @State var avAudio: AVAudioPlayer!
    @Binding var shouldAppear: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.viewBackground
                    .ignoresSafeArea()
                VStack(spacing: 80) {
                    let answer = resultViewModel.isAnswerCorrect(userValues, coinValues)
                    Image(systemName: answer ? "checkmark.circle" : "xmark.circle")
                        .foregroundColor(answer ? .pirateGreen : .pirateRed)
                        .font(.system(size: 120))
                        .padding(.top, 30)
                        .onAppear {
                            if answer {
                                let sound = Bundle.main.path(forResource: "success", ofType: "mp3")
                                self.avAudio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                            } else {
                                let sound = Bundle.main.path(forResource: "failure", ofType: "mp3")
                                self.avAudio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                            }
                            self.avAudio.play()
                        }
                    VStack(spacing: 30) {
                        userAnswer
                        changeAnswer
                    }
                }
                .navigationTitle("TROCO".uppercased())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(backgroundColor: UIColor(.pirateBrown), tintColor: .white)
                .toolbar {
                    Button {
                        shouldAppear.toggle()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundColor(.pirateOrange)
                }
            }
        }
        .onShake {
            withAnimation {
                shouldShake.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                withAnimation {
                    shouldShowAnswer = true
                }
            }
        }
    }
    
    private var changeAnswer: some View {
        VStack {
            if shouldShowAnswer {
                Text("As respostas corretas")
                    .font(.custom("MarkerFelt-Wide", size: 30).bold())
                answer(coinValues)
            } else {
                RoundedRectangle(cornerRadius: 30)
                    .overlay {
                        Text("Agite para revelar as respostas corretas")
                            .font(.title.bold())
                            .foregroundColor(.white)
                    }
                    .padding()
                    .padding(.vertical)
                    .offset(y: shouldShake ? -15 : 0)
                    .animation(.default.repeatCount(20, autoreverses: true).speed(6), value: shouldShake)
            }
        }
    }
    
    private var userAnswer: some View {
        VStack {
            Text("Suas respostas")
                .font(.custom("MarkerFelt-Wide", size: 30).bold())
            answer(userValues)
        }
    }
    
    private func answer(_ values: [Int]?) -> some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack {
                if let values = values {
                    ForEach(0..<values.count, id: \.self) { i in
                        coinView(values[i])
                    }
                }
            }
            .padding()
        }
    }
    
    private func coinView(_ val: Int) -> some View {
        Coin(coinModel: .init(value: val))
    }
}

//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView(coinValues: [20, 50, 100], userValues: [1, 1, 1])
//    }
//}
