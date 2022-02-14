//
//  ContentView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        NavigationView{
            
            NavigationLink(destination: ListView()) {
                Text("Prova link")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
