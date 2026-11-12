import Foundation

@Observable
final class ActivityViewModel {
    var selectedDateDescription: String = ""
    var days: [DayItem] = []
    
    var learnedDaysCount: Int = 4
    var freezedDaysCount: Int = 0
    var usedFreezes: Int = 0
    let maxFreezes: Int = 2
    
    var selectedDayIndex: Int = 0
    
    // MARK: - Computed Properties
    var currentSelectedDay: DayItem {
        guard days.indices.contains(selectedDayIndex) else {
            return days.first ?? DayItem(dayOfWeek: "S", dayNumber: 1, date: Date())
        }
        return days[selectedDayIndex]
    }
    
    var isDayLearned: Bool {
        currentSelectedDay.isLearned
    }
    
    var isDayFreezed: Bool {
        currentSelectedDay.isFreezed
    }
    
    var canFreeze: Bool {
        !isDayLearned && !isDayFreezed && usedFreezes < maxFreezes
    }
    
    // MARK: - Initializer
    init() {
        setupWeekDays()
    }
    
    // MARK: - Actions
    func setupWeekDays() {
        let calendar = Calendar.current
        let today = Date()
        
        // الحصول على بداية الأسبوع الحالي (مثلاً الأحد أو السبت حسب لغة الجهاز)
        // سنقوم هنا بتوليد 7 أيام ابتداءً من تاريخ اليوم أو الأسبوع الحالي
        let dayNames = ["S", "M", "T", "W", "T", "F", "S"]
        
        // توليد الأيام الـ 7 ابتداءً من اليوم أو الأيام القريبة
        var generatedDays: [DayItem] = []
        
        for i in 0..<7 {
            // إضافة الأيام تباعاً (اليوم الحالي وما يسبقه أو يعقبه)
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
                        isSelected: isToday // جعل اليوم الحالي هو المحدد افتراضياً
                    )
                )
            }
        }
        
        self.days = generatedDays
        
        // تحديد اليوم المحدد افتراضياً (إما اليوم الحالي أو أول يوم)
        if let matchedIndex = days.firstIndex(where: { $0.isSelected }) {
            selectedDayIndex = matchedIndex
            updateDateDescription(for: days[matchedIndex].date)
        } else if let firstDay = days.first {
            selectedDayIndex = 0
            updateDateDescription(for: firstDay.date)
        }
    }
    
    func selectDay(_ day: DayItem) {
        for index in days.indices {
            let isMatch = (days[index].id == day.id)
            days[index].isSelected = isMatch
            if isMatch {
                selectedDayIndex = index
            }
        }
        
        // تحديث التاريخ العلوي فوراً بناءً على تاريخ اليوم المنقور
        updateDateDescription(for: day.date)
    }
    
    private func updateDateDescription(for date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US") // لضمان ظهور اسم اليوم والشهر بالإنجليزية (مثل Thursday, 24 October)
        formatter.dateFormat = "EEEE, d MMMM"
        selectedDateDescription = formatter.string(from: date)
    }
    
    func logAsLearned() {
        guard !isDayFreezed else { return }
        
        let currentState = days[selectedDayIndex].isLearned
        days[selectedDayIndex].isLearned.toggle()
        
        if !currentState {
            learnedDaysCount += 1
        } else {
            learnedDaysCount -= 1
        }
    }
    
    func freezeDay() {
        guard canFreeze else { return }
        
        days[selectedDayIndex].isFreezed = true
        usedFreezes += 1
        freezedDaysCount += 1
    }
}
