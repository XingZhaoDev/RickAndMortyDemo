//
//  CharacterService.swift
//  RickAndMortyDemo
//
//  Created by Xing Zhao on 2022/1/4.
//

import Foundation

struct CharacterService {
    
    enum CharacterServiceError: Error {
        case failed
        case failedToDecode
        case invalidStatusCode
    }
    
    func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        let session = URLSession
            .shared
            .dataTask(with: .init(url: URL(string: "https://rickandmortyapi.com/api/character")!)) { data , response, error in
                guard let response = response as? HTTPURLResponse else {
                    return
                }
                guard response.statusCode == 200 else {
                    completion(.failure(CharacterServiceError.invalidStatusCode))
                    return
                }
                guard let data = data, let decodeData = try? JSONDecoder().decode(CharacterServiceResult.self, from: data) else {
                    completion(.failure(CharacterServiceError.failedToDecode))
                    return
                }
                completion(.success(decodeData.results))
            }
        session.resume()
    }
    
    
    func asyncFetchCharacters() async throws -> [Character] {
        
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        let configuration = URLSessionConfiguration.ephemeral
        
        let (data, response) = try await URLSession(configuration: configuration).data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw CharacterServiceError.invalidStatusCode
        }
        let decodeData = try JSONDecoder().decode(CharacterServiceResult.self, from: data)
        return decodeData.results
    }
}
