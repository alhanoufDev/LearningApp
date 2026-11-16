import SwiftUI

struct EditGoalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var goalText: String = "Swift"
    @State private var selectedDuration: String = "Week"
    @State private var showAlert: Bool = false
    
    var onUpdateGoal: () -> Void // دالة لتصفير الستريك والعودة للشاشة الرئيسية
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Learning Goal")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // زر الصح (✓) للحفظ وتنبيه المستخدم
                    Button(action: {
                        showAlert = true
                    }) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.orange)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("I want to learn")
                            .font(.system(size: 16,weight: .bold))
                            .padding(.bottom,5)
                        
                        TextField("Swift", text: $goalText)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("I want to learn it in a")
                            .font(.system(size: 16,weight: .bold))
                            .padding(.bottom,12)
                        
                        HStack(spacing: 12) {
                            ForEach(["Week", "Month", "Year"], id: \.self) { duration in
                                let isSelected = selectedDuration == duration
                                Button {
                                    selectedDuration = duration
                                } label: {
                                    Text(duration)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(isSelected ? .white : .gray)
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 24)
                                        .glassEffect(
                                            isSelected
                                            ? .regular.tint(.orange).interactive()
                                            : .regular.interactive(),
                                            in: .capsule
                                        )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
            }
        }
        // تنبيه الـ Alert تماماً كما في الصورة الثالثة
        .alert("Update goal", isPresented: $showAlert) {
            Button("Dismiss", role: .cancel) { }
            Button("Update", role: .destructive) {
                // حفظ الهدف الجديد وتصفير الستريك والرجوع
                UserDefaults.standard.set(goalText, forKey: "savedLearningGoal")
                UserDefaults.standard.set(selectedDuration, forKey: "savedDuration")
                onUpdateGoal()
                dismiss()
            }
            
        } message: {
            Text("If you update now, your streak will start over.")
                
        }
    }
}

#Preview {
    EditGoalView {
    }
}
