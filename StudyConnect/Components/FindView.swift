//
//  FindView.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-19.
//

import SwiftUI
import MapKit

struct FindView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.8500, longitude: 79.9500),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    let pins = [
        ColoredPin(coordinate: CLLocationCoordinate2D(latitude: 6.8505, longitude: 79.9485), color: .green),
        ColoredPin(coordinate: CLLocationCoordinate2D(latitude: 6.8510, longitude: 79.9490), color: .red),
        ColoredPin(coordinate: CLLocationCoordinate2D(latitude: 6.8490, longitude: 79.9510), color: .green),
        ColoredPin(coordinate: CLLocationCoordinate2D(latitude: 6.8520, longitude: 79.9500), color: .red)
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $region, annotationItems: pins) { pin in
                MapAnnotation(coordinate: pin.coordinate) {
                    Circle()
                        .fill(pin.color.opacity(0.6))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(pin.color, lineWidth: 2)
                        )
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
                        .foregroundColor(.black)

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
    }
}

struct ColoredPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let color: Color
}

struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView()
    }
}
