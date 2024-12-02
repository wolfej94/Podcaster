//
//  Service.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

import Foundation
import Combine

public class Service {

    internal func request<T: Decodable>(_ request: URLRequest,
                                        usingSession session: NetworkURLSession,
                                        decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        let (data, response) = try await session.data(for: request, delegate: nil)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try decoder.decode(T.self, from: data)
    }

    internal func request<T: Decodable>(_ request: URLRequest,
                               usingSession session: NetworkURLSession,
                               decoder: JSONDecoder = JSONDecoder(),
                               completionHandler: @escaping @Sendable (Result<T, Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            do {
                if let error = error {
                    throw error
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                guard let data = data else {
                    throw URLError(.cannotDecodeRawData)
                }
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }

    internal func request<T: Decodable>(_ request: URLRequest,
                               usingSession session: NetworkURLSession,
                               decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

}
