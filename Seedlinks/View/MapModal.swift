//
//  MapModal.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 28/02/22.
//

import SwiftUI
import MapKit

struct MapModal: View {
    
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        Map(coordinateRegion: $locationManager.region,  showsUserLocation: true)
            .onAppear{
                locationManager.getRegion()
            }
    }
}

//struct MapModal_Previews: PreviewProvider {
//    static var previews: some View {
//        MapModal()
//    }
//}
