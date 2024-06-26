//
//  CocktailThumbnail.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 25/06/24.
//

import Foundation

struct CocktailThumbnail: Codable {
    var id: String
    var drink: String
    var drinkThumb: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case drink = "strDrink"
        case drinkThumb = "strDrinkThumb"
    }
}
