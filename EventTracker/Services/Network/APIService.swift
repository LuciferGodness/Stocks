//
//  APIService.swift
//  EventTracker
//
//  Created by Admin on 6/25/25.
//
import Combine
import Dispatch
import Foundation

protocol APIServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoints) -> AnyPublisher<T, Error>
}

final class APIService: APIServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoints) -> AnyPublisher<T, Error> {
        guard let url = endpoint.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        endpoint.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { data, response in
                NetworkLogger.shared.logResponse(data: data, response: response, error: nil)
            }, receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    NetworkLogger.shared.logResponse(data: nil, response: nil, error: error)
                }
            })
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
