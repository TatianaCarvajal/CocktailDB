//
//  CocktailGridViewModel.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import Foundation

class CocktailGridViewModel {
    enum State {
        case loading
        case error(ServiceError)
        case idle
        case loadedCategories(CategoriesResponse)
        case loadedCocktails(CocktailResponse)
        case loadedCocktailThumbnail(CocktailThumbnailResponse)
    }
    
    let service: CocktailServiceProtocol
    var state = State.idle
    
    init(service: CocktailServiceProtocol) {
        self.service = service
    }
    
    func fetchCocktailCategories() async {
        state = .loading
        do {
            let categories = try await service.fetchCocktailCategories()
            state = .loadedCategories(categories)
        }
        catch {
            state = .error(.noDataFound)
        }
    }
    
    func fetchCocktailByName(name: String) async {
        state = .loading
        do {
           let drinks = try await service.fetchCocktailByName(name: name)
            state = .loadedCocktails(drinks)
        }
        catch {
            state = .error(.noDataFound)
        }
    }
    
    func fetchCocktailThumbnail() async {
        state = .loading
        do {
            let drinks = try await service.fetchCocktailThumbnail()
            state = .loadedCocktailThumbnail(drinks)
        }
        catch {
            state = .error(.noDataFound)
        }
    }
}
