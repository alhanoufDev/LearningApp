//
//  ActionSectionView.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 07/06/1448 AH.
//

import SwiftUI

struct ActionSectionView: View {
    @Bindable var viewModel: ActivityViewModel
    var onSetGoalTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            if viewModel.hasFailedGoal {
                GoalStatusCardView(
                    model: .failed,
                    onButtonTapped: onSetGoalTapped
                )
            } else if viewModel.hasCompletedGoal {
                GoalStatusCardView(
                    model: .completed,             onButtonTapped: onSetGoalTapped
                )
            } else {
                NormalActionView(viewModel: viewModel)
            }
        }
    }
}
    #Preview {
        //   ActionSectionView()
    }

