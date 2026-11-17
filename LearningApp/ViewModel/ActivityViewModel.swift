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
    
    // جلب المدة المختارة مباشرة من الـ UserDefaults (تكون "Week" أو "Month" أو "Year")
    var selectedDurationType: String {
        UserDefaults.standard.string(forKey: "savedDuration") ?? "Week"
    }

    // تحديد الحد الأقصى للفريزات ديناميكياً بناءً على اختيار المستخدم (أسبوع = 2، شهر = 8، سنة = 96)
    var maxFreezes: Int {
        switch selectedDurationType {
        case "Month":
            return 8
        case "Year":
            return 96
        default: // "Week" أو أي قيمة افتراضية
            return 2
        }
    }
    
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
        let isNewDay = lastResetCheckIsNewDay()
        if isNewDay {
            return usedFreezes < maxFreezes && !isDayLearned
        }
        return (usedFreezes < maxFreezes || currentSelectedDay.isFreezed) && !isDayLearned
    }
    
    init() {
        setupWeekDays()
        loadTodayState()
        checkTimeElapsed()
    }
    
    private func lastResetCheckIsNewDay() -> Bool {
        if let savedDate = UserDefaults.standard.object(forKey: "savedDayDate") as? Date {
            return !Calendar.current.isDateInToday(savedDate)
        }
        return true
    }
    
    private func saveTodayState() {
        let today = currentSelectedDay.date
        UserDefaults.standard.set(currentSelectedDay.isLearned, forKey: "isTodayLearned")
        UserDefaults.standard.set(currentSelectedDay.isFreezed, forKey: "isTodayFreezed")
        UserDefaults.standard.set(today, forKey: "savedDayDate")
    }
    
    private func loadTodayState() {
        learnedDaysCount = UserDefaults.standard.integer(forKey: "learnedDaysCount")
        freezedDaysCount = UserDefaults.standard.integer(forKey: "freezedDaysCount")
        usedFreezes = UserDefaults.standard.integer(forKey: "usedFreezes")
        
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
        
        if currentSelectedDay.isFreezed {
            days[selectedDayIndex].isFreezed = false
            usedFreezes = max(0, usedFreezes - 1)
            freezedDaysCount = max(0, freezedDaysCount - 1)
        }
        
        let currentState = days[selectedDayIndex].isLearned
        days[selectedDayIndex].isLearned.toggle()
        
        if !currentState {
            learnedDaysCount += 1
            resetTimerAndActivity()
        } else {
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
            guard canFreeze else { return }
            days[selectedDayIndex].isFreezed = true
            usedFreezes += 1
            freezedDaysCount += 1
            resetTimerAndActivity()
        } else {
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
    
    var hasCompletedGoal: Bool {
        // تحديد العدد المستهدف بناءً على المدة التي اختارها المستخدم
        let targetDays: Int
        switch selectedDurationType {
        case "Month":
            targetDays = 30 // أو عدد الأيام المستهدفة للشهر
        case "Year":
            targetDays = 365 // أو عدد الأيام المستهدفة للسنة
        default:
            targetDays = 7 // Week (الافتراضي 7 أيام)
        }
        
        // إذا وصل المستخدم لعدد الأيام المتعلمة المطلوبة حسب اختياره، يعتبر الهدف مكتمل
        return learnedDaysCount >= targetDays
    }
}
