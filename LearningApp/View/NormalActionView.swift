//
//  NormalActionView.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 07/06/1448 AH.
//

import SwiftUI

struct NormalActionView: View {
    @Bindable var viewModel: ActivityViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            // زر التعلم
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    viewModel.logAsLearned()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(viewModel.isDayLearned ? Color.white.opacity(0.08) : Color.orange)
                        .frame(width: 270, height: 270)
                        .shadow(color: viewModel.isDayLearned ? Color.clear : Color.orange.opacity(0.3), radius: 25, x: 0, y: 10)
                        .overlay(
                            Circle()
                                .stroke(viewModel.isDayLearned ? Color.white.opacity(0.15) : Color.clear, lineWidth: 1)
                        )
                    
                    Text(viewModel.isDayLearned ? "Logged as Learned" : "Log as Learned")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(viewModel.isDayLearned ? Color.gray : .white)
                }
            }
            
            // زر الفريز مع تطبيق شروط التعطيل الموجودة في الصورة
            VStack(spacing: 12) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        viewModel.freezeDay()
                    }
                }) {
                    Text(viewModel.freezeButtonText)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(viewModel.freezeButtonTextColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(viewModel.freezeButtonBackgroundColor)
                        .cornerRadius(26)
                        .overlay(
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(viewModel.freezeButtonStrokeColor, lineWidth: 1)
                        )
                }
             
                .disabled(!viewModel.canFreeze)
                
                Text("\(viewModel.usedFreezes) out of \(viewModel.maxFreezes) Freezes used")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
   // NormalActionView()
}
