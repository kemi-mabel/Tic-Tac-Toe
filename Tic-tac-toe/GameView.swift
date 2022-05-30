//
//  GameView.swift
//  Tic-tac-toe
//
//  Created by Oluwakemi Onajinrin on 5/18/22.
//

import SwiftUI


struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
     
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 10) {
                    ForEach(0..<9) { i  in
                        ZStack{
                            GameSquareView(proxy: geometry)
                            PlayerIndicatorView(systemImageName:  viewModel.moves[i]?.indicators ?? "")
                        }.onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: viewModel.resetGame))
            }
            
        }
    }
}

enum Player{
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicators: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameSquareView: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(.teal).opacity(0.5)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 15)
    }
}

struct PlayerIndicatorView: View {
    var systemImageName: String
    var body: some View {
        
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
