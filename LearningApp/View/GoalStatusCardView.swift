import SwiftUI

struct GoalStatusCardView: View {
    let model: GoalStatusModel
    var onButtonTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: model.iconName)
                .font(.system(size: 40,weight: .regular))
                .foregroundColor(.orange)
                .padding(16)
                .frame(width: 50,height: 51)
                //   .background(Color.orange.opacity(0.15))
           //     .clipShape(Circle())
           
            
            VStack(spacing: 6) {
                Text(model.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(model.subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom,64)
            }
            
            Button(action: {
                onButtonTapped()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil.line")
                    Text(model.buttonTitle)
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
               
                .frame(width:140,height: 50)
                .background(Color.orange)
                .cornerRadius(26)
            }
            .padding(.horizontal, 20)
        }
       // .padding(.vertical, 12)
       //.cornerRadius(24)
       
       // .padding(.horizontal, 20)
    }
}
#Preview {
    GoalStatusCardView(model:.completed, // أو .failed لتجربة الحالتين
                       onButtonTapped: {
        print("Button tapped in preview")
    })
}
