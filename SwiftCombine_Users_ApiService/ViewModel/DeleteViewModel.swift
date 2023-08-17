//
//  DeleteViewModel.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import Foundation

class DeleteViewModel: ObservableObject {
    @Published var originalDataViewState: ViewState = .initial
    @Published var viewState: ViewState = .initial
    @Published var originalPostData: UserPostData? = nil
    private let service: UserDataService = UserDataService()

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
    
    @MainActor func deleteData() {
                
        self.viewState = .loading
        Task {
            
            do {
                try await service.deletePostUsingAsyncAwait()
                self.viewState = .loaded
            }
            catch {
                print(error)
                self.viewState = .error
            }
        }
    }
}
