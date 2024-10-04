//
//  CocktailGridViewModelTests.swift
//  CocktailDBTests
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import XCTest
@testable import CocktailDB

final class CocktailGridViewModelTests: XCTestCase {
    
    @MainActor
    func testFetchCocktailCategories() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        
        await cocktailGridViewModel.viewDidLoad()
        
        XCTAssertEqual(cocktailGridViewModel.model.categories, [.init(category: "Ordinary Drink")])
    }
    
    @MainActor
    func testFetchCocktailCategoriesFailure() async {
        let cocktailServiceProtocolMock = CocktailServiceProtocolMock()
        cocktailServiceProtocolMock.shouldGetCategoriesWork = false
        let cocktailGridViewModel = CocktailGridViewModel(service: cocktailServiceProtocolMock)
        
        await cocktailGridViewModel.viewDidLoad()
        
        XCTAssertEqual(cocktailGridViewModel.destination, .showErrorScreen(.viewDidLoadFailed))
    }
    
    @MainActor
    func testFetchDrinksByName() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        
        await cocktailGridViewModel.fetchCocktailByName(name: "Margarita")
        
        XCTAssertEqual(
            cocktailGridViewModel.destination,
            .showSearchCocktailList(
                [CocktailDetail(
                    id: "1502",
                    name: "Margarita",
                    category: "Ordinary Drink",
                    instruction: "Shake and strain into a chilled cocktail glass.", 
                    drinkThumb: "drinkThumb"
                )]
            )
        )
    }
    
    @MainActor
    func testFetchDrinksByNameFailure() async {
        let cocktailServiceProtocolMock = CocktailServiceProtocolMock()
        cocktailServiceProtocolMock.shouldGetByNameWork = false
        let cocktailGridViewModel = CocktailGridViewModel(service: cocktailServiceProtocolMock)
        
        await cocktailGridViewModel.fetchCocktailByName(name: "Margarita")
        
        XCTAssertEqual(cocktailGridViewModel.destination, .showErrorAlert(.fetchCocktailByNameFailed))
    }

    @MainActor
    func testFetchCocktailThumbnail() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        
        await cocktailGridViewModel.fetchCocktailThumbnail(category: "Shake")
        
        XCTAssertEqual(
            cocktailGridViewModel.model.cocktails,
            [
                CocktailThumbnail(
                    id: "5962",
                    drink: "Vodka",
                    drinkThumb: "drinkThumb"
                )
            ]
        )
    }
    
    @MainActor
    func testFetchCocktailThumbnailFailure() async {
        let cocktailServiceProtocolMock = CocktailServiceProtocolMock()
        cocktailServiceProtocolMock.shouldGetThumbnailWork = false
        let cocktailGridViewModel = CocktailGridViewModel(service: cocktailServiceProtocolMock)
        
        await cocktailGridViewModel.fetchCocktailThumbnail(category: "Shake")
        
        XCTAssertEqual(cocktailGridViewModel.destination, .showErrorScreen(.fetchCocktailThumbnailFailed))
    }
    
    @MainActor
    func testGetCocktailByPosition() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        await cocktailGridViewModel.fetchCocktailThumbnail(category: "Shake")
        
        let cocktail = cocktailGridViewModel.getCocktailByPosition(0)
        
        XCTAssertEqual(cocktail?.drink, "Vodka")
        XCTAssertEqual(cocktail?.id, "5962")
        XCTAssertEqual(cocktail?.drinkThumb, "drinkThumb")
    }
    
    @MainActor
    func testGetCocktailByPositionFailureGivenNoCocktails() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        
        let cocktail = cocktailGridViewModel.getCocktailByPosition(0)
        
        XCTAssertNil(cocktail)
    }
    
    @MainActor
    func testGetCocktailByPositionFailureGivenNoValidPosition() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        await cocktailGridViewModel.fetchCocktailThumbnail(category: "Shake")
        
        let cocktail = cocktailGridViewModel.getCocktailByPosition(-4)
        
        XCTAssertNil(cocktail)
    }
}
