//
//  CalendarHeaderView.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 07/06/1448 AH.
//

import SwiftUI

struct CalendarHeaderView: View {
    @Bindable var viewModel: ActivityViewModel
    var onCalendarTapped: () -> Void
    var onEditTapped:()->Void
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
                    Button(action: {onCalendarTapped()}) {
                    
                        Image(systemName: "calendar")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {(onEditTapped())}) {
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

#Preview {
   //CalendarHeaderView()
}
