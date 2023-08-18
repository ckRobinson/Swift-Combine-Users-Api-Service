//
//  UserDataViewModel.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron on 6/20/23.
//

import Foundation
import Combine
import SwiftUI

enum ServiceType {
    case AsyncAwait, CombineFuture, CombinePublisher
}

class FetchContentViewModel: ObservableObject {
    
    @Published var users: [Int: User] = [:]
    @Published var viewState: ViewState = .initial
    var cancellable = Set<AnyCancellable>();
    
    // Can't think of easy way to make this a protocl since all different return types / Async throws
    // initing all 3 and using methods here to test each style.
    let serviceType: ServiceType = .CombineFuture
    let networkServiceAsync: NetworkServiceAsync = NetworkServiceAsync();
    let networkServiceFuture: NetworkServiceFuture = NetworkServiceFuture();
    let networkServicePublusher: NetworkServicePublisher = NetworkServicePublisher();
    
    public func fetchPosts(_ serviceType: ServiceType = .AsyncAwait) {
        self.users = [:]
        switch serviceType {
            case .AsyncAwait:
                // Not sure if this is good pracice, just using it for
                // easy swaping to other forms of network calls in testing.
                Task {
                    await self.fetchPostsAsync()
                }
                break;
            case .CombineFuture:
                self.fetchPostsFuture()
            case .CombinePublisher:
                self.fetchPostsPublisher()
        }
    }
    
    @MainActor private func fetchPostsAsync() {
        print("Fetching with Async")
        self.viewState = .loading
        Task {
            do {
                let posts: [UserPostData] = try await self.networkServiceAsync.fetchPosts()
                self.processData(data: posts);
                self.viewState = .loaded
            }
            catch {
                if let error = error as? APIError {
                    print(error.description)
                }
                else {
                    print(error.localizedDescription)
                }
                self.viewState = .error
            }
        }
    }
    
    private func fetchPostsFuture() {
        print("Fetching with Future")
        self.viewState = .loading
        self.networkServiceFuture.fetchPosts()
            .sink(receiveCompletion: {[weak self] completion in
                switch(completion) {
                case .finished:
                    break;
                case .failure(let err):
                    print("Fetch failed.\n    \(err.localizedDescription)");
                    self?.viewState = .error
                    return;
                }
            }, receiveValue: {[weak self] data in
                self?.processData(data: data);
                self?.viewState = .loaded
            })
            .store(in: &self.cancellable)
    }
    
    private func fetchPostsPublisher() {
        self.viewState = .loading
        self.networkServicePublusher.fetchPosts()
            .sink(receiveCompletion: {[weak self] completion in
                switch(completion) {
                case .finished:
                    break;
                case .failure(let err):
                    print("Fetch failed.\n    \(err.localizedDescription)");
                    self?.viewState = .error
                    return;
                }
            }, receiveValue: {[weak self] data in
                self?.processData(data: data);
                self?.viewState = .loaded
            })
            .store(in: &self.cancellable)
    }
    
    private func processData(data: [UserPostData]) {
        
        for postData in data {
            
            if self.users[postData.userID] == nil {
                self.users[postData.userID] = User(userID: postData.userID);
            }
            
            if let user = self.users[postData.userID] {
                user.addPost(newPost: postData)
                continue;
            }
            print("Encountered error adding post, PostID: \(postData.postID) to UserID: \(postData.userID)")
        }
    }
}
