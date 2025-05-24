//
//  FavoriteImage.swift
//  ImageSearch
//
//  Created by Ishmam Abrar on 19/9/24.
//

import Foundation

struct FavoriteImage: Identifiable, Codable {
    var id = UUID()
    let url: String
}
