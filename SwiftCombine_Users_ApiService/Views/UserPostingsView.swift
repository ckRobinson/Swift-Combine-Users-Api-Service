//
//  UserPostingsView.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron on 6/20/23.
//

import SwiftUI

struct UserPostingsView: View {
        
    let userData: User
    var body: some View {

        VStack {
            Text("User \(userData.userID)")
                .font(.system(size: 20).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
            ScrollView {
                ForEach(userData.userPosts.sorted(by: { $0.postID < $1.postID }), id: \.postID) { post in

                    postListing(postData: post)
                }
            }
        }
    }
    
    private func postListing(postData: UserPostData) -> some View {
        VStack(alignment: .leading) {
            Text("\(postData.postTitle)")
                .font(.system(size: 16).bold())
                .padding(.leading)
            Text("\(postData.postBody)")
                .font(.system(size: 14))
                .padding(.leading)
                .padding(.leading)
        }
        .padding(.vertical)
        .padding(.horizontal, 1)
        .padding(.trailing)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.4))
        .cornerRadius(15)
    }
}

struct UserPostingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserPostingsView(userData: User.mockData())
    }
}
