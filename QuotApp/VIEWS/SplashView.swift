//
//  SplashView.swift
//  QuotApp
//
//  Created by SAJAN  on 13/07/25.
//
import SwiftUI

struct SplashView: View {
    @AppStorage("username") private var username: String = ""
    @State private var isReady = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            Text("Hello, \(username)!\nHope you’re well ☀️")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
        }
        .onAppear {
            // Load for 2 seconds then move to quote screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isReady = true
            }
        }
        .navigationDestination(isPresented: $isReady) {
            QuoteMainView()
        }
    }
}

#Preview {
    NavigationStack {
        SplashView()
    }
}

