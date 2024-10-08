//
//  CocktailThumbnail.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 25/06/24.
//

import Foundation

struct CocktailThumbnail: Codable, Equatable {
    var id: String
    var drink: String
    var drinkThumb: String
    var image: URL? {
        URL(string: drinkThumb)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case drink = "strDrink"
        case drinkThumb = "strDrinkThumb"
    }
}

struct CocktailThumbnailResponse: Codable, Equatable {
    let drinks: [CocktailThumbnail]
}
