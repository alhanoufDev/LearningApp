//
//  StartLearning.swift
//  LearningApp
//
//  Created by Alhanouf Sultan on 30/05/1448 AH.
//

import SwiftUI

struct StartLearning: View {
    @State var learn :String=""
    @State var selectedDuration: String = ""
    let options = ["Week","Month","Year"]
    var body: some View {
        VStack{
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width:67, height: 43)
                .foregroundColor(.orange)
                .padding(.bottom,80)
            
            VStack(alignment: .leading){
                
                Text("Hello **Learner**")
                    .padding(.bottom, 4)
                    .font(.system(size: 34))
                   // .frame(width: 237,height: 48)
                
                Text("This app will help you learn everyday!")
                    .padding(.bottom, 37)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                Text("I want to learn")
                TextField("Swift..", text: $learn)
                    .padding(.bottom, 30)
                    .font(.system(size: 16))
                Text("I want to learn it in a ")
                    .padding(.bottom,12)
                
                HStack(spacing: 12 ) {
                    
                    Button("Week") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }
                   
                    Button("Month") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }
                   
                    Button("Year") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                        
                    }
                   
              
                
                }
                .buttonStyle(GlassButtonStyle())
              //  .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .padding(.bottom,228)
              
               
             
                
                
            }
            .padding(.leading,17)
            
            Button {
                // الأكشن هنا
            } label: {
                Text("Start Learning")
                 
            }
            
            .frame(width: 151, height: 46)
            .background(Color.orange)                          .foregroundColor(.white)
            .cornerRadius(30)
            .padding(.bottom, 12)
Text("You can edit your desire later")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        
            
            
        }
    }
}

#Preview {
    StartLearning()
}

