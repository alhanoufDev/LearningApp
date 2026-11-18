import Foundation

@Observable
final class ActivitiesCalendarViewModel {
    
    // جلب أسماء الأيام من الـ Model
    var weekdays: [String] {
        ActivitiesCalendarModel.weekdays
    }
    
    // توليد الشهور الديناميكية
    func generateDynamicMonths() -> [(id: String, title: String, year: Int, month: Int)] {
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
    
    // جلب التاريخ لليوم المحدد
    func getDate(day: Int, month: Int, year: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }
    
    // توليد خلايا الأيام للشهر
    func generateCells(year: Int, month: Int) -> [Int?] {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        guard let firstDate = cal.date(from: DateComponents(year: year, month: month, day: 1)),
              let range = cal.range(of: .day, in: .month, for: firstDate) else { return [] }
        
        let spaces = cal.component(.weekday, from: firstDate) - 1
        var result: [Int?] = Array(repeating: nil, count: spaces)
        result.append(contentsOf: range.map { Optional($0) })
        return result
    }
    
    // التحقق من حالة اليوم (هل تم تعلمه؟)
    func isDayLearned(for date: Date) -> Bool {
        if Calendar.current.isDateInToday(date) {
            return UserDefaults.standard.bool(forKey: "isTodayLearned")
        }
        return false
    }
    
    // التحقق من حالة اليوم (هل تم تجميده؟)
    func isDayFreezed(for date: Date) -> Bool {
        if Calendar.current.isDateInToday(date) {
            return UserDefaults.standard.bool(forKey: "isTodayFreezed")
        }
        return false
    }
}
