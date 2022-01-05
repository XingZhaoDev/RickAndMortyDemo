//
//  CharacterServiceResult.swift
//  RickAndMortyDemo
//
//  Created by Xing Zhao on 2022/1/4.
//

import Foundation

struct CharacterServiceResult: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
}

