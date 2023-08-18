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

class NetworkServiceAsync {

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

    public func fetchPostUsingAsyncAwait(postID: Int) async throws -> UserPostData {
        
        guard var url = URL(string: self.apiUrl) else {
            throw APIError.invalidUrl
        }
        url.append(component: "\(postID)")
        
        let (data, response) = try await URLSession.shared.data(from: url);
        guard let resp = response as? HTTPURLResponse,
                  resp.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        return try JSONDecoder().decode(UserPostData.self, from: data)
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
}

