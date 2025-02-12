//
//  HealthyRelationshipManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/4/23.
//

import Foundation


class HealthyRelationshipManager: ObservableObject {
    
    @Published var sumOneThroughFour: Int = 0
    @Published var sumFiveThroughEight: Int = 0
    @Published var sumNineAndAbove: Int = 0
    
    @Published var result: Int?
    
    @Published var questionScores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    @Published var isResultsPopupShowing: Bool = false
    
    func calculateResult() {
        self.sumOneThroughFour = 0
        self.sumFiveThroughEight = 0
        self.sumNineAndAbove = 0
        
        print(self.questionScores)
        
        // Questions 1 through 4
        for i in 0...3 {
            if questionScores[i] == 0 {
                sumOneThroughFour += 1
            }
        }
        
        // Questions 5 through 8
        for i in 4...7 {
            if questionScores[i] == 1 {
                sumFiveThroughEight += 1
            }
        }
        
        // Questions 9 thorugh 26
        for i in 8...25 {
            if questionScores[i] == 1 {
                sumNineAndAbove += 1
            }
        }
        
        let totalSum = sumOneThroughFour + sumFiveThroughEight + sumNineAndAbove
        
        switch totalSum {
        case 0: result = 0
        case 1...4: result = 1
        case 5...9: result = 2
        case 10...26: result = 3
        default: result = -1
        }
        
//        print("total sum = \(totalSum)")
    }
}
