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

    let pinColors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .teal, .indigo]

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                annotationItems: userPins) { user in
                MapAnnotation(coordinate: user.coordinate) {
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.2))
                                .frame(width: 44, height: 44)
                                .shadow(color: user.color.opacity(0.5), radius: 8, x: 0, y: 4)
                            Image(systemName: "mappin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(user.color)
                        }
                        .offset(y: -10)
                        Text(user.name)
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(6)
                            .shadow(radius: 1)
                            .offset(y: -4)
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
            var colorIndex = 0
            let group = DispatchGroup()

            for document in snapshot?.documents ?? [] {
                let data = document.data()
                let name = data["name"] as? String ?? "Unknown"
                let locationString = data["location"] as? String ?? ""

                group.enter()
                geocodeLocation(locationString) { coordinate in
                    if let coordinate = coordinate {
                        let color = pinColors[colorIndex % pinColors.count]
                        pins.append(UserPin(name: name, coordinate: coordinate, color: color))
                        colorIndex += 1
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.userPins = pins
            }
        }
    }

    func geocodeLocation(_ location: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { placemarks, error in
            if let coordinate = placemarks?.first?.location?.coordinate {
                completion(coordinate)
            } else {
                print("Geocoding failed for \(location): \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
}

struct UserPin: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let color: Color
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

struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView()
    }
}
