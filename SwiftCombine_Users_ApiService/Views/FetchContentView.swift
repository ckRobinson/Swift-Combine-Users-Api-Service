//
//  FetchContentView.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import SwiftUI

struct FetchContentView: View {
    @StateObject var viewModel = FetchContentViewModel()
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                Text("Fetch")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                userList
            }
        }
        .onAppear() {
            viewModel.fetchPosts()
        }
    }
    
    var userList: some View {
        ForEach(Array(self.viewModel.users.keys).sorted(), id: \.self) { userID in
            if let user = self.viewModel.users[userID] {
                
                NavigationLink(destination: {
                    UserPostingsView(userData: user)
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
            .padding(.horizontal)
    }
}
