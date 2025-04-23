//
//  FindView.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-19.
//

import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseCore
import CoreLocation

struct FindView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var userPins: [UserPin] = []

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                annotationItems: userPins) { user in
                MapAnnotation(coordinate: user.coordinate) {
                    VStack(spacing: 2) {
                        Text(user.name)
                            .font(.caption)
                            .bold()
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)

                        Image(systemName: "mappin.and.ellipse")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
            }
            .ignoresSafeArea()

            VStack(alignment: .leading) {
                HStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)

                    Text("StudyConnect")
                        .font(.headline)

                    Spacer()

                    Image(systemName: "bell.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                TextField("Find Study Partner", text: .constant(""))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)

                Spacer()
            }
            .padding(.top, 50)
        }
        .onAppear {
            locationManager.requestPermission()
            fetchUserPins()
        }
    }

    func fetchUserPins() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }

            var pins: [UserPin] = []

            for document in snapshot?.documents ?? [] {
                let data = document.data()
                let name = data["name"] as? String ?? "Unknown"

                if let geoPoint = data["location"] as? GeoPoint {
                    let coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                    pins.append(UserPin(name: name, coordinate: coordinate))
                }
            }

            DispatchQueue.main.async {
                self.userPins = pins
            }
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var manager = CLLocationManager()

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.8500, longitude: 79.9500),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.region.center = location.coordinate
            }
        }
    }
}

struct UserPin: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView()
    }
}
