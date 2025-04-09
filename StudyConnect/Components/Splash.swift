//
//  Splash.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-08.
//

import SwiftUI

struct Splash: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .scaleEffect(animate ? 1 : 0.5)
                    .opacity(animate ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.2)) {
                            animate = true
                        }
                    }
            }
        }
    }
}

#Preview {
    Splash()
}
