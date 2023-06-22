//
//  UserPostData.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron on 6/20/23.
//

import Foundation

struct UserPostData: Codable, Hashable {
    let userID: Int;
    let postID: Int;
    let postTitle: String;
    let postBody: String;
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case postID = "id"
        case postTitle = "title"
        case postBody = "body"
    }
}
