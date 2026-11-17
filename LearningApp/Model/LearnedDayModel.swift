//
//  MonthView.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 06/06/1448 AH.
//
import Foundation

// نموذج يمثل يوم تعلم أو نشاط
struct LearnedDayModel: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let dayNumber: Int
    let month: String
    let isLearned: Bool
}
