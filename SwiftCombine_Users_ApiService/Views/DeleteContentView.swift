//
//  DeleteContentView.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import SwiftUI

struct DeleteContentView: View {
    
    @StateObject var viewModel: DeleteViewModel = DeleteViewModel()
    
    var body: some View {
        ScrollView {
            
            Text("Delete")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            HStack {
                Button(action: {
                    viewModel.deleteData(.AsyncAwait)

                }) {
                    Text("Delete w/ Async")
                }
                .padding(5)
                .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)))
                .cornerRadius(10)
                
                Button(action: {
                    viewModel.deleteData(.CombineFuture)
                }) {
                    Text("Delete w/ Future")
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
                    Text("Tap button above to update server.")
                    
                case .loading:
                    ProgressView()
                case .loaded:
                    Text("Data deleted from server successfully.")
                    
                case .error, .badInput:
                    Text("Could not complete request. Please try again later.")
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

struct DeleteContentView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteContentView()
            .padding(.horizontal)
    }
}
