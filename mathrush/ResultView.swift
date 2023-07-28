//
//  ResultView.swift
//  mathrush
//
//  Created by Neilson Soeratman on 17/05/23.
//

import SwiftUI

struct ResultView: View {
    let score: Int
    @State private var goToMenu = false
    var body: some View {
        NavigationView {
            ZStack{
                NavigationLink(destination: MenuView(), isActive: $goToMenu, label: {})
                SceneKitView()
                    .ignoresSafeArea()
                ZStack{ }
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(.white.opacity(0.2))
                    .backgroundStyle(.ultraThinMaterial)
                
                VStack{
                    VStack{
                        Text("GOOD JOB!")
                            .font(.custom("Sigmar", size: 50))
                            .foregroundColor(Color(#colorLiteral(red: 0.1239937916, green: 0.1239937916, blue: 0.1239937916, alpha: 1)))
                            .shadow(color: .black, radius: 0.5)
                        Text("Your score is \(score)")
                            .font(.custom("Sigmar", size: 20))
                            .foregroundColor(Color(#colorLiteral(red: 0.1239937916, green: 0.1239937916, blue: 0.1239937916, alpha: 1)))
                            .shadow(color: .black, radius: 0.5)
                        Button("Go to Menu"){
                            goToMenu = true
                        }
                        .buttonStyle(BorderedButton(rotationDeg: -2.1, width: 220, height: 60, fontSize: 20.0, cornerRadius: 10.0))
                        .padding(.top, 70)
                    }
                    .padding(.top, (UIScreen.main.bounds.height / 6))
                    .animation(Animation.interpolatingSpring(stiffness: 120, damping: 10))
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(score: 0)
    }
}
