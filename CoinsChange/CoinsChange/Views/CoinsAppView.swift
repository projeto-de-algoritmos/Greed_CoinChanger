import SwiftUI
import AVFoundation

struct CoinsAppView: View {
    let id = UUID()
    let number = 2
    @State var didUpdate: Bool = false
    @State var shouldShake: Bool = false
    @State var shouldBestChange: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    @State var showGameInfo: Bool = false
    
    let objetivoDoJogo: String = "O objetivo do jogo é chegar ao número aleatório apresentado com o menor número de moedas possíveis. A checagem é realizada utilizando um algoritmo ambicioso, então só há uma resposta possível."
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    @StateObject var coinViewModel: CoinViewModel = .init()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.viewBackground
                    .ignoresSafeArea()
                VStack {
                    header
                        .padding()
                    skullView
                        .padding(.top, 10)
                        .offset(x: 0, y: shouldShake ? -20 : 0)
                        .animation(.default.repeatCount(30, autoreverses: true).speed(6), value: shouldShake)
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(coinViewModel.coins) { coin in
                                Coin(coinModel: coin)
                            }
                            
                        }
                        .padding()
                    }
                    .padding(.top, 5)
                    Button {
                        coinViewModel.getBestChange()
                        shouldBestChange.toggle()
                    } label: {
                        Image(systemName: "play.circle.fill")
                            .foregroundStyle(didUpdate ? Color.pirateYellow : .white, didUpdate ? Color.pirateBrown : .gray)
                            .font(.system(size: 75))
                    }
                    .padding()
                    .disabled(!didUpdate)
                    .sheet(isPresented: $shouldBestChange, onDismiss: {
                        coinViewModel.cleanSelections()
                        withAnimation {
                            didUpdate = false
                        }
                    }) {
                        ResultView(coinValues: coinViewModel.bestChange, userValues: coinViewModel.getSelectedCoins(), shouldAppear: $shouldBestChange)
                    }
                }
                .onAppear {
                    coinViewModel.populateCoins()
                    let sound = Bundle.main.path(forResource: "coins", ofType: "mp3")
                    self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                }
                .onShake {
                    shouldShake.toggle()
                    coinViewModel.generateNumber()
                    self.audioPlayer.play()
                    if !didUpdate {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            didUpdate.toggle()
                            self.audioPlayer.pause()
                        }
                    }
            }
            }
            .navigationTitle("Coins Change")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: UIColor(.pirateBrown), tintColor: UIColor(.pirateOrange))
            .toolbar {
                Button {
                    showGameInfo.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                }
                .foregroundColor(.pirateOrange)
                .sheet(isPresented: $showGameInfo) {
                    gameInfo
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    private var gameInfo: some View {
        NavigationView {
            ZStack {
                Color.viewBackground
                    .ignoresSafeArea()
                ScrollView {
                    VStack {
                        Text("Objetivo do jogo")
                            .font(.custom("MarkerFelt-Wide", size: 45))
                            .foregroundColor(.pirateOrange)
                        Text(objetivoDoJogo)
                            .font(.custom("MarkerFelt-Wide", size: 20))
                            .padding(.top, 5)
                            .padding(.horizontal)
                            .foregroundColor(.pirateBrown)
                        Image("coins")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .scaledToFit()
                            .padding(.top, 10)
                    }
                }
                .toolbar {
                    
                    Button {
                        showGameInfo.toggle()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private var header: some View {
        RoundedRectangle(cornerRadius: 30)
            .shadow(radius: 9, x: 10, y: 10)
            .overlay {
                Text("Agite o aparelho para gerar um número aleatório")
                    .foregroundColor(.pirateOrange)
                    .font(.custom("MarkerFelt-Wide", size: 30))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 5)
            }
            .frame(width: UIScreen.main.bounds.width - 15)
            .foregroundColor(.pirateBrown)
    }
    
    private var skullView: some View {
        ZStack {
            if !didUpdate {
                Text("☠️")
                    .font(.system(size: 200))
                    .shadow(color: .pirateBrown, radius: 20, x:30, y: 15)
                    .padding()
            } else {
                Text("\(coinViewModel.number)")
                    .font(.custom("Papyrus", size: 120))
            }
        }
    }
}

struct CoinsAppView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsAppView()
    }
}
