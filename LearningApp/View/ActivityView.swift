import SwiftUI
import Combine

// MARK: - Main UI View
struct ActivityView: View {
    @State private var viewModel = ActivityViewModel()
    @State private var showEditGoal = false
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                CalendarHeaderView(viewModel: viewModel)
                
                StatsCardView(viewModel: viewModel)
                
                Spacer()
                
                ActionSectionView(viewModel: viewModel) {
                    showEditGoal = true
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
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

// MARK: - Calendar Header Subview
struct CalendarHeaderView: View {
    @Bindable var viewModel: ActivityViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Activity")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(viewModel.selectedDateDescription)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "calendar")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "pencil.line")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                }
            }
            
            // شريط الأيام الأسبوعية
            HStack(spacing: 0) {
                ForEach(viewModel.days) { day in
                    let isToday = Calendar.current.isDateInToday(day.date)
                    let textColor: Color = day.isFreezed ? .cyan : (day.isLearned ? .orange : (day.isSelected ? .black : .white))
                    let bgColor: Color = day.isFreezed ? .cyan.opacity(0.2) : (day.isLearned ? .orange.opacity(0.2) : (day.isSelected ? .orange : Color.white.opacity(0.08)))
                    let strokeColor: Color = day.isFreezed ? .cyan : (day.isLearned ? .orange : .clear)
                    
                    VStack(spacing: 8) {
                        Text(day.dayOfWeek)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(isToday ? .white : .gray)
                        
                        Text("\(day.dayNumber)")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(textColor)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle().fill(bgColor)
                            )
                            .overlay(
                                Circle().stroke(strokeColor, lineWidth: 1)
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .opacity(isToday || day.isLearned || day.isFreezed ? 1.0 : 0.4)
                    .onTapGesture {
                        if isToday {
                            viewModel.selectDay(day)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Stats Cards Subview
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
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Learned")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.white.opacity(0.06))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            
            // Freezed Card
            VStack(spacing: 6) {
                Image(systemName: "snowflake")
                    .font(.system(size: 20))
                    .foregroundColor(Color.cyan)
                
                Text("\(viewModel.freezedDaysCount) \(viewModel.freezedDaysCount == 1 ? "day" : "days")")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Freezed")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.white.opacity(0.06))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
    }
}

// MARK: - Action Section Subview
struct ActionSectionView: View {
    @Bindable var viewModel: ActivityViewModel
    var onSetGoalTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            if viewModel.hasFailedGoal {
                FailedGoalView(onSetGoalTapped: onSetGoalTapped)
            } else {
                NormalActionView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Subview لشاشة الفشل
struct FailedGoalView: View {
    var onSetGoalTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "xmark.shield.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)
                .padding(16)
                .background(Color.orange.opacity(0.15))
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.orange.opacity(0.4), lineWidth: 1)
                )
            
            VStack(spacing: 6) {
                Text("You didn't reach your goal this time.")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Want to set another goal?")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                onSetGoalTapped()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil.line")
                    Text("Set a goal")
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.orange)
                .cornerRadius(26)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 30)
        .background(Color.white.opacity(0.04))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
}

// MARK: - Subview للأزرار العادية (Log و Freeze)
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
            
            // زر الفريز
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
                
                Text("\(viewModel.usedFreezes) out of \(viewModel.maxFreezes) Freezes used")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ActivityView()
}
