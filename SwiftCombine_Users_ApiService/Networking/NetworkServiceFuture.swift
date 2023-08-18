//
//  NetworkServiceFuture.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import Foundation
import Combine

class NetworkServiceFuture {
    
    let apiUrl: String = "https://jsonplaceholder.typicode.com/posts";
    var cancellable = Set<AnyCancellable>();
    
    public func fetchPosts() -> Future<[UserPostData], Error> {
        
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
    
    public func fetchPost(postID: Int) -> Future<UserPostData, Error> {
        
        return Future {[weak self] promise in
            
            guard let self = self else {
                return;
            }
            
            guard let url = URL(string: self.apiUrl) else {
                return;
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map {
                    $0.data
                }
                .decode(type: UserPostData.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    switch completion {
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
}
