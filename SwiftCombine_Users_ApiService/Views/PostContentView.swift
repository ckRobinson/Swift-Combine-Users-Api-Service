//
//  PostContentView.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import SwiftUI


struct PostContentView: View {
    
    @StateObject var viewModel: PostViewModel = PostViewModel()
    @State var postTitle: String = ""
    @State var postBody: String = ""
    
    var body: some View {
        ScrollView {
            Text("Post")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Post Title:")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Title", text: $postTitle)
                .padding(.bottom)
            
            Text("Post Body:")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Body", text: $postBody, axis: .vertical)
            
            HStack {
                Button(action: {
                    viewModel.postData(postTitle: postTitle,
                                       postBody: postBody,
                                       .AsyncAwait)
                }) {
                    Text("Submit w/ Async")
                }
                .padding(5)
                .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)))
                .cornerRadius(10)
                
                Button(action: {
                    viewModel.postData(postTitle: postTitle,
                                       postBody: postBody,
                                       .CombineFuture)
                }) {
                    Text("Submit w/ Future")
                }
                .padding(5)
                .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)))
                .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.bottom)
            
            Divider()
                .padding(.bottom)
            
            switch viewModel.viewState {
                case .initial:
                    Text("Submit data above to create a post.")
                    
                case .loading:
                    ProgressView()
                case .loaded:
                    Text("Data posted to server: ")
                    displayPostedData(postedData: viewModel.postData)

                case .error:
                    Text("Could not complete request. Please try again later.")
                    
                case .badInput:
                    Text("Please check your post title and body and try again.")
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top)
    }
    
    func displayPostedData(postedData: UserPostData?) -> some View {
        Group {
            if let data = postedData {
                PostListing(postData: data)
            }
            else {
                EmptyView()
            }
        }
    }
}

struct PostContentView_Previews: PreviewProvider {
    static var previews: some View {
        PostContentView()
            .padding(.horizontal)
    }
}
