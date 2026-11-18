//
//  ActivityView.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 07/06/1448 AH.
//

import SwiftUI
import Combine

// MARK: - Main UI View
struct ActivityView: View {
    @State private var showCalendar = false
    @State private var viewModel = ActivityViewModel()
    @State private var showEditGoal = false
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // الهيدر العلوي مع زر التقويم وزر التعديل (القلم)
                    CalendarHeaderView(viewModel: viewModel) {
                        showCalendar = true
                    } onEditTapped: {
                        showEditGoal = true // 👈 فتح صفحة تعديل الهدف عند الضغط على زر القلم
                    }
                    
                    // كروت الإحصائيات (Learned & Freezed)
                    StatsCardView(viewModel: viewModel)
                        .padding(.bottom, 12)
                    
                    // الأجزاء التفاعلية (زر التعلم وزر الفريز)
                    ActionSectionView(viewModel: viewModel) {
                        showEditGoal = true
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showCalendar) {
                ActivitiesCalendarView()
            }
            .onAppear {
                viewModel.checkTimeElapsed()
            }
            .onReceive(timer) { _ in
                viewModel.checkTimeElapsed()
            }
            .sheet(isPresented: $showEditGoal) {
                EditGoalView {
                    viewModel.resetForNewGoal()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ActivityView()
}
