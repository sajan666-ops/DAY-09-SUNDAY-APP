import Foundation
import SwiftUI

final class QuoteFetcher: ObservableObject {
    @Published private(set) var quotes: [AppQuote] = []
    @Published var currentIndex = 0
    @Published var errorMessage: String?

    private let apiURL = URL(string: "https://api.quotable.io/quotes/random")!
    private let localFile = "quotes" // quotes.json in bundle

    init() {
        Task {
            await loadQuotes()
        }
    }

    var currentQuote: AppQuote? {
        guard !quotes.isEmpty else { return nil }
        return quotes[currentIndex]
    }

    func next() {
        Task {
            await loadQuotes()
        }
    }

    func undo() {
        // No undo for random quotes, optional: re-add stack if needed
        currentIndex = 0
    }

    private func loadQuotes() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: apiURL)
            print("🌐 Got \(data.count) bytes from API")

            let decoded = try JSONDecoder().decode(AppQuote.self, from: data)

            await MainActor.run {
                self.quotes = [decoded]
                print("✅ Successfully decoded quote from API")
            }
        } catch {
            print("⚠️ API failed: \(error.localizedDescription)")

            await MainActor.run {
                self.loadLocalQuotes()
                self.errorMessage = "Using offline quotes. Check your internet if you expected fresh ones."
            }
        }
    }

    private func loadLocalQuotes() {
        guard let url = Bundle.main.url(forResource: localFile, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([AppQuote].self, from: data) else {
            self.errorMessage = "No quotes available at all. Add some to quotes.json."
            return
        }

        self.quotes = decoded
        print("✅ Loaded \(self.quotes.count) quotes from quotes.json")
    }
}
