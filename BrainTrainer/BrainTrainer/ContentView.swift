//
//  ContentView.swift
//  BrainTrainer
//
//  Created by A Moses on 25/11/22.
//

import SwiftUI

func getImageFileName(_ moveType: String) -> String
{
    switch moveType
    {
    case "Scissors":
        return "scissors"
    case "Rock":
        return "circle.dashed"
    default:
        return "doc.plaintext"
    }
}

public extension UIFont {
    static func textStyleSize(_ style: UIFont.TextStyle) -> CGFloat {
        UIFont.preferredFont(forTextStyle: style).pointSize
    }
}

struct MoveImage: View
{
    var moveType: String
    
    var body: some View
    {
        Label(moveType, systemImage: getImageFileName(moveType))
        .frame(minWidth: 0, maxWidth: .infinity)
        .font(.system(size: UIFont.textStyleSize(.largeTitle) * 1.3))
        .padding()
        .foregroundColor(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white, lineWidth: 2)
        )
    }
}

struct ContentView: View
{
    let moves = ["Rock", "Paper", "Scissors"]
    
    @State var winOrLoseInstruction = Bool.random()
    @State private var aIMoveSelector = Int.random(in: 0...2)
    @State private var aIMove = ""
    
    @State private var showingScore = false
    @State private var gameFinished = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var qCount = 0
    
    var body: some View
    {
        ZStack
        {
//            RadialGradient(stops: [
//                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.6),
//                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.6),
//            ], center: .bottom, startRadius: 200, endRadius: 500)
//                .ignoresSafeArea()
            
            VStack(spacing: 0)
            {
                Color.red
                Color.orange
                Color.yellow
                Color.green
                Color.blue
                Color.indigo
                Color.purple
            }
            .brightness(-0.05)
            
            VStack
            {
                Spacer()
                
                Text("Brain Trainer")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 15)
                {
                    VStack
                    {
                        Text("It's rock, paper, scissor time! This round, you'll have to:")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)

                        
                        Text(winOrLoseInstruction ? "WIN" : "LOSE")
                            .font(.largeTitle.weight(.semibold))
                            .padding(.bottom, 5)
                        
                        Text("The app chooses:")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text(getAIMove(aIMoveSelector))
                            .font(.largeTitle.weight(.semibold))
                            .padding(.bottom, 5)
                    }
                    
                    ForEach(0..<3)
                    { number in
                        Button
                        {
                            moveTapped(winOrLoseInstruction, getAIMove(aIMoveSelector), getPlayerMove(number))
                        } label:
                        {
                            MoveImage(moveType: moves[number])
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(totalScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            
            .alert("Game Finished. \(scoreTitle)", isPresented: $gameFinished)
            {
                Button("Restart", action: restartGame)
            } message:
            {
                Text("Your score is \(totalScore)")
            }
        }
        .ignoresSafeArea()
    }
    
    func getAIMove(_ aIMoveSelector: Int) -> String
    {
        return moves[aIMoveSelector]
    }
    
    func getPlayerMove(_ number: Int) -> String
    {
        return moves[number]
    }
    
    func moveTapped(_ instruction: Bool, _ aIMove: String, _ playerMove: String)
    {
        var pointModifier = 0;

        print("\(instruction)")
        
        switch aIMove
        {
        case "Scissors":
            switch playerMove
            {
            case "Scissors":
                pointModifier = 0;
            case "Rock":
                pointModifier = 1;
            default:
                pointModifier = -1;
            }
        case "Rock":
            switch playerMove
            {
            case "Scissors":
                pointModifier = -1;
            case "Rock":
                pointModifier = 0;
            default:
                pointModifier = 1;
            }
        default:
            switch playerMove
            {
            case "Scissors":
                pointModifier = 1;
            case "Rock":
                pointModifier = -1;
            default:
                pointModifier = 0;
            }
        }
        
        if instruction == false
        {
            pointModifier = pointModifier * -1
        }
        
        totalScore = totalScore + pointModifier

        qCount += 1
        if qCount == 10
        {
            

            switch totalScore
            {
            case 10:
                scoreTitle = "Perfect score!"
            case 0:
                scoreTitle = "Better luck next time!"
            case 6...9:
                scoreTitle = "Great job! Remember, practise makes perfect."
            default:
                scoreTitle = "Just keep at it."
            }

            gameFinished = true
        }

        aIMoveSelector = Int.random(in: 0...2)
        winOrLoseInstruction.toggle()
    }
    
    func restartGame()
    {
        aIMoveSelector = Int.random(in: 0...2)

        totalScore = 0
        qCount = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
