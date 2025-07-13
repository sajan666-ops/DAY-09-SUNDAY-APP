//
//  QuoteMainView.swift
//  QuotApp
//
//  Created by SAJAN on 13/07/25.
//

import SwiftUI

struct QuoteMainView: View {
    @StateObject private var fetcher = QuoteFetcher()
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showCopiedAlert = false

    var body: some View {
        VStack(spacing: 28) {
            
            // 🔘 Dark Mode Toggle
            Toggle("Dark Mode", isOn: $isDarkMode)
                .toggleStyle(.switch)
                .padding(.horizontal)
                .onChange(of: isDarkMode) {
                    UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .first?
                        .windows
                        .first?
                        .overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                }

            Spacer()

            // 📝 Quote Display
            Group {
                if let q = fetcher.currentQuote {
                    Text("“\(q.content)”\n— \(q.author)")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ProgressView("Loading quotes…")
                }
            }
            .animation(.easeInOut, value: fetcher.currentIndex)

            Spacer()

            // ⚡️ Action Buttons
            HStack(spacing: 40) {
                Button("UNDO") {
                    fetcher.undo()
                }
                .buttonStyle(.bordered)

                Button("COPY") {
                    if let q = fetcher.currentQuote {
                        UIPasteboard.general.string = q.content
                        showCopiedAlert = true
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("NEXT") {
                    fetcher.next()
                }
                .buttonStyle(.bordered)
            }
            .font(.headline)

            // 🚨 Fallback/Error Message
            if let msg = fetcher.errorMessage {
                Text(msg)
                    .font(.footnote)
                    .foregroundColor(.orange)
                    .padding(.top, 8)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .alert("Copied to clipboard!", isPresented: $showCopiedAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    QuoteMainView()
}
