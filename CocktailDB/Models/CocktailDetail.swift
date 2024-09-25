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
    var firstIngredient: String?
    var secondIngredient: String?
    var thirdIngredient: String?
    var fourthIngredient: String?
    var fifthIngredient: String?
    var drinkThumb: String
    var image: URL? {
        URL(string: drinkThumb)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case instruction = "strInstructions"
        case firstIngredient = "strIngredient1"
        case secondIngredient = "strIngredient2"
        case thirdIngredient = "strIngredient3"
        case fourthIngredient = "strIngredient4"
        case fifthIngredient = "strIngredient5"
        case drinkThumb = "strDrinkThumb"
    }
}

struct CocktailResponse: Codable, Equatable {
    let drinks: [CocktailDetail]
}
