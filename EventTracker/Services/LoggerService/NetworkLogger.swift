//
//  NetworkLogger.swift
//  EventTracker
//
//  Created by Admin on 7/7/25.
//

import Foundation

final class NetworkLogger {
    static let shared = NetworkLogger()

    func logResponse(data: Data?, response: URLResponse?, error: Error?) {
        #if DEBUG
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ No valid HTTPURLResponse")
            return
        }

        let url = httpResponse.url?.absoluteString ?? "Unknown URL"
        let statusCode = httpResponse.statusCode
        let timestamp = Date().timeIntervalSince1970
        let cookies = HTTPCookieStorage.shared.cookies(for: httpResponse.url ?? URL(string: "https://localhost")!)?
            .map { "'\($0.name)=\($0.value)'" }
            .joined(separator: "\n") ?? "None"

        var bodyString = "None"

        if let data = data {
            if
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
                let prettyString = String(data: prettyData, encoding: .utf8) {
                bodyString = prettyString
            } else {
                bodyString = String(data: data, encoding: .utf8) ?? "Unreadable body"
            }
        }

        print("""
        📦 [Network Log]
        ┌──────────────────────────────────────────────┐
        │ URL             : \(url)
        │ Status Code     : \(statusCode)
        │ Timestamp       : \(timestamp)
        │ Cookies         :
        \(cookies)
        │ Response Body   :
        \(bodyString)
        └──────────────────────────────────────────────┘
        """)
        #endif
    }
}
