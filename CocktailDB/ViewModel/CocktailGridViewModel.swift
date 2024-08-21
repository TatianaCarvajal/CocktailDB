//
//  CocktailGridViewModel.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import Foundation

class CocktailGridViewModel {
    enum State {
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
    
    private let service: CocktailServiceProtocol
    @Published var state = State.idle
    @Published var isLoading = false
    
    init(service: CocktailServiceProtocol) {
        self.service = service
    }
    
    func viewDidLoad() async {
        isLoading = true
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
        isLoading = false
    }
    
    func fetchCocktailByName(name: String) async {
        isLoading = true
        do {
            let drinks = try await service.fetchCocktailByName(name: name)
            state = .loadedCocktails(drinks)
        }
        catch {
            state = .error(.noDataFound)
        }
        isLoading = false
    }
    
    func fetchCocktailThumbnail(category: String) async {
        let oldCategory = state.model
        isLoading = true
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
        isLoading = false
    }
    
    func getCocktailByPosition(_ pos: Int) -> CocktailThumbnail? {
        guard let cocktails = state.model?.cocktails else {
            return nil
        }
        guard pos >= 0 && pos <= cocktails.count else {
            return nil
        }
        let cocktail = cocktails[pos]
        return cocktail
    }
}
