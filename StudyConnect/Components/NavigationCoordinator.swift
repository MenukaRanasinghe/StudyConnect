//
//  NavigationCoordinator.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-25.
//

import SwiftUI

class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func resetToRoot() {
        path = NavigationPath()
    }
}
