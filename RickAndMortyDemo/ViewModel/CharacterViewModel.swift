//
//  CharacterViewModel.swift
//  RickAndMortyDemo
//
//  Created by Xing Zhao on 2022/1/4.
//

import Foundation

@MainActor
class CharacterViewModel: ObservableObject {
    
    enum State {
        case na
        case loading
        case success(data: [Character])
        case failed(error: Error)
    }
    
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    private let service: CharacterService
    
    init(service: CharacterService) {
        self.service = service
    }
    
    func getCharacters() async {
        self.state = .loading
        self.hasError = false
        
        do {
            let characters = try await service.asyncFetchCharacters()
            self.state = .success(data: characters)
        } catch {
            //print(error.localizedDescription)
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
}
