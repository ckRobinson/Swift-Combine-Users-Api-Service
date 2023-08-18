//
//  PatchContentView.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import SwiftUI

struct PatchContentView: View {
    
    @StateObject var viewModel: PatchViewModel = PatchViewModel()
    @State var postTitle: String = ""
    @State var postBody: String = ""
    
    var body: some View {
        ScrollView {
            
            Text("Patch")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("New Post Title:")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Title", text: $postTitle)
                .padding(.bottom)
            
            Text("New Post Body:")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Body", text: $postBody, axis: .vertical)
            
            HStack {
                Button(action: {
                    viewModel.patchData(postTitle: postTitle,
                                       postBody: postBody,
                                       .AsyncAwait)
                }) {
                    Text("Submit w/ Async")
                }
                .padding(5)
                .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)))
                .cornerRadius(10)
                
                Button(action: {
                    viewModel.patchData(postTitle: postTitle,
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
            
            switch viewModel.originalDataViewState {
                case .initial, .loading:
                    ProgressView()
                case .loaded:
                    Text("Original post data: ")
                    displayPostedData(postedData: viewModel.originalPostData)
                    
                case .error, .badInput:
                    Text("Could not complete request. Please try again later.")
            }
            
            Divider()
                .padding()
            
            switch viewModel.viewState {
                case .initial:
                    Text("Submit data above to update server with data.")
                    
                case .loading:
                    ProgressView()
                case .loaded:
                    Text("Data patched on server: ")
                    displayPostedData(postedData: viewModel.updatedPostData)
                    
                case .error:
                    Text("Could not complete request. Please try again later.")
                    
                case .badInput:
                    Text("Please make sure you are only updating one of the fields above.")
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top)
        .onAppear() {
            viewModel.fetchOriginalData()
        }
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

struct PatchContentView_Previews: PreviewProvider {
    static var previews: some View {
        PatchContentView()
            .padding(.horizontal)
    }
}
