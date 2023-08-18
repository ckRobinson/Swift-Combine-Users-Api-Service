//
//  PostViewModel.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var viewState: ViewState = .initial
    @Published var postData: UserPostData? = nil
    private let service: NetworkServiceAsync = NetworkServiceAsync()
    
    @MainActor func postData(postTitle: String, postBody: String) {
        if postTitle == "" || postBody == "" {
            self.viewState = .badInput
            return;
        }
        
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
}
