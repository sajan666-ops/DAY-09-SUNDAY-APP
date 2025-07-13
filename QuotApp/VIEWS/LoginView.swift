//
//  LoginView.swift
//  QuotApp
//
//  Created by SAJAN on 13/07/25.
//

import SwiftUI

struct LoginView: View {
    // Persist the user name
    @AppStorage("username") private var username: String = ""

    // Local state
    @State private var tempName: String = ""
    @State private var goNext = false         // triggers navigation

    var body: some View {
        VStack(spacing: 30) {
            // App title
            Text("Quote App")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Name entry
            TextField("Enter your name", text: $tempName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            // Guest login
            Button("Continue as Guest") {
                username = "Guest"
                goNext = true
            }
            .buttonStyle(.bordered)

            // Login with typed name
            Button("Login with Name") {
                let name = tempName
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                username = name.isEmpty ? "Guest" : name
                goNext = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Login")
        // ✅ Modern navigation (iOS 16 +)
        .navigationDestination(isPresented: $goNext) {
            SplashView()
        }
    }
}

#Preview {
    NavigationStack {      // Preview inside a NavigationStack
        LoginView()
    }
}
