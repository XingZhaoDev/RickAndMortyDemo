//
//  ContentView.swift
//  RickAndMortyDemo
//
//  Created by Xing Zhao on 2022/1/4.
//

import SwiftUI
/** https://rickandmortyapi.com/api/character
*/

/**https://reqbin.com
 */

struct ContentView: View {
    @ObservedObject private var viewModel = CharacterViewModel(service: CharacterService())
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case let .success(data):
                List { 
                     ForEach(data, id:\.id) { item in
                         Text(item.name)
                    }
                }
                .navigationTitle("Characters")
            case .loading:
                ProgressView()
            default:
                EmptyView()
            }
        }
        .task {
            await viewModel.getCharacters()
        }
        .alert("Error", isPresented: $viewModel.hasError, presenting: viewModel.state) { state in
            Button("Retry") {
                Task {
                    await viewModel.getCharacters()
                }
            }
        } message: { state in
            if case let .failed(error) = state {
                Text(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
