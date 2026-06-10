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





import SwiftUI

struct ContentView: View {

    // MARK: - Game State

    @State private var score = 0
    @State private var highScore = 0
    @State private var timeRemaining = 10

    // Challenge 1 - Trap Colour
    @State private var buttonColor: Color = .green

    // Timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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

                    // Trap Colour Challenge
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
                ) // Shrinking Button Challenge
                .background(buttonColor)
                .clipShape(Circle())

                Spacer()

                Text(buttonColor == .green ?
                     "Green = +2 Points" :
                     "Grey = -1 Point")
                .font(.headline)

            }
            .padding()
            .onReceive(timer) { _ in

                if timeRemaining > 0 {

                    timeRemaining -= 1

                    // Change colour every second
                    buttonColor = Bool.random() ? .green : .gray

                    // Save High Score when game ends
                    if timeRemaining == 0 {
                        if score > highScore {
                            highScore = score
                        }
                    }
                }
            }

        } else {

            VStack(spacing: 25) {

                Text("🎮 Game Over")
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

#Preview {
    ContentView()
}
