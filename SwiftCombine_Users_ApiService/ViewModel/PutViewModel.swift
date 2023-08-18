//
//  PutViewModel.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import Foundation
import Combine

class PutViewModel: ObservableObject {
    @Published var originalDataViewState: ViewState = .initial
    @Published var viewState: ViewState = .initial
    @Published var originalPostData: UserPostData? = nil
    @Published var updatedPostData: UserPostData? = nil

    // Can't think of easy way to make this a protocol since all different return types / Async throws
    // initing all 3 and using methods here to test each style.
    private var cancellables = Set<AnyCancellable>()
    let serviceType: ServiceType = .CombineFuture
    let networkServiceAsync: NetworkServiceAsync = NetworkServiceAsync();
    let networkServiceFuture: NetworkServiceFuture = NetworkServiceFuture();
    let networkServicePublusher: NetworkServicePublisher = NetworkServicePublisher();
    
    public func putData(postTitle: String, postBody: String, _ serviceType: ServiceType = .AsyncAwait) {
        if postTitle == "" || postBody == "" {
            self.viewState = .badInput
            return;
        }
        
        switch serviceType {
            case .AsyncAwait:
                // Not sure if this is good pracice, just using it for
                // easy swaping to other forms of network calls in testing.
                Task {
                    await self.putDataAsync(postTitle: postTitle, postBody: postBody)
                }
                break;
            case .CombineFuture:
                self.putDataFuture(postTitle: postTitle, postBody: postBody)
                break
            case .CombinePublisher:
//                self.fetchPostsPublisher()
                break
        }
    }

    @MainActor func fetchOriginalData() {

        self.originalDataViewState = .loading
        Task {
            
            do {
                self.originalPostData = try await networkServiceAsync.fetchPost(postID: 1)
                self.originalDataViewState = .loaded
            }
            catch {
                print(error)
                self.originalDataViewState = .error
            }
        }
    }
    
    @MainActor private func putDataAsync(postTitle: String, postBody: String) {
        print("Putting with Async")

        self.viewState = .loading
        Task {
            
            do {
                let data = try await networkServiceAsync.postUserPost(UserPostData(userID: 1, postID: 1, postTitle: postTitle, postBody: postBody))
                self.updatedPostData = data
                self.viewState = .loaded
            }
            catch {
                print(error)
                self.viewState = .error
            }
        }
    }
    
    private func putDataFuture(postTitle: String, postBody: String) {
        print("Putting with Future")
        
        self.viewState = .loading
        self.networkServiceFuture.putUserPost(UserPostData(userID: 1,
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
            self?.updatedPostData = value
            self?.viewState = .loaded
        })
        .store(in: &self.cancellables)
    }
}
