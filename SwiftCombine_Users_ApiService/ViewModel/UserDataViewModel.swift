//
//  UserDataViewModel.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron on 6/20/23.
//

import Foundation
import Combine;

class UserDataViewModel: ObservableObject {
    
    @Published var users: Dictionary<Int, User> = Dictionary();
    let userDataService: UserDataService = UserDataService();
    var cancellable = Set<AnyCancellable>();
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
