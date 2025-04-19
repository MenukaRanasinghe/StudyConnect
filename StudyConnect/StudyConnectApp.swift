//
//  StudyConnectApp.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-03-31.
//

import SwiftUI

@main
struct StudyConnectApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Splash()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
