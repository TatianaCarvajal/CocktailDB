//
//  CocktailCategory.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import Foundation

struct CocktailCategory: Codable, Equatable {
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case category = "strCategory"
    }
}

struct CategoriesResponse: Codable, Equatable {
    let drinks: [CocktailCategory]
}
