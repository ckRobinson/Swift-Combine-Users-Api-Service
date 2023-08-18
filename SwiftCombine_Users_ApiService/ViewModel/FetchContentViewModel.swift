//
//  UserDataViewModel.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron on 6/20/23.
//

import Foundation
import Combine;

class FetchContentViewModel: ObservableObject {
    
    @Published var users: Dictionary<Int, User> = Dictionary();
    let userDataService: NetworkServiceAsync = NetworkServiceAsync();
    var cancellable = Set<AnyCancellable>();
    
    @MainActor func fetchPostsAsyncAwait() {
        Task {
            do {
                let posts: [UserPostData] = try await self.userDataService.fetchPostsUsingAsyncAwait()
                self.processData(data: posts);
            }
            catch {
                if let error = error as? APIError {
                    print(error.description)
                }
                else {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
//    @MainActor func postAsyncAwait() {
//        Task {
//            do {
//                let post: UserPostData = try await self.userDataService.addPostUsingAsyncAwait(UserPostData(userID: 2,
//                                                                                                            postID: 8,
//                                                                                                            postTitle: "POST",
//                                                                                                            postBody: "POST: Body"))
//                print("POST Response: \(post)")
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    @MainActor func putAsyncAwait() {
//        Task {
//
//            do {
//                let post: UserPostData = try await self.userDataService
//                                                       .putPostUsingAsyncAwait(UserPostData(userID: 2,
//                                                                                            postID: 8,
//                                                                                            postTitle: "PUT",
//                                                                                            postBody: "PUT: Body"))
//                print("PUT Response: \(post)")
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    @MainActor func patchAsyncAwait() {
//        Task {
//
//            do {
//                let post: UserPostData = try await self.userDataService
//                                                       .patchPostUsingAsyncAwait(data: ["title": "Patch Title"])
//                print("PATCH Response: \(post)")
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    @MainActor func deleteAsyncAwait() {
//        Task {
//
//            do {
//                try await self.userDataService
//                              .deletePostUsingAsyncAwait()
//                print("DELETE Response: DELETED")
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    public func fetchData() {
        
        self.userDataService.fetchData()
            .sink(receiveCompletion: { completion in
                switch(completion) {
                case .finished:
                    break;
                case .failure(let err):
                    print("Fetch failed.\n    \(err.localizedDescription)");
                    return;
                }
            }, receiveValue: {[weak self] data in
                print("Recieved \(data.count) items from server. Processing.")
                self?.processData(data: data);
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
