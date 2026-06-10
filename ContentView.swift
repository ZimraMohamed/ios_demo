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
