//
//  DayItem.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 01/06/1448 AH.
//

import Foundation

struct DayItem: Identifiable {
    let id = UUID()
    let dayOfWeek: String
    let dayNumber: Int
    let date: Date
    var isSelected: Bool = false
    var isLearned: Bool = false
    var isFreezed: Bool = false
}
