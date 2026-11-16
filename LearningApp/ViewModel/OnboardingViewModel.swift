//
//  LearningGoal.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 02/06/1448 AH.
//

import Foundation
import SwiftUI
import Combine

struct LearningGoal{
    var goalText:String=""
    var selectedDuration:String="Week"
    
}
class OnboardingViewModel: ObservableObject {
    @Published var learningGoal = LearningGoal()
    @Published var navigateToMain: Bool = false// @AppStorage("hasCompletedOnboarding")var hasCompletedOnboarding: Bool = false
    func saveOnboardingData() {
        UserDefaults.standard.set(learningGoal.goalText, forKey: "savedLearningGoal")
        UserDefaults.standard.set(learningGoal.selectedDuration, forKey: "savedDuration")
        // حفظ تاريخ ووقت البدء الفعلي لحساب الـ Streak والـ 32 ساعة
        UserDefaults.standard.set(Date(), forKey: "appStartDate")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        navigateToMain = true
    }}
