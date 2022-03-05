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
    
    @ObservedObject var locationManager : LocationManager
    @ObservedObject var dbManager : DatabaseManager
    @ObservedObject var userSession : UserSession
    
    @State var clickedMessage: Message?
    @State var messageID : String = ""
    
    @State var prova : Bool = false
    
    
    func getRadius(bLat : Double, bLong: Double) -> Double {
        let myCoord = CLLocation(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0.0,longitude: locationManager.lastLocation?.coordinate.longitude ?? 0.0)
        let genericCoord = CLLocation(latitude: bLat, longitude: bLong)
        let distanceInMeters = myCoord.distance(from: genericCoord)
        //         print("DISTANZA IN METRI MAPPA" ,distanceInMeters)
        return distanceInMeters
    }
    
    
    
    var buttonColor: Color {
        return prova ? .green : .gray
    }
    
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: dbManager.list, annotationContent: { message in
                MapAnnotation(
                    coordinate: message.coordinate,
                    content: {
                        
                        VStack{
                         if  clickedMessage == message {
                        
                             PlaceAnnotationView(locationManager: locationManager, dbManager: dbManager, title: clickedMessage?.message ?? "default", name: clickedMessage?.author ?? "default", messageID: message.id)
                        
                    }
                            else {
                                PlaceAnnotationViewHidden(locationManager: locationManager, dbManager: dbManager, title: "", name: "", messageID: "")
                                //
//
                    }
                        
                        
//
                        
                        
                        //Se la distanza tra me e il bottone singolo è < 2km -> abilitalo
                        Button {
                            
                            dbManager.getMessageIDquery(messageID: message.id)
                            locationManager.didTapOnPin.toggle()
                            clickedMessage = dbManager.message
                            
                        } label: {
                            
                          
                            
                            
                            ZStack{
                                if getRadius(bLat: message.coordinate.latitude , bLong: message.coordinate.longitude ) >= 300.0
//                                    && getRadius(bLat: message.coordinate.latitude , bLong: message.coordinate.longitude ) < 800
                                {
                                    Circle()
                                        .foregroundColor(.gray)
                                        .frame(width: 25, height: 25)
                                    //    .padding(20)
                                    Image("sprout")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                }
//                                else if getRadius(bLat: message.coordinate.latitude , bLong: message.coordinate.longitude ) >= 800.0 && getRadius(bLat: message.coordinate.latitude , bLong: message.coordinate.longitude ) < 2000 {
//                                    Circle()
//                                        .foregroundColor(.teal)
//                                        .frame(width: 25, height: 25)
//                                    //    .padding(20)
//                                    Image("sprout")
//                                        .resizable()
//                                        .frame(width: 15, height: 15)
//                                }
//                                else if getRadius(bLat: message.coordinate.latitude , bLong: message.coordinate.longitude ) >= 2000.0 {
//                                    Circle()
//                                        .foregroundColor(.gray)
//                                        .frame(width: 25, height: 25)
//                                    //    .padding(20)
//                                    Image("sprout")
//                                        .resizable()
//                                        .frame(width: 15, height: 15)
//                                }
                                else{
                                    Circle()
                                        .foregroundColor(.green)
                                        .frame(width: 25, height: 25)
                                    //    .padding(20)
                                    Image("sprout")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                }
                            }
                        }
                        }
                        
                        .disabled(getRadius(bLat: message.coordinate.latitude, bLong: message.coordinate.longitude ) >= 300.0 )
                        
                    }
                )
            }).ignoresSafeArea()
                .accentColor(.blue)
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
                    //  locationManager.getRegion()
                    locationManager.requestAuthorization()
                    dbManager.getData()
                    
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
                .frame(width: 45, height: 40)
            
        }
    }
}
struct PlaceAnnotationView: View {
    @ObservedObject var locationManager : LocationManager
    @ObservedObject var dbManager : DatabaseManager
    let title: String
    let name: String
    let messageID : String
    @State var textHeight: CGFloat = 0
    
    
    //    let id :  String
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius:10)
                .foregroundColor(Color("TabBar"))
                .frame(width: UIScreen.main.bounds.width * 0.81, height: textHeight+65,alignment: .leading)
            VStack{
                Text(name)
                    .fontWeight(.bold)
                Text(title)
                    .font(.callout)
                    .padding(3)
                // .background(Color("TabBar"))
                    .cornerRadius(10)
                    .overlay(
                        GeometryReader { proxy in
                            Color
                                .clear
                                .preference(key: ContentLengthPreference.self,
                                            value: proxy.size.height) // <-- this
                        }
                    )
            }
            
            
        }
        .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
            DispatchQueue.main.async {
                self.textHeight = value
            }
        }
        .opacity(locationManager.didTapOnPin ? 1 : 0)
        .frame(width: 300, height: 80)
        .contextMenu{
            Button(role: .destructive ,action: {
                print("reporting message")
                dbManager.message.reportCount += 1
                dbManager.reportedMessage(messageID: messageID)
            }, label:
                    {
                HStack{
                    Text("Report")
                    Image(systemName: "exclamationmark.bubble.fill")
                }
            })
        }
    }
}

struct PlaceAnnotationViewHidden: View {
        @ObservedObject var locationManager : LocationManager
        @ObservedObject var dbManager : DatabaseManager
    let title: String
    let name: String
        let messageID : String
    @State var textHeight: CGFloat = 0


    //    let id :  String
    var body: some View {

                ZStack{
        //            RoundedRectangle(cornerRadius:10)
        //                .foregroundColor(Color("TabBar"))
//                        .frame(width: UIScreen.main.bounds.width * 0.81, height: textHeight+65,alignment: .leading)
        VStack{
            Text("")
                .fontWeight(.bold)
            Text("")
                .font(.callout)
//                .padding(3)
            // .background(Color("TabBar"))
            //                    .cornerRadius(10)
//                                .overlay(
//                                    GeometryReader { proxy in
//                                        Color
//                                            .clear
//                                            .preference(key: ContentLengthPreference.self,
//                                                        value: proxy.size.height) // <-- this
//                                    }
//                                )
            //            }


        }
        .padding()
                    //        .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
        //            DispatchQueue.main.async {
        //                self.textHeight = value
        //            }
        //        }
        //        .opacity(locationManager.didTapOnPin ? 1 : 0)
        //        .frame(width: 300, height: 80)
        //        .contextMenu{
        //            Button(role: .destructive ,action: {
        //                print("reporting message")
        //                dbManager.message.reportCount += 1
        //                dbManager.reportedMessage(messageID: messageID)
        //            }, label:
        //                    {
        //                HStack{
        //                    Text("Report")
        //                    Image(systemName: "exclamationmark.bubble.fill")
        //                }
        //            })
                }
    }
}

struct CustomButton: Identifiable{
    let id: String
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
