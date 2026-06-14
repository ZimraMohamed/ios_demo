import SwiftUI

struct ContentView: View {
    // --- CORE GAME STATE ---
    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var isGameActive = true
    
    // Timer publisher that ticks every 1 second on the main thread
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // --- CHALLENGE STATE VARIABLES ---
    // Challenge 3: Moving Target positions
    @State private var buttonX: CGFloat = 0
    @State private var buttonY: CGFloat = 0
    
    var body: some View {
        VStack {
            if isGameActive {
                // ==========================================
                // 1. GAME SCREEN
                // ==========================================
                VStack(spacing: 30) {
                    // Score and Timer HUD Display
                    HStack {
                        Text("Score: \(score)")
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Text("Time: \(timeRemaining)s")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Main Interactive Tap Button
                    Button(action: {
                        // Core requirement: increment score on tap
                        score += 1
                    }) {
                        Text("TAP!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 150, height: 150)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    // Challenge 4: Shrinking Button Modifier
                    // The button scale smoothly drops from 1.3x down toward 0.3x as time runs out
                    .scaleEffect(CGFloat(timeRemaining) / 10.0 + 0.3)
                    .animation(.spring(), value: timeRemaining)
                    
                    // Challenge 3: Moving Target Modifier
                    // Shifts the button around the layout screen space dynamically
                    .offset(x: buttonX, y: buttonY)
                    
                    Spacer()
                }
                .padding()
                
            } else {
                // ==========================================
                // 2. GAME OVER SCREEN
                // ==========================================
                VStack(spacing: 25) {
                    Text("Game Over")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.red)
                    
                    Text("Final Score: \(score)")
                        .font(.title)
                        .bold()
                    
                    // Play Again button to completely reset state parameters
                    Button(action: {
                        resetGame()
                    }) {
                        Text("Play Again")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 50)
                }
            }
        }
        // Core Logic: Monitor the real-time clock cycles to drop remaining seconds
        .onReceive(timer) { _ in
            guard isGameActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
                
                // Challenge 3 Logic: Every 2 seconds, trigger a random position shift
                if timeRemaining % 2 == 0 {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        // Keep random movements within reasonable screen boundaries
                        buttonX = CGFloat.random(in: -90...90)
                        buttonY = CGFloat.random(in: -130...130)
                    }
                }
            } else {
                // Timer hits zero: cleanly flip game active flag to swap UI screens
                isGameActive = false
            }
        }
    }
    
    /// Resets all properties back to base defaults to start a brand new match
    func resetGame() {
        score = 0
        timeRemaining = 10
        buttonX = 0
        buttonY = 0
        isGameActive = true
    }
}

// Preview provider for Xcode Canvas rendering
#Preview {
    ContentView()
}


// ======================================================================================================================


import SwiftUI
import Combine

// MARK: - Card Model

struct Card: Identifiable {
    let id = UUID()
    var isLit = false
}

// MARK: - Home Screen

struct ContentView: View {

    var body: some View {

        NavigationStack {

            VStack(spacing: 30) {

                Text("Mini Arcade")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                NavigationLink("Tap Frenzy") {
                    TapFrenzyView()
                }
                .frame(width: 250, height: 60)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)

                NavigationLink("Light It Up") {
                    LightItUpView()
                }
                .frame(width: 250, height: 60)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .navigationTitle("Home")
        }
    }
}

// MARK: - Week 1 Game

struct TapFrenzyView: View {

    @State private var score = 0

    @AppStorage("tapFrenzyHighScore")
    private var highScore = 0

    @State private var timeRemaining = 10

    @State private var buttonColor: Color = .green

    private let timer =
        Timer.publish(
            every: 1,
            on: .main,
            in: .common
        ).autoconnect()

    var body: some View {

        if timeRemaining > 0 {

            VStack(spacing: 30) {

                Text("Tap Frenzy")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Score: \(score)")
                    .font(.title)

                Text("High Score: \(highScore)")
                    .font(.title3)

                Text("Time: \(timeRemaining)")
                    .font(.title2)

                Spacer()

                Button(action: {

                    if buttonColor == .green {
                        score += 2
                    } else {
                        score -= 1
                    }

                }) {

                    Text("TAP")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(
                    width: CGFloat(100 + timeRemaining * 10),
                    height: CGFloat(100 + timeRemaining * 10)
                )
                .background(buttonColor)
                .clipShape(Circle())

                Spacer()

                Text(
                    buttonColor == .green
                    ? "Green = +2 Points"
                    : "Grey = -1 Point"
                )
                .font(.headline)

            }
            .padding()
            .onReceive(timer) { _ in

                if timeRemaining > 0 {

                    timeRemaining -= 1

                    buttonColor =
                        Bool.random() ? .green : .gray

                    if timeRemaining == 0 {

                        if score > highScore {
                            highScore = score
                        }
                    }
                }
            }

        } else {

            VStack(spacing: 25) {

                Text("Game Over")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Final Score")
                    .font(.title2)

                Text("\(score)")
                    .font(.system(size: 50))
                    .fontWeight(.bold)

                Text("High Score: \(highScore)")
                    .font(.title3)

                Button("Play Again") {

                    score = 0
                    timeRemaining = 10
                    buttonColor = .green
                }
                .padding()
                .frame(width: 200)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

// MARK: - Week 2 Game

struct LightItUpView: View {

    @AppStorage("lightItUpHighScore")
    private var highScore = 0

    @State private var score = 0
    @State private var timeRemaining = 60

    @State private var cards: [Card] =
        (0..<3).map { _ in Card() }

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
            return Array(
                repeating: GridItem(.flexible()),
                count: 3
            )

        case 2:
            return Array(
                repeating: GridItem(.flexible()),
                count: 4
            )

        default:
            return Array(
                repeating: GridItem(.flexible()),
                count: 3
            )
        }
    }

    var body: some View {

        VStack(spacing: 20) {

            Text("Light It Up")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Score: \(score)")
                .font(.title2)

            Text("High Score: \(highScore)")
                .font(.headline)

            Text("Time: \(timeRemaining)")
                .font(.headline)

            Text("Level \(currentLevel)")
                .font(.title3)

            LazyVGrid(columns: columns, spacing: 15) {

                ForEach(cards.indices, id: \.self) { index in

                    RoundedRectangle(
                        cornerRadius: 12
                    )
                    .fill(
                        cards[index].isLit
                        ? .yellow
                        : .gray
                    )
                    .frame(
                        width: 80,
                        height: 80
                    )
                    .scaleEffect(
                        cards[index].isLit ? 1.1 : 1
                    )
                    .animation(
                        .easeInOut,
                        value: cards[index].isLit
                    )
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

            Spacer()
        }
        .padding()
        .onAppear {

            setupLevel()
            lightRandomCards()
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
            lightRandomCards()
        }
        .alert("Game Over",
               isPresented: $gameOver) {

            Button("Play Again") {

                score = 0
                timeRemaining = 60
                gameOver = false

                setupLevel()
                lightRandomCards()
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

    func lightRandomCards() {

        for i in cards.indices {
            cards[i].isLit = false
        }

        if currentLevel == 4 {

            let first =
                Int.random(in: 0..<cards.count)

            var second =
                Int.random(in: 0..<cards.count)

            while second == first {
                second =
                    Int.random(in: 0..<cards.count)
            }

            cards[first].isLit = true
            cards[second].isLit = true

        } else {

            let random =
                Int.random(in: 0..<cards.count)

            cards[random].isLit = true
        }
    }
}

#Preview {
    ContentView()
}


// ==========================================================================================


import SwiftUI

@main
struct TapFrenzyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
