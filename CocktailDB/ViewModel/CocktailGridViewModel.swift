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
    }
    
    let service: CocktailServiceProtocol
    var state = State.idle
    
    init(service: CocktailServiceProtocol) {
        self.service = service
    }
    
    func fetchCocktailCategories() async {
        state = .loading
        do {
            var categories = try await service.fetchCocktailCategories()
            state = .loadedCategories(categories)
        }
        catch {
            state = .error(.noDataFound)
        }
    }
}
