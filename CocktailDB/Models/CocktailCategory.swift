//
//  CocktailCategory.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import Foundation

struct CocktailCategory: Codable {
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case category = "strCategory"
    }
}

struct CategoriesResponse: Codable {
    let drinks: [CocktailCategory]
}
