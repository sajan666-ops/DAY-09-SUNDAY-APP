//
//  QuotAppApp.swift
//  QuotApp
//
//  Created by SAJAN  on 13/07/25.
//

import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView() // this comes next
            }
        }
    }
}
