//
//  Cocktail.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import Foundation

struct CocktailDetail: Codable, Equatable {
    var id: String
    var name: String
    var category: String
    var instruction: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case instruction = "strInstructions"
    }
}

struct CocktailResponse: Codable, Equatable {
    let drinks: [CocktailDetail]
}
