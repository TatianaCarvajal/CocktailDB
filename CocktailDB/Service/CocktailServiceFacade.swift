//
//  CocktailServiceFacade.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import Foundation

class CocktailServiceFacade: CocktailServiceProtocol {
    func fetchCocktailCategories() async throws -> CategoriesResponse {
        guard let url = URL(string: "www.thecocktaildb.com/api/json/v1/1/list.php?c=list") else {
            throw ServiceError.noDataFound
        }
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        let result = try decoder.decode(CategoriesResponse.self, from: data)
        return result
    }
    
    func fetchCocktailByName(name: String) async throws -> CocktailResponse {
        guard let url = URL(string: "www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita")
        else {
            throw ServiceError.noDataFound
        }
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        let result = try decoder.decode(CocktailResponse.self, from: data)
        return result
    }
    
    func fetchCocktailThumbnail() async throws -> CocktailThumbnailResponse {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink")
        else {
            throw ServiceError.noDataFound
        }
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        let result = try decoder.decode(CocktailThumbnailResponse.self, from: data)
        return result
    }
}

