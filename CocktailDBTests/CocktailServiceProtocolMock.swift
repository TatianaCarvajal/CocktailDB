//
//  CocktailServiceProtocolMock.swift
//  CocktailDBTests
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import Foundation
@testable import CocktailDB

class CocktailServiceProtocolMock: CocktailServiceProtocol {
    var shouldGetCategoriesWork = true
    var shouldGetByNameWork = true
    var shouldGetThumbnailWork = true
    
    func fetchCocktailCategories() async throws -> CategoriesResponse {
        if shouldGetCategoriesWork == false {
            throw ServiceError.noDataFound
        } else {
            return CategoriesResponse(
                drinks: [CocktailCategory(
                    category: "Ordinary Drink"
                )]
            )
        }
    }
    
    func fetchCocktailByName(name: String) async throws -> CocktailDB.CocktailResponse {
        if shouldGetByNameWork == false {
            throw ServiceError.noDataFound
        } else {
            return CocktailResponse(
                drinks: [CocktailDetail(
                    id: "1502",
                    name: "Margarita",
                    category: "Ordinary Drink",
                    instruction: "Shake and strain into a chilled cocktail glass."
                )]
            )
        }
    }
    
    func fetchCocktailThumbnail(category: String) async throws -> CocktailThumbnailResponse {
        if shouldGetThumbnailWork == false {
            throw ServiceError.noDataFound
        } else {
            return CocktailThumbnailResponse(
                drinks: [CocktailThumbnail(
                    id: "5962",
                    drink: "Vodka",
                    drinkThumb: "drinkThumb"
                )]
            )
        }
    }
}
