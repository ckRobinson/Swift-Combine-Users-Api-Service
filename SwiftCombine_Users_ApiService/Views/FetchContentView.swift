//
//  FetchContentView.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import SwiftUI

struct FetchContentView: View {
    @StateObject var viewModel = UserDataViewModel()
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                userList
            }
            .navigationTitle("Users")
        }
        .padding()
        .onAppear() {
            viewModel.fetchPostsAsyncAwait()
        }
    }
    
    var userList: some View {
        ForEach(Array(self.viewModel.users.keys).sorted(), id: \.self) { userID in
            if let user = self.viewModel.users[userID] {
                
                NavigationLink(destination: {
                    UserPostingsView(userData: user)
                        .padding(.top, -55);
                }, label: {
                    userListing(userData: user);
                })
                .foregroundColor(.black)
            }
        }
    }
    
    private func userListing(userData: User) -> some View {
        
        VStack(alignment: .leading) {
            Text("User \(userData.userID)")
                .font(.system(size: 18).bold())
            Text("\(userData.userPosts.count) posts")
                .padding(.leading)
        }
        .padding(.vertical)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.4))
        .cornerRadius(15)
    }
}

struct FetchContentView_Previews: PreviewProvider {
    static var previews: some View {
        FetchContentView()
    }
}
