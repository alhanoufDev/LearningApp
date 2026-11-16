import Foundation
import SwiftUI

@Observable
final class ActivityViewModel {
    var selectedDateDescription: String = ""
    var days: [DayItem] = []
    
    var learnedDaysCount: Int = 0 {
        didSet { UserDefaults.standard.set(learnedDaysCount, forKey: "learnedDaysCount") }
    }
    var freezedDaysCount: Int = 0 {
        didSet { UserDefaults.standard.set(freezedDaysCount, forKey: "freezedDaysCount") }
    }
    var usedFreezes: Int = 0 {
        didSet { UserDefaults.standard.set(usedFreezes, forKey: "usedFreezes") }
    }
    let maxFreezes: Int = 2
    
    var selectedDayIndex: Int = 0
    var hasFailedGoal: Bool = false
    
    var lastActivityDate: Date = {
        if let savedDate = UserDefaults.standard.object(forKey: "appStartDate") as? Date {
            return savedDate
        } else {
            let initialDate = Date()
            UserDefaults.standard.set(initialDate, forKey: "appStartDate")
            return initialDate
        }
    }()

    var currentSelectedDay: DayItem {
        guard days.indices.contains(selectedDayIndex) else {
            return days.first ?? DayItem(dayOfWeek: "S", dayNumber: 1, date: Date())
        }
        return days[selectedDayIndex]
    }
    
    var isTodaySelected: Bool {
        Calendar.current.isDateInToday(currentSelectedDay.date)
    }
    
    var isDayLearned: Bool {
        currentSelectedDay.isLearned
    }
    
    var isDayFreezed: Bool {
        currentSelectedDay.isFreezed
    } 
    
    var canFreeze: Bool {
        usedFreezes < maxFreezes || currentSelectedDay.isFreezed
    }
    
    init() {
        setupWeekDays()
        loadTodayState() // استرجاع حالة اليوم الحالي المحفوظة فوراً
        checkTimeElapsed()
    }
    
    // MARK: - حفظ واسترجاع حالة اليوم الحالي مباشرة (طريقة ذكية وسريعة)
    private func saveTodayState() {
        let today = currentSelectedDay.date
        // حفظ مفاتيح خاصة بيوم اليوم لتجنب أي تعقيد
        UserDefaults.standard.set(currentSelectedDay.isLearned, forKey: "isTodayLearned")
        UserDefaults.standard.set(currentSelectedDay.isFreezed, forKey: "isTodayFreezed")
        UserDefaults.standard.set(today, forKey: "savedDayDate")
    }
    
    private func loadTodayState() {
        learnedDaysCount = UserDefaults.standard.integer(forKey: "learnedDaysCount")
        freezedDaysCount = UserDefaults.standard.integer(forKey: "freezedDaysCount")
        usedFreezes = UserDefaults.standard.integer(forKey: "usedFreezes")
        
        // التحقق مما إذا كانت البيانات المحفوظة تخص نفس يوم اليوم (لتجنب بقاء بيانات قديمة لأيام مضت)
        if let savedDate = UserDefaults.standard.object(forKey: "savedDayDate") as? Date,
           Calendar.current.isDateInToday(savedDate) {
            
            let isLearned = UserDefaults.standard.bool(forKey: "isTodayLearned")
            let isFreezed = UserDefaults.standard.bool(forKey: "isTodayFreezed")
            
            if let index = days.firstIndex(where: { Calendar.current.isDateInToday($0.date) }) {
                days[index].isLearned = isLearned
                days[index].isFreezed = isFreezed
            }
        }
    }

    func setupWeekDays() {
        let calendar = Calendar.current
        let today = Date()
        let dayNames = ["S", "M", "T", "W", "T", "F", "S"]
        
        var generatedDays: [DayItem] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i - 3, to: today) {
                let dayNumber = calendar.component(.day, from: date)
                let weekdayIndex = (calendar.component(.weekday, from: date) - 1) % 7
                let name = dayNames[max(0, min(weekdayIndex, 6))]
                let isToday = calendar.isDateInToday(date)
                
                generatedDays.append(
                    DayItem(
                        dayOfWeek: name,
                        dayNumber: dayNumber,
                        date: date,
                        isSelected: isToday
                    )
                )
            }
        }
        
        self.days = generatedDays
        
        if let matchedIndex = days.firstIndex(where: { $0.isSelected }) {
            selectedDayIndex = matchedIndex
            updateDateDescription(for: days[matchedIndex].date)
        } else if let firstDay = days.first {
            selectedDayIndex = 0
            updateDateDescription(for: firstDay.date)
        }
    }
    
    func selectDay(_ day: DayItem) {
        guard Calendar.current.isDateInToday(day.date) else { return }
        
        for index in days.indices {
            let isMatch = (days[index].id == day.id)
            days[index].isSelected = isMatch
            if isMatch {
                selectedDayIndex = index
            }
        }
        updateDateDescription(for: day.date)
    }
    
    private func updateDateDescription(for date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE, d MMMM"
        selectedDateDescription = formatter.string(from: date)
    }
    
    func logAsLearned() {
            guard isTodaySelected else { return }
            
            // إذا كان اليوم مجمداً، نلغي الفريز ونرجع رصيده
            if currentSelectedDay.isFreezed {
                days[selectedDayIndex].isFreezed = false
                usedFreezes = max(0, usedFreezes - 1)
                freezedDaysCount = max(0, freezedDaysCount - 1)
            }
            
            let currentState = days[selectedDayIndex].isLearned
            days[selectedDayIndex].isLearned.toggle()
            
            if !currentState {
                // عند تفعيل التعلم: نقوم بتثبيت النشاط وتجديد المهلة
                learnedDaysCount += 1
                resetTimerAndActivity()
            } else {
                // عند إلغاء التحديد (الرجوع للوضع الفارغ): نقص العداد فقط دون تصفير وقت البداية الأصلي!
                learnedDaysCount = max(0, learnedDaysCount - 1)
                saveTodayState()
            }
        }
        
        func freezeDay() {
            guard isTodaySelected else { return }
            
            if currentSelectedDay.isLearned {
                days[selectedDayIndex].isLearned = false
                learnedDaysCount = max(0, learnedDaysCount - 1)
            }
            
            let currentState = days[selectedDayIndex].isFreezed
            
            if !currentState {
                // عند تفعيل الفريز: نقوم بتثبيت النشاط وتجديد المهلة
                guard usedFreezes < maxFreezes else { return }
                days[selectedDayIndex].isFreezed = true
                usedFreezes += 1
                freezedDaysCount += 1
                resetTimerAndActivity()
            } else {
                // عند إلغاء التحديد (الرجوع للوضع الفارغ): نقص العدادات فقط دون تصفير وقت البداية الأصلي!
                days[selectedDayIndex].isFreezed = false
                usedFreezes = max(0, usedFreezes - 1)
                freezedDaysCount = max(0, freezedDaysCount - 1)
                saveTodayState()
            }
        }
    func checkTimeElapsed() {
        let calendar = Calendar.current
        let minutesPassed = calendar.dateComponents([.minute], from: lastActivityDate, to: Date()).minute ?? 0
        let isCurrentDayActive = currentSelectedDay.isLearned || currentSelectedDay.isFreezed
        
        if minutesPassed >= 1 && !hasFailedGoal && !isCurrentDayActive {
            hasFailedGoal = true
        }
    }
    
    private func resetTimerAndActivity() {
        hasFailedGoal = false
        lastActivityDate = Date()
        UserDefaults.standard.set(lastActivityDate, forKey: "appStartDate")
        saveTodayState()
    }

    func resetForNewGoal() {
        hasFailedGoal = false
        learnedDaysCount = 0
        freezedDaysCount = 0
        usedFreezes = 0
        for index in days.indices {
            days[index].isLearned = false
            days[index].isFreezed = false
        }
        lastActivityDate = Date()
        UserDefaults.standard.set(lastActivityDate, forKey: "appStartDate")
        saveTodayState()
    }
    
    // MARK: - Freeze Button Styling Helpers
    var freezeButtonText: String {
        isDayFreezed ? "Freezed for a day" : "Freeze for a day"
    }

    var freezeButtonTextColor: Color {
        if isDayFreezed { return .gray }
        else if canFreeze { return .white }
        else { return Color.gray.opacity(0.6) }
    }

    var freezeButtonBackgroundColor: Color {
        if isDayFreezed { return Color.white.opacity(0.06) }
        else if canFreeze { return .cyan }
        else { return Color.white.opacity(0.06) }
    }

    var freezeButtonStrokeColor: Color {
        if isDayFreezed { return Color.white.opacity(0.15) }
        else if canFreeze { return .clear }
        else { return Color.white.opacity(0.08) }
    }
}
