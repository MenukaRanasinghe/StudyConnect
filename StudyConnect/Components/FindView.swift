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
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718), 
        span: MKCoordinateSpan(latitudeDelta: 2.5, longitudeDelta: 2.5)
    )

    var body: some View {
        VStack {
            Text("Find")
                .font(.largeTitle)
                .padding()

            Map(coordinateRegion: $region)
                .frame(height: 400)
                .cornerRadius(10)
                .padding()
        }
    }
}

struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView()
    }
}
