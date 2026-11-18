//
//  StatsCardView.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 07/06/1448 AH.
//

import SwiftUI

struct StatsCardView: View {
   
        let viewModel: ActivityViewModel
        
        var body: some View {
            HStack(spacing: 14) {
                // Learned Card
                VStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.orange)
                    
                    Text("\(viewModel.learnedDaysCount) \(viewModel.learnedDaysCount == 1 ? "day" : "days")")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Learned")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.white.opacity(0.06))
                .glassEffect(
                                .regular.tint(.black),
                                in: .rect(cornerRadius: 28)
                            )
                .clipShape(RoundedRectangle(cornerRadius: 28))
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                
                // Freezed Card
                VStack(spacing: 6) {
                    Image(systemName: "snowflake")
                        .font(.system(size: 20))
                        .foregroundColor(Color.cyan)
                    
                    Text("\(viewModel.freezedDaysCount) \(viewModel.freezedDaysCount == 1 ? "day" : "days")")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Freezed")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.white.opacity(0.06))
                .glassEffect(
                                .regular.tint(.black),
                                in: .rect(cornerRadius: 28)
                            )
                .clipShape(RoundedRectangle(cornerRadius: 28))
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1) 
                            )
            }
        }
    }
#Preview {
  // StatsCardView()
}
