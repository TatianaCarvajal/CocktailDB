//
//  CocktailGridViewModel.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import Foundation
import UIKit

@MainActor
class CocktailGridViewModel {
    enum ErrorCase: LocalizedError, Equatable {
        case viewDidLoadFailed
        case fetchCocktailByNameFailed
        case fetchCocktailThumbnailFailed
        
        var errorDescription: String? {
            switch self {
            case .viewDidLoadFailed:
                "Sorry, we can't show you the categories in this moment, please try again later"
            case .fetchCocktailByNameFailed:
                "Sorry, we can't find the cocktail that you searched, please try again later"
            case .fetchCocktailThumbnailFailed:
                "Sorry, something went wrong with the load, please try again later"
            }
        }
    }
    
    enum Destination: Equatable {
        case showErrorScreen(ErrorCase)
        case showErrorAlert(ErrorCase)
        case showSearchCocktailList([CocktailDetail])
    }
    
    private let service: CocktailServiceProtocol
    private var cocktails: [CocktailThumbnail] = []
    @Published var isLoading = false
    @Published var model = CocktailGridModel(categories: [], cocktails: [])
    @Published var destination: Destination?
    
    init(service: CocktailServiceProtocol) {
        self.service = service
    }
    
    func viewDidLoad() async {
        isLoading = true
        do {
            let categories = try await service.fetchCocktailCategories()
            guard let firstCategory = categories.drinks.first else {
                destination = .showErrorScreen(.viewDidLoadFailed)
                return
            }
            let cocktails = try await service.fetchCocktailThumbnail(category: firstCategory.category)
            model.cocktails = cocktails.drinks
            model.categories = categories.drinks
        }
        catch {
            destination = .showErrorScreen(.viewDidLoadFailed)
        }
        isLoading = false
    }
    
    func fetchCocktailByName(name: String) async {
        guard !name.isEmpty else {
            return
        }
        isLoading = true
        do {
            let drinks = try await service.fetchCocktailByName(name: name)
            destination = .showSearchCocktailList(drinks.drinks)
        }
        catch {
            destination = .showErrorAlert(.fetchCocktailByNameFailed)
        }
        isLoading = false
    }
    
    func fetchCocktailThumbnail(category: String) async {
        isLoading = true
        do { 
            let drinks = try await service.fetchCocktailThumbnail(category: category)
            model.cocktails = drinks.drinks
        }
        catch {
            destination = .showErrorScreen(.fetchCocktailThumbnailFailed)
        }
        isLoading = false
    }
    
    func getCocktailByPosition(_ pos: Int) -> CocktailThumbnail? {
        guard !model.cocktails.isEmpty else {
            return nil
        }
        guard pos >= 0 && pos <= model.cocktails.count else {
            return nil
        }
        let cocktail = model.cocktails[pos]
        return cocktail
    }
}
