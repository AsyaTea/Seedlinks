//
//  Onboarding.swift
//  Seedlinks
//
//  Created by Francesco Puzone on 02/03/22.
//

import Foundation
import SwiftUI


struct OnboardingView: View {
    let systemImageName: String
    let title: String
    let description: String
    @State var didSetup: Bool = false
    
    
    var body: some View {
        
        VStack(spacing: 20){
            Image (systemImageName)
                .resizable()
            // .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.80, height: UIScreen.main.bounds.height * 0.38, alignment: .center)
            VStack(alignment: .leading){
                Text(title)
                    .font(.largeTitle)
                    .padding()
                Text(description)
                    .font(.title2)
                    .padding()
                
            }
        }
        
    }
    
    
    //        }
    //        .background(Color.gray)
    //        .foregroundColor(.white)
    //        .ignoresSafeArea(.all, edges: .all)
    //    }
}

struct InfoList: View {
    @State var didSetup: Bool = false
    
    var body: some View{
        
        VStack(alignment: .center){
            Spacer(minLength: 60)
            Text("Welcome to Seedlinks!")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding()
            //                Seedlinks ti da il benvenuto
            
            Spacer(minLength: 60)
            HStack {
                VStack(alignment: .leading) {
                    Image(systemName: "map.fill")
                        .foregroundColor(.green)
                        .padding()
                        .frame(width: 50.0, height: 50.0)
                    
                    Spacer()
                    
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.green)
                        .padding()
                        .frame(width: 50.0, height: 50.0)
                    
                    Spacer()
                    
                    Image(systemName: "bubble.left.fill")
                        .foregroundColor(.green)
                        .padding()
                        .frame(width: 50.0, height: 50.0)
                }
                
                VStack(alignment: .leading){
                    Text("Explore the world")
                        .font(.headline.bold())
                    
                    Text("Navigate through the map and find the most popular places.")
                        .font(.subheadline)
                        .padding(.trailing)
                    //                  Guarda dove gli altri hanno lasciato un loro segno
                    Spacer()
                    
                    
                    Text("Join the community")
                        .font(.headline.bold())
                    
                    Text("Stay connected and read messages left by others.")
                        .font(.subheadline)
                        .padding(.trailing)
                    //                  Rimani sempre connesso con gli altri utenti, lascia un seme per condividere i tuoi pensieri
                    Spacer()
                    
                    
                    Text("Plant your thoughts")
                        .font(.headline.bold())
                    
                    Text("Write something and share your seed with the world!")
                        .font(.subheadline)
                        .padding(.trailing)
                    //                  pianta un tuo pensiero e condividilo con gli altri
                    
                }
            }
            Spacer(minLength: 60)
            
            if didSetup == true {
                
                OnboardingButton()
            }
            
        }
    }
    
}
struct OnboardingButton: View {
    
    // #1
    @AppStorage("needsAppOnboarding") var needsAppOnboarding: Bool = true
    
    var body: some View {
        GeometryReader { proxy in
            HStack {
                VStack{
                    Text("Allow the app to access your position to explore the full functionalities.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button(action: {
                        
                        // #2
                        needsAppOnboarding = false
                    }) {
                        Text("Start exploring!")
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                    }
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    .frame(minWidth: 0, maxWidth: proxy.size.width-40)
                }
                .padding()
            }
            .frame(width: proxy.size.width, height: proxy.size.height/1.5)
        }
    }
}
