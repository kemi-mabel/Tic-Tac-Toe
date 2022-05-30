//
//  GameViewModel.swift
//  Tic-tac-toe
//
//  Created by Oluwakemi Onajinrin on 5/30/22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
   
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem : AlertItem?
    
    func processPlayerMove(for position: Int ){
        if isSquareOccupied(in: moves, forIndex: position) {
            return
        }
        moves[position] = Move(player: .human, boardIndex: position)
            // check for win condition or draw
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        if checkDrawCondition(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameBoardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            if checkDrawCondition(in: moves) {
                alertItem = AlertContext.draw
                return
            }


        }
    }

    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        // if AI can win, Win
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
  
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer } // removes the nil and filter computer
        let computerPositons = Set(computerMoves.map { $0.boardIndex }) // board index of the player
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositons) //subtracting computer positions from win patterns
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable{
                    return winPositions.first!
                }
            }
        }
        // If AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human } // removes the nil and filter the player we passed in
        let humanPositons = Set(humanMoves.map { $0.boardIndex }) // set of human boardindex
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositons) //subtracting human positions from win patterns
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable{
                    return winPositions.first!
                }
            }
        }
        
        //if AI can't block, then take middle square
        let centersquare = 4
        if !isSquareOccupied(in: moves, forIndex: 4) {
            return centersquare
        }
        
        // if AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)

        }
        return movePosition
    }
    func checkWinCondition(for player: Player, in moves : [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player } // removes the nil and filter the player we passed in
        let playerPositons = Set(playerMoves.map { $0.boardIndex }) //give me a set of all the board index in the player moves
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositons) {
            return true
        }
        
        return false
    }
    
    func checkDrawCondition(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }

}
