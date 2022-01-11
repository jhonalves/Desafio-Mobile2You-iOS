//
//  Extensions.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import Foundation

extension URL {
    // takes the base URL, adds the queries and return the result
    func withQuery(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
