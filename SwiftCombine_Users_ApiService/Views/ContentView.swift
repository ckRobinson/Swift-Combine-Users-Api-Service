//
//  ContentView.swift
//  SwiftCombine_Users_ApiService
//
//  Created by Cameron on 6/20/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView {
//            FetchContentView()
//                .tabItem {
//                    Text("Fetch")
//                    Image(systemName: "square.and.arrow.down")
//                }
            
//            PostContentView()
//                .tabItem {
//                    Text("Post")
//                    Image(systemName: "square.and.arrow.up")
//                }
            
            Text("Put")
                .tabItem {
                    Text("Put")
                    Image(systemName: "square.and.arrow.up.on.square")
                }
            
            Text("Patch")
                .tabItem {
                    Text("Patch")
                    Image(systemName: "square.and.pencil")
                }
            
            Text("Delete")
                .tabItem {
                    Text("Delete")
                    Image(systemName: "xmark.bin")
                }
        }
        .padding()
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
