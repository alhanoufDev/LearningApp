//
//  GoalStatusModel.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 07/06/1448 AH.
//

import Foundation

struct GoalStatusModel {
    let iconName: String
    let title: String
    let subtitle: String
    let buttonTitle: String
    
    // تعريف الثوابت جاهزة مرة واحدة فقط هنا:
    static let completed = GoalStatusModel(
        iconName: "hand.raised.fill",
        title: "Will done!",
        subtitle: "Ready for your next goal?",
        buttonTitle: "Set a goal"
    )
    
    static let failed = GoalStatusModel(
        iconName: "xmark.shield.fill",
        title: "You didn't reach your goal this time.",
        subtitle: "Want to set another goal?",
        buttonTitle: "Set a goal"
    )
}
