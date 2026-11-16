import SwiftUI

@main struct MyApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ActivityView()
                        } else {
                            StartLearning() // شاشة البداية تظهر للمستخدم الجديد فقط
                        }
           
            
            
        }
    }
}

