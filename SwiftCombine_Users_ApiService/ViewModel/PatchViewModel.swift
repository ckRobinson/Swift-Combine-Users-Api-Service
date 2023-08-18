//
//  PatchViewModel.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import Foundation

class PatchViewModel: ObservableObject {
    @Published var originalDataViewState: ViewState = .initial
    @Published var viewState: ViewState = .initial
    @Published var originalPostData: UserPostData? = nil
    @Published var updatedPostData: UserPostData? = nil
    private let service: NetworkServiceAsync = NetworkServiceAsync()

    @MainActor func fetchOriginalData() {

        self.originalDataViewState = .loading
        Task {
            
            do {
                self.originalPostData = try await service.fetchPost(postID: 1)
                self.originalDataViewState = .loaded
            }
            catch {
                print(error)
                self.originalDataViewState = .error
            }
        }
    }
    
    @MainActor func patchData(postTitle: String, postBody: String) {
        
        if postTitle != "" && postBody != "" {
            self.viewState = .badInput
            return;
        }
        
        var jsonData: [String: String] = [:]
        if postTitle != "" {
            jsonData["title"] = postTitle
        }
        else {
            jsonData["body"] = postBody
        }
        
        self.viewState = .loading
        Task {
            
            do {
                let data = try await service.patchPostUsingAsyncAwait(data: jsonData)
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
