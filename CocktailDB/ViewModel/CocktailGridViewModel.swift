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
        case loaded(CocktailGridModel)
        case loadedCocktails(CocktailResponse)
        
        var model: CocktailGridModel? {
            guard case let .loaded(cocktailGridModel) = self else {
                return nil
            }
            return cocktailGridModel
        }
    }
    
    let service: CocktailServiceProtocol
    @Published var state = State.idle
    
    init(service: CocktailServiceProtocol) {
        self.service = service
    }
    
    func viewDidLoad() async {
        state = .loading
        do {
            let categories = try await service.fetchCocktailCategories()
            guard let firstCategory = categories.drinks.first else {
                state = .error(.noDataFound)
                return
            }
            let cocktails = try await service.fetchCocktailThumbnail(category: firstCategory.category)
            state = .loaded(
                .init(
                    categories: categories.drinks,
                    cocktails: cocktails.drinks
                )
            )
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
    
    func fetchCocktailThumbnail(category: String) async {
        let oldCategory = state.model
        state = .loading
        do {
            let drinks = try await service.fetchCocktailThumbnail(category: category)
            state = .loaded(
                .init(
                    categories: oldCategory?.categories ?? [],
                    cocktails: drinks.drinks
                )
            )
        }
        catch {
            state = .error(.noDataFound)
        }
    }
}
