//
//  NavigationCoordinator.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-25.
//

import SwiftUI

class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    func push<T: Hashable>(_ value: T) {
        path.append(value)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

