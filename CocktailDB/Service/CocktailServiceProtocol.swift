//
//  CocktailServiceProtocol.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import Foundation

protocol CocktailServiceProtocol {
    func fetchCocktailCategories() async throws -> CategoriesResponse
}
