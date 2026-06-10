import SwiftUI

struct ContentView: View {
    // Core game state variables
    @State private var score = 0 [cite: 45]
    @State private var timeRemaining = 10 [cite: 13, 31]
    @State private var isGameActive = true
    
    var body: some View {
        VStack {
            if isGameActive {
                // --- GAME SCREEN --- [cite: 9]
                VStack(spacing: 30) {
                    // Score and Timer Display [cite: 12, 13]
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
                    
                    // Main Tap Target [cite: 11]
                    Button(action: {
                        score += 1 [cite: 15, 45]
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
                    
                    Spacer()
                }
                .padding()
                
            } else {
                // --- GAME OVER SCREEN --- [cite: 10, 48]
                VStack(spacing: 25) {
                    Text("Game Over")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.red)
                    
                    Text("Final Score: \(score)") [cite: 17, 69]
                        .font(.title)
                    
                    // Play Again button [cite: 18, 69]
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
    }
    
    func resetGame() {
        score = 0
        timeRemaining = 10

      


      let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() [cite: 57]

      

      // Attach this to the outermost VStack inside your body
.onReceive(timer) { _ in
    guard isGameActive else { return }
    if timeRemaining > 0 {
        timeRemaining -= 1 [cite: 57]
    } else {
        isGameActive = false // Disables the game interface [cite: 16, 58]
    }
}

      

      @State private var buttonX: CGFloat = 0
@State private var buttonY: CGFloat = 0
        isGameActive = true
    }
}



// Inside .onReceive, every time timeRemaining changes:
if timeRemaining % 2 == 0 {
    withAnimation(.easeInOut) { [cite: 63]
        buttonX = CGFloat.random(in: -100...100)
        buttonY = CGFloat.random(in: -150...150)
    }
}



.offset(x: buttonX, y: buttonY)


.scaleEffect(CGFloat(timeRemaining) / 10.0 + 0.3) // Won't shrink below 30% scale
.animation(.spring(), value: timeRemaining)
