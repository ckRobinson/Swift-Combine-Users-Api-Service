//
//  DeleteViewModel.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import Foundation
import Combine

class DeleteViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var originalDataViewState: ViewState = .initial
    @Published var viewState: ViewState = .initial
    @Published var originalPostData: UserPostData? = nil

    let serviceType: ServiceType = .CombineFuture
    let networkServiceAsync: NetworkServiceAsync = NetworkServiceAsync();
    let networkServiceFuture: NetworkServiceFuture = NetworkServiceFuture();
    let networkServicePublusher: NetworkServicePublisher = NetworkServicePublisher();
    
    public func deleteData() {
        switch self.serviceType {
            case .AsyncAwait:
                // Not sure if this is good pracice, just using it for
                // easy swaping to other forms of network calls in testing.
                Task {
                    await self.deleteDataAsync()
                }
                break;
            case .CombineFuture, .CombinePublisher:
                self.deleteDataFuture()
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
    
    @MainActor private func deleteDataAsync() {
                
        self.viewState = .loading
        Task {
            
            do {
                try await networkServiceAsync.deleteUserPost()
                self.viewState = .loaded
            }
            catch {
                print(error)
                self.viewState = .error
            }
        }
    }
    
    private func deleteDataFuture() {
        
        self.viewState = .loading
        self.networkServiceFuture.deleteUserPost()
            .sink(receiveCompletion: {[weak self] completion in
                switch completion {
                    case .finished:
                        break;
                    case .failure(let err):
                        print("Could not complete delete.")
                        self?.viewState = .error
                }
            }, receiveValue: {[weak self] value in
                self?.viewState = .loaded
            })
            .store(in: &cancellables)
    }
}
