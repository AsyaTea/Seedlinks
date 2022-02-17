//
//  SeedlinksApp.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI
import Firebase



//prova Fra
@main
struct SeedlinksApp: App {
  
    init() {
        FirebaseApp.configure()
    }
        
    var body: some Scene {
        WindowGroup {
            
//            RegisterView()
            Tab()

        }
    }
}



