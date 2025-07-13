//
//  AppQuote.swift
//  QuotApp
//
//  Created by SAJAN  on 13/07/25.
//

//
//  AppQuote.swift
//  QuotApp
//
//  Created by SAJAN on 13/07/25.
//

import Foundation
struct AppQuote: Codable {
    let content: String
    let author: String
}

//@main
struct QuoteDecoderTest {
    static func main() {
        let url = URL(string: "https://type.fit/api/quotes")!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let quotes = try JSONDecoder().decode([AppQuote].self, from: data)
                    print("✅ Loaded \(quotes.count) quotes.")
                } catch {
                    print("❌ Decode error: \(error)")
                }
            } else if let error = error {
                print("❌ URL error: \(error)")
            }
        }
        task.resume()
        RunLoop.main.run() // Keeps it alive in playground/CLI
    }
}
