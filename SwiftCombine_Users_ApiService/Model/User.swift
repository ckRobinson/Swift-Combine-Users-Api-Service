//
//  User.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron on 6/20/23.
//

class User {
    let userID: Int;
    var userPosts: [UserPostData] = []
    init(userID: Int) {
        self.userID = userID
    }
    
    public func addPost(newPost: UserPostData) {
        self.userPosts.append(newPost);
    }
    
    static public func mockData() -> User {
        
        let mockUser = User(userID: 1);
        mockUser.addPost(newPost: UserPostData(userID: 1,
                                               postID: 1,
                                               postTitle: "Lorem Ipsum",
                                               postBody: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))
        mockUser.addPost(newPost: UserPostData(userID: 1,
                                               postID: 2,
                                               postTitle: "Cursus Euismod",
                                               postBody: "Cursus euismod quis viverra nibh cras pulvinar mattis nunc. Eros donec ac odio tempor. Maecenas pharetra convallis posuere morbi leo urna molestie at elementum. Nunc sed blandit libero volutpat sed cras. Quis varius quam quisque id diam vel quam elementum pulvinar. Semper feugiat nibh sed pulvinar proin. Justo laoreet sit amet cursus. Adipiscing commodo elit at imperdiet dui accumsan sit. Etiam sit amet nisl purus in. Nunc id cursus metus aliquam. Mauris vitae ultricies leo integer. Viverra tellus in hac habitasse. Ullamcorper eget nulla facilisi etiam dignissim diam quis enim lobortis. Ac auctor augue mauris augue neque gravida in fermentum et. Dapibus ultrices in iaculis nunc sed augue lacus. Scelerisque fermentum dui faucibus in ornare quam. Eget nunc lobortis mattis aliquam faucibus purus in. Mattis nunc sed blandit libero volutpat sed cras."))
        return mockUser;
    }
}

