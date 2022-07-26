//
//  ResultViewModel.swift
//  CoinsChange
//
//  Created by Guilherme Fernandes - pessoal on 25/07/22.
//

import Foundation

class ResultViewModel {
    func isAnswerCorrect(_ userAnwer: [Int]?, _ coinAnswer: [Int]?) -> Bool {
        return userAnwer == coinAnswer
    }
}
