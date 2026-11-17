//
//  ActivitiesCalendarView.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 06/06/1448 AH.
//

import SwiftUI

struct ActivitiesCalendarView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 32) {
                    ForEach(generateDynamicMonths(), id: \.id) { monthInfo in
                        MonthGridView(title: monthInfo.title, year: monthInfo.year, month: monthInfo.month)
                            .id(monthInfo.id)
                        
                        Divider().background(Color.gray.opacity(0.2))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Circle())
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Activities")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                let currentID = "\(Calendar.current.component(.year, from: Date()))-\(Calendar.current.component(.month, from: Date()))"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation { proxy.scrollTo(currentID, anchor: .top) }
                }
            }
        }
    }
    
    private func generateDynamicMonths() -> [(id: String, title: String, year: Int, month: Int)] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let currentDate = Date()
        var months: [(id: String, title: String, year: Int, month: Int)] = []
        
        for offset in -6...6 {
            if let target = calendar.date(byAdding: .month, value: offset, to: currentDate) {
                let comps = calendar.dateComponents([.year, .month], from: target)
                if let year = comps.year, let month = comps.month {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM yyyy"
                    months.append((id: "\(year)-\(month)", title: formatter.string(from: target), year: year, month: month))
                }
            }
        }
        return months
    }
}

// مكون عرض كل شهر بشكل مختصر
struct MonthGridView: View {
    let title: String
    let year: Int
    let month: Int
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    let weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day).font(.system(size: 11, weight: .semibold)).foregroundColor(.gray)
                }
            }
            
            let cells = generateCells(year: year, month: month)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(cells.indices, id: \.self) { index in
                    if let day = cells[index] {
                        let date = getDate(day: day, month: month, year: year)
                        let isToday = Calendar.current.isDateInToday(date)
                        
                        // جلب حالة اليوم الحالي بدقة مطابقة تماماً لشاشة الأنشطة الرئيسية
                        let isLearned = isToday ? UserDefaults.standard.bool(forKey: "isTodayLearned") : false
                        let isFreezed = isToday ? UserDefaults.standard.bool(forKey: "isTodayFreezed") : false
                        
                        // تحديد الألوان بناءً على الحالة (مطابق تماماً لـ ActivityView)
                        let textColor: Color = isFreezed ? .cyan : (isLearned ? .orange : (isToday ? .white : .white))
                        let bgColor: Color = isFreezed ? .cyan.opacity(0.2) : (isLearned ? .orange.opacity(0.2) : (isToday ? .orange : .clear))
                        let strokeColor: Color = isFreezed ? .cyan : (isLearned ? .orange : .clear)
                        
                        ZStack {
                            Text("\(day)")
                                .font(.system(size: 15, weight: (isToday || isLearned || isFreezed) ? .bold : .regular))
                                .frame(width: 36, height: 36)
                                .background(
                                    Circle().fill(bgColor)
                                )
                                .overlay(
                                    Circle().stroke(strokeColor, lineWidth: 1)
                                )
                                .foregroundColor(textColor)
                        }
                    } else {
                        Color.clear.frame(width: 36, height: 36)
                    }
                }
            }
        }
    }
    
    private func getDate(day: Int, month: Int, year: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }
    
    private func generateCells(year: Int, month: Int) -> [Int?] {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        guard let firstDate = cal.date(from: DateComponents(year: year, month: month, day: 1)),
              let range = cal.range(of: .day, in: .month, for: firstDate) else { return [] }
        
        let spaces = cal.component(.weekday, from: firstDate) - 1
        var result: [Int?] = Array(repeating: nil, count: spaces)
        result.append(contentsOf: range.map { Optional($0) })
        return result
    }
}

#Preview {
    NavigationStack {
        ActivitiesCalendarView().preferredColorScheme(.dark)
    }
}
