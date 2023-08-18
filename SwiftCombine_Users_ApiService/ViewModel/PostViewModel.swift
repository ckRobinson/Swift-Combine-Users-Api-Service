//
//  PostViewModel.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    @Published var viewState: ViewState = .initial
    @Published var postData: UserPostData? = nil
    
    // Can't think of easy way to make this a protocol since all different return types / Async throws
    // initing all 3 and using methods here to test each style.
    let serviceType: ServiceType = .CombineFuture
    let networkServiceAsync: NetworkServiceAsync = NetworkServiceAsync();
    let networkServiceFuture: NetworkServiceFuture = NetworkServiceFuture();
    let networkServicePublusher: NetworkServicePublisher = NetworkServicePublisher();
    
    public func postData(postTitle: String, postBody: String) {
        if postTitle == "" || postBody == "" {
            self.viewState = .badInput
            return;
        }
        
        switch self.serviceType {
            case .AsyncAwait:
                // Not sure if this is good pracice, just using it for
                // easy swaping to other forms of network calls in testing.
                Task {
                    await self.postDataAsync(postTitle: postTitle, postBody: postBody)
                }
                break;
            case .CombineFuture:
                self.postDataFuture(postTitle: postTitle, postBody: postBody)
                break
            case .CombinePublisher:
//                self.fetchPostsPublisher()
                break
        }
    }
    
    @MainActor private func postDataAsync(postTitle: String, postBody: String) {
        print("Posting with Async")
        
        self.viewState = .loading
        Task {
            
            do {
                let data = try await networkServiceAsync.postUserPost(UserPostData(userID: 1, postID: 1, postTitle: postTitle, postBody: postBody))
                self.postData = data
                self.viewState = .loaded
            }
            catch {
                print(error)
                self.viewState = .error
            }
        }
    }
    
    private func postDataFuture(postTitle: String, postBody: String) {
        print("Posting with Future")
        
        self.viewState = .loading
        self.networkServiceFuture.postUserPost(UserPostData(userID: 1,
                                                            postID: 1,
                                                            postTitle: postTitle,
                                                            postBody: postBody))
        .sink(receiveCompletion: {[weak self] completion in
            switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.viewState = .error
            }
        }, receiveValue: {[weak self] value in
            
            self?.viewState = .loaded
            self?.postData = value
        })
        .store(in: &self.cancellables)
    }
}
