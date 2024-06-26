//
//  CocktailServiceProtocolMock.swift
//  CocktailDBTests
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import Foundation
@testable import CocktailDB

class CocktailServiceProtocolMock: CocktailServiceProtocol {
    var withSuccess = true
    
    func fetchCoktailByName(name: String) async throws -> CocktailResponse {
        if withSuccess == false {
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
    
    func fetchCocktailCategories() async throws -> CategoriesResponse {
        if withSuccess == false {
            throw ServiceError.noDataFound
        } else {
            return CategoriesResponse(
                drinks: [CocktailCategory(
                    category: "Ordinary Drink"
                )]
            )
        }
    }
}
