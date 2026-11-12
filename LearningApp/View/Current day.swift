import SwiftUI

// MARK: - Main UI View
struct ActivityView: View {
    @State private var viewModel = ActivityViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                CalendarHeaderView(viewModel: viewModel)
                
                StatsCardView(viewModel: viewModel)
                
                Spacer()
                
                ActionSectionView(viewModel: viewModel)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
}

// MARK: - Calendar Header Subview
struct CalendarHeaderView: View {
    @Bindable var viewModel: ActivityViewModel // تم استخدام @Bindable لضمان التحديث الفوري للـ UI
    
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
                    VStack(spacing: 8) {
                        Text(day.dayOfWeek)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("\(day.dayNumber)")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(day.isSelected ? .black : .white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(day.isSelected ? Color.orange : Color.white.opacity(0.08))
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        viewModel.selectDay(day)
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

// MARK: - Action Section Subview (Log Circle & Freeze Button)
struct ActionSectionView: View {
    let viewModel: ActivityViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            // 1. Log as Learned Circle
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
            .disabled(viewModel.isDayFreezed)
            
            // 2. Freeze Button Section
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.freezeDay()
                }) {
                    Text("Freeze for a day")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(viewModel.canFreeze ? .white : Color.gray.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(viewModel.canFreeze ? Color.cyan : Color.white.opacity(0.06))
                        .cornerRadius(26)
                        .overlay(
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(viewModel.canFreeze ? Color.clear : Color.white.opacity(0.08), lineWidth: 1)
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

// MARK: - Preview
#Preview {
    ActivityView()
}
