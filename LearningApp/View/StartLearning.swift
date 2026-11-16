//
//  StartLearning.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 30/05/1448 AH.
//

import SwiftUI

struct StartLearning: View {
    @State var learn :String=""
    @StateObject private var onboardingVM = OnboardingViewModel()
    
    var body: some View {
       
        VStack{
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width:67, height: 43)
                .foregroundColor(.orange)
                .padding(.bottom,80)
            
            VStack(alignment: .leading){
                
                Text("Hello **Learner**")
                    .padding(.bottom, 4)
                    .font(.system(size: 34))
                   // .frame(width: 237,height: 48)
                
                Text("This app will help you learn everyday!")
                    .padding(.bottom, 37)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                Text("I want to learn")
                
                
                TextField("Swift..", text: $onboardingVM.learningGoal.goalText)
                    .padding(.bottom, 30)
                    .font(.system(size: 16))
                Text("I want to learn it in a ")
                    .padding(.bottom,12)
                
                HStack(spacing: 12) {
                    ForEach(["Week", "Month", "Year"], id: \.self) { duration in
                        let isSelected = onboardingVM.learningGoal.selectedDuration == duration
                        
                        Button {
                         
                                onboardingVM.learningGoal.selectedDuration = duration
                            
                        } label: {
                            Text(duration)
                             //   .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(isSelected ? .white : .gray)
                             //   .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .padding(.horizontal,20)
                        }
                       
                        .glassEffect(
                            isSelected
                            ? .regular.tint(.orange).interactive()
                            : .regular.interactive(),
                            in: .capsule
                        )
                    }
                }
            //    .padding(.horizontal)
                .padding(.bottom, 228)
                
                
            }
            .padding(.leading,17)
            
            Button {
                onboardingVM.saveOnboardingData()
            } label: {
                Text("Start Learning")
                 
            }
            
            .frame(width: 151, height: 46)
            .background(Color.orange)                          .foregroundColor(.white)
            .cornerRadius(30)
            .padding(.bottom, 12)
Text("You can edit your desire later")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        
            
            
        }
       
    }
}

#Preview {
    StartLearning()
}

