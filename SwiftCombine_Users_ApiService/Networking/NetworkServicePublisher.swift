//
//  NetworkServicePublisher.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import Foundation
import Combine

class NetworkServicePublisher {

    let apiUrl: String = "https://jsonplaceholder.typicode.com/posts";
    
    func fetchPosts() -> AnyPublisher<[UserPostData], Never> {
        
        guard let url = URL(string: self.apiUrl) else {
            return CurrentValueSubject<[UserPostData], Never>([]).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map {
                return $0.data
            }
            .decode(type: [UserPostData].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
