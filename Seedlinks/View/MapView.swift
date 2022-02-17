//
//  ContentView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var firebaseManager = DatabaseManager()
    
    @State var clickedMessage: Message?
    
    @State var didTapOnPin: Bool = false
    
    func getRadius(bLat : Double, bLong: Double) -> Double {
        let myCoord = CLLocation(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0.0,longitude: locationManager.lastLocation?.coordinate.longitude ?? 0.0)
        let genericCoord = CLLocation(latitude: bLat, longitude: bLong)
        let distanceInMeters = myCoord.distance(from: genericCoord)
        print("DISTANZA IN METRI" ,distanceInMeters)
        return distanceInMeters
    }
    
    init() {
        locationManager.requestAuthorization()
        firebaseManager.getData()
    }
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: firebaseManager.list, annotationContent: { message in
                MapAnnotation(
                    coordinate: message.coordinate,
                    content: {
                        //Se la distanza tra me e il bottone singolo è < 2km -> abilitalo
                        Button {
                            didTapOnPin = true
                            clickedMessage = message
                        } label: {
                            Circle().foregroundColor(.brown).frame(width: 10, height: 10).padding(20)
                        }
                        .disabled(getRadius(bLat: message.coordinate.latitude , bLong: message.coordinate.longitude ) >= 300.0)
                        .sheet(isPresented: $didTapOnPin) {
                            didTapOnPin = false
                        } content: {
                            VStack{
                                if let clickedMessage = clickedMessage {
                                    Text(clickedMessage.message)
                                    Text(clickedMessage.author)
                                }else{
                                    //Loader
                                    Text("Caricamento...")
                                }
                            }
                        }
                    }
                )
            }).ignoresSafeArea()
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    ButtonPosition()
                        .onTapGesture {
                            locationManager.getRegion()
                        }
                }
                .padding(25)
            .onAppear{
                //Prende la posizione corrente appena apri l'app (se hai dato il consenso)
                locationManager.getRegion()
            }
            }
        }
    }
}

struct ButtonPosition : View {
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.gray)
                .opacity(0.2)
                .frame(width: 50, height: 50)
                .blur(radius: 10)
            Circle()
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
        Image("locationIcon")
                .resizable()
                .frame(width: 40, height: 40)
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
