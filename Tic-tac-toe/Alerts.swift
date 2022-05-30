//
//  Alerts.swift
//  Tic-tac-toe
//
//  Created by Oluwakemi Onajinrin on 5/19/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("Chairman 🙌🏽🙌🏽🙌🏽"),
                             message: Text("smart guyyyy"),
                             buttonTitle: Text("Hell Yeah"))
    
    static let computerWin = AlertItem(title: Text("😬😬😬"),
                             message: Text("You programmed a smart AI"),
                             buttonTitle: Text("Rematch"))
    
    static let draw =        AlertItem(title: Text("Draw"),
                             message: Text("Who is smarter?🤔"),
                             buttonTitle: Text("Try Again"))
}
