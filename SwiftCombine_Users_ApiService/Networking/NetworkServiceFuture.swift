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
    let postID: Int = 1
    
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
    
    public func postUserPost(_ postData: UserPostData) -> Future<UserPostData, Error> {
        
        return Future {[weak self] promise in
            
            guard let self = self else {
                return
            }
            
            guard var url = URL(string: self.apiUrl) else {
                return
            }
            url.append(component: "\(postID)")
            
            var request = URLRequest(url: url);
            request.httpMethod = "POST"
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type");
            
            do {
                let jsonData = try JSONEncoder().encode(postData)
                request.httpBody = jsonData;
            }
            catch {
                return // Should return proper error in promise here.
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
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
                } receiveValue: { value in
                    promise(.success(value))
                }
                .store(in: &self.cancellable)
        }
    }
    
    public func putUserPost(_ postData: UserPostData) -> Future<UserPostData, Error> {
        
        return Future {[weak self] promise in
            
            guard let self = self else {
                return;
            }
            
            guard var url = URL(string: self.apiUrl) else {
                return
            }
            url.append(component: "\(self.postID)")
            
            var request = URLRequest(url: url);
            request.httpMethod = "PUT"
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type");
            
            do {
                let jsonData = try JSONEncoder().encode(postData);
                request.httpBody = jsonData
            }
            catch {
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
                .map {
                    $0.data
                }
                .decode(type: UserPostData.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            break
                        case .failure(let err):
                            promise(.failure(err))
                    }
                }, receiveValue: { value in
                    promise(.success(value))
                })
                .store(in: &self.cancellable)
        }
    }
    
    public func patchUserPost<T: Encodable>(data: [String: T]) -> Future<UserPostData, Error> {
        return Future {[weak self] promise in
            
            guard let self = self else {
                return;
            }
            
            guard var url = URL(string: self.apiUrl) else {
                return;
            }
            url.append(component: "\(self.postID)")
            
            var request = URLRequest(url: url);
            request.httpMethod = "PATCH";
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type");
            
            do {
                let jsonData = try JSONEncoder().encode(data)
                request.httpBody = jsonData
            }
            catch {
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
                .map {
                    $0.data
                }
                .decode(type: UserPostData.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            break
                        case .failure(let err):
                            promise(.failure(err))
                    }
                }, receiveValue: { value in
                    promise(.success(value))
                })
                .store(in: &self.cancellable)
        }
    }
    
    public func deleteUserPost() -> Future<Bool, Error> {
        return Future {[weak self] promise in
            
            guard let self = self else {
                return
            }
            
            guard var url = URL(string: self.apiUrl) else {
                return
            }
            url.append(component: "\(self.postID)")
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap() { value -> Bool in
                    guard let httpResponse = value.response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 else {
                            throw URLError(.badServerResponse)
                        }
                    return true
                }
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            break;
                        case .failure(let err):
                            promise(.failure(err))
                    }
                }, receiveValue: { val in
                    promise(.success(val))
                })
                .store(in: &self.cancellable)
        }
    }
}
