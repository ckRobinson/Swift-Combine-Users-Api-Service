//
//  PutViewModel.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import Foundation

class PutViewModel: ObservableObject {
    @Published var originalDataViewState: ViewState = .initial
    @Published var viewState: ViewState = .initial
    @Published var originalPostData: UserPostData? = nil
    @Published var updatedPostData: UserPostData? = nil
    private let service: NetworkServiceAsync = NetworkServiceAsync()

    @MainActor func fetchOriginalData() {

        self.originalDataViewState = .loading
        Task {
            
            do {
                self.originalPostData = try await service.fetchPostUsingAsyncAwait(postID: 1)
                self.originalDataViewState = .loaded
            }
            catch {
                print(error)
                self.originalDataViewState = .error
            }
        }
    }
    
    @MainActor func putData(postTitle: String, postBody: String) {
        if postTitle == "" || postBody == "" {
            self.viewState = .badInput
            return;
        }
        
        self.viewState = .loading
        Task {
            
            do {
                let data = try await service.addPostUsingAsyncAwait(UserPostData(userID: 1, postID: 1, postTitle: postTitle, postBody: postBody))
                self.updatedPostData = data
                self.viewState = .loaded
            }
            catch {
                print(error)
                self.viewState = .error
            }
        }
    }
}
