import SwiftUI

struct ActivitiesCalendarView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ActivitiesCalendarViewModel()
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 32) {
                    ForEach(viewModel.generateDynamicMonths(), id: \.id) { monthInfo in
                        MonthGridView(viewModel: viewModel, title: monthInfo.title, year: monthInfo.year, month: monthInfo.month)
                            .id(monthInfo.id)
                        
                        Divider().background(Color.gray.opacity(0.2))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
         
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            
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
}

// مكون عرض كل شهر
struct MonthGridView: View {
    let viewModel: ActivitiesCalendarViewModel
    let title: String
    let year: Int
    let month: Int
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: columns, spacing: 8) {
                // جلب الداتا (أسماء الأيام) من الـ ViewModel
                ForEach(viewModel.weekdays, id: \.self) { day in
                    Text(day).font(.system(size: 11, weight: .semibold)).foregroundColor(.gray)
                }
            }
            
            let cells = viewModel.generateCells(year: year, month: month)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(cells.indices, id: \.self) { index in
                    if let day = cells[index] {
                        let date = viewModel.getDate(day: day, month: month, year: year)
                        let isToday = Calendar.current.isDateInToday(date)
                        
                        let isLearned = viewModel.isDayLearned(for: date)
                        let isFreezed = viewModel.isDayFreezed(for: date)
                        
                        let textColor: Color = isFreezed ? .cyan : (isLearned ? .orange : (isToday ? .white : .white))
                        let bgColor: Color = isFreezed ? .cyan.opacity(0.2) : (isLearned ? .orange.opacity(0.2) : (isToday ? .orange : .clear))
                        let strokeColor: Color = isFreezed ? .cyan : (isLearned ? .orange : .clear)
                        
                        ZStack {
                            Text("\(day)")
                                .font(.system(size: 15, weight: (isToday || isLearned || isFreezed) ? .bold : .regular))
                                .frame(width: 36, height: 36)
                                .background(Circle().fill(bgColor))
                              
                        }
                    } else {
                        Color.clear.frame(width: 36, height: 36)
                    }
                }
            }
        }
    }
}
#Preview {
    NavigationStack {
        ActivitiesCalendarView().preferredColorScheme(.dark)
    }
}
