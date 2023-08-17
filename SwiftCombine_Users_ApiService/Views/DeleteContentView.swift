//
//  DeleteContentView.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import SwiftUI

//
//  PatchContentView.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron Robinson on 8/17/23.
//

import SwiftUI

class DeleteViewModel: ObservableObject {
    @Published var originalDataViewState: ViewState = .initial
    @Published var viewState: ViewState = .initial
    @Published var originalPostData: UserPostData? = nil
    private let service: UserDataService = UserDataService()

    @MainActor func fetchOriginalData() {

        self.originalDataViewState = .loading
        Task {
            
            do {
                self.originalPostData = try await service.fetchPostUsingAsyncAwait(postID: 1)
                self.originalDataViewState = .loaded
            }
            catch {
                print(error)
                self.originalDataViewState = .error
            }
        }
    }
    
    @MainActor func deleteData() {
                
        self.viewState = .loading
        Task {
            
            do {
                try await service.deletePostUsingAsyncAwait()
                self.viewState = .loaded
            }
            catch {
                print(error)
                self.viewState = .error
            }
        }
    }
}

struct DeleteContentView: View {
    
    @StateObject var viewModel: DeleteViewModel = DeleteViewModel()
    
    var body: some View {
        ScrollView {
            
            Text("Delete")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Button(action: {
                viewModel.deleteData()
            }) {
                Text("Delete data on server.")
            }
            .padding(5)
            .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)))
            .cornerRadius(10)
            
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
