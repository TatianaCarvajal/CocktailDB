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
