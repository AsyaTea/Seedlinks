//
//  MapModal.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 28/02/22.
//

import SwiftUI
import MapKit

struct MapModal: View {
    
    @ObservedObject var locationManager : LocationManager
    @State private var userTrackingMode : MapUserTrackingMode = .follow
    
    
    var body: some View {
        Map(
            coordinateRegion: $locationManager.region,
            interactionModes: MapInteractionModes.zoom,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode
        )
        .onAppear{
            locationManager.requestAuthorization()
        }
        
    }
}

//struct MapModal_Previews: PreviewProvider {
//    static var previews: some View {
//        MapModal()
//    }
//}
