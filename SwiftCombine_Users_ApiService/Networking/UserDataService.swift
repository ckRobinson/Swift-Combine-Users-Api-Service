//
//  UserDataService.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron on 6/20/23.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidUrl
    case invalidResponse
    case emptyData
    case serviceUnavailable
    case decodingError
    
    var description: String {
        switch self {
        case .invalidUrl:
            return "invalid url"
        case .invalidResponse:
            return "invalid response"
        case .emptyData:
            return "empty data"
        case .serviceUnavailable:
            return "service unavailable"
        case .decodingError:
            return "decoding error"
        }
    }
}

class UserDataService {
    
    let apiUrl: String = "https://jsonplaceholder.typicode.com/posts";
    var cancellable = Set<AnyCancellable>();
    
    public func fetchPostsUsingAsyncAwait() async throws -> [UserPostData] {
        
        guard let url = URL(string: self.apiUrl) else {
            throw APIError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url);
        guard let resp = response as? HTTPURLResponse,
                  resp.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        return try JSONDecoder().decode([UserPostData].self, from: data)
    }
    
    public func addPostUsingAsyncAwait(_ postData: UserPostData) async throws -> UserPostData {
        
        guard let url = URL(string: self.apiUrl) else {
            throw APIError.invalidUrl
        }
        
        var request = URLRequest(url: url);
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(postData);
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type");
        
        let (data, response) = try await URLSession.shared.data(for: request);
        
        guard let resp = response as? HTTPURLResponse, resp.statusCode == 201 else {
            throw APIError.serviceUnavailable
        }
        
        return try JSONDecoder().decode(UserPostData.self, from: data)
    }
    
    public func putPostUsingAsyncAwait(_ postData: UserPostData) async throws -> UserPostData {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            throw APIError.invalidUrl
        }
        
        var request = URLRequest(url: url);
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(postData);
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type");
        
        let (data, response) = try await URLSession.shared.data(for: request);
        
        guard let resp = response as? HTTPURLResponse,
              resp.statusCode == 200 else {
            throw APIError.serviceUnavailable
        }

        return try JSONDecoder().decode(UserPostData.self, from: data)
    }
    
    public func patchPostUsingAsyncAwait<T: Encodable>(data: [String: T]) async throws -> UserPostData  {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            throw APIError.invalidUrl
        }
        
        var request = URLRequest(url: url);
        request.httpMethod = "PATCH"
        request.httpBody = try JSONEncoder().encode(data);
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type");
        
        let (data, response) = try await URLSession.shared.data(for: request);
        
        guard let resp = response as? HTTPURLResponse,
              resp.statusCode == 200 else {
            throw APIError.serviceUnavailable
        }

        return try JSONDecoder().decode(UserPostData.self, from: data)
    }
    
    public func deletePostUsingAsyncAwait() async throws -> Void  {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            throw APIError.invalidUrl
        }
        
        var request = URLRequest(url: url);
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request);
        
        guard let resp = response as? HTTPURLResponse,
              resp.statusCode == 200 else {
            throw APIError.serviceUnavailable
        }

        return
    }
    
    public func fetchData_Old() -> Future<[UserPostData], Error> {
        
        return Future {[weak self] promise in
            
            guard let self = self else {
                print("Could not process fetch. Self was nil.")
                return;
            }
            
            let url = URL(string: self.apiUrl);
            guard let url = url else {
                print("Could not process fetch. Url returned nul.");
                return;
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map {
                    print("Received data. Continuing processing.")
                    return $0.data
                }
                .decode(type: [UserPostData].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    switch(completion) {
                    case .finished:
                        break;
                    case .failure(let err):
                        promise(.failure(err))
                    }
                } receiveValue: { response in
                    promise(.success(response))
                }
                .store(in: &self.cancellable)
        }
    }
    
    func fetchData() -> AnyPublisher<[UserPostData], Never> {
        
        guard let url = URL(string: self.apiUrl) else {
            let subject = CurrentValueSubject<[UserPostData], Never>([])
            return subject.eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map {
                print("Received data. Continuing processing.")
                return $0.data
            }
            .decode(type: [UserPostData].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}

