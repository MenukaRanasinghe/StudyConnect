//
//  Button.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-09.
//

import SwiftUI

struct BannerView: View {
    var content: AnyView

    var body: some View {
        VStack {
            content
                .padding()
                .frame(maxWidth: .infinity) 
                .background(Color("#4B7BEC"))
                .cornerRadius(12)
                .padding([.leading, .trailing, .top], 40)
                .frame(height: 120)
                .overlay(
                    content
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


