import SwiftUI

struct Card: Identifiable {

    let id = UUID()
    var isLit = false
}

struct LightItUpView: View {

    @AppStorage("lightItUpHighScore")
    private var highScore = 0

    @State private var cards: [Card] =
        (0..<3).map { _ in Card() }

    @State private var score = 0
    @State private var timeRemaining = 60

    @State private var litIndex = 0

    @State private var gameOver = false

    let timer =
        Timer.publish(
            every: 1,
            on: .main,
            in: .common
        ).autoconnect()

    var currentLevel: Int {

        switch timeRemaining {

        case 46...60:
            return 1

        case 31...45:
            return 2

        case 16...30:
            return 3

        default:
            return 4
        }
    }

    var columns: [GridItem] {

        switch currentLevel {

        case 1:
            return Array(repeating: GridItem(.flexible()), count: 3)

        case 2:
            return Array(repeating: GridItem(.flexible()), count: 4)

        case 3:
            return Array(repeating: GridItem(.flexible()), count: 3)

        default:
            return Array(repeating: GridItem(.flexible()), count: 3)
        }
    }

    var body: some View {

        VStack {

            Text("Light It Up")
                .font(.largeTitle)

            Text("Score: \(score)")
                .font(.title2)

            Text("High Score: \(highScore)")
                .font(.headline)

            Text("Time: \(timeRemaining)")
                .font(.headline)

            Text("Level \(currentLevel)")
                .font(.title3)

            LazyVGrid(columns: columns) {

                ForEach(cards.indices, id: \.self) { index in

                    RoundedRectangle(cornerRadius: 12)
                        .fill(cards[index].isLit ? .yellow : .gray)
                        .frame(width: 80, height: 80)
                        .onTapGesture {

                            if cards[index].isLit {

                                score += 1
                                cards[index].isLit = false

                            } else {

                                score -= 1
                            }
                        }
                }
            }
            .padding()

        }
        .onAppear {

            setupLevel()
            lightRandomCard()
        }
        .onReceive(timer) { _ in

            if gameOver { return }

            timeRemaining -= 1

            if timeRemaining <= 0 {

                gameOver = true

                if score > highScore {
                    highScore = score
                }

                return
            }

            setupLevel()
            lightRandomCard()
        }
        .alert("Game Over", isPresented: $gameOver) {

            Button("Play Again") {

                score = 0
                timeRemaining = 60
                setupLevel()
                lightRandomCard()
                gameOver = false
            }

        } message: {

            Text("Final Score: \(score)")
        }
    }

    func setupLevel() {

        switch currentLevel {

        case 1:
            cards = (0..<3).map { _ in Card() }

        case 2:
            cards = (0..<4).map { _ in Card() }

        case 3:
            cards = (0..<6).map { _ in Card() }

        default:
            cards = (0..<9).map { _ in Card() }
        }
    }

    func lightRandomCard() {

        for i in cards.indices {
            cards[i].isLit = false
        }

        litIndex = Int.random(in: 0..<cards.count)

        cards[litIndex].isLit = true
    }
}

#Preview {
    LightItUpView()
}
