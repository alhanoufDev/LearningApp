//
//  ActivitiesCalendarViewModel.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 06/06/1448 AH.
//

import SwiftUI
import Combine
class ActivitiesCalendarViewModel: ObservableObject {
    // الأيام المتعلمة لكل شهر
    @Published var learnedDays: Set<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        @Published var februaryLearned: Set<Int> = Set(1...29) // 👈 التصحيح الصحيح لتحويل النطاق إلى Set
        @Published var marchLearned: Set<Int> = Set(1...12)
}
