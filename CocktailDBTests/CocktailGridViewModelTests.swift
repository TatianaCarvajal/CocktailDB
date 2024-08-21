//
//  CocktailGridViewModelTests.swift
//  CocktailDBTests
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import XCTest
@testable import CocktailDB

final class CocktailGridViewModelTests: XCTestCase {
    
    func testFetchCocktailCategories() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        
        await cocktailGridViewModel.viewDidLoad()
        
        switch cocktailGridViewModel.state {
        case let .loaded(model):
            XCTAssertEqual(
                model.categories,
                [
                    .init(category: "Ordinary Drink")
                ]
            )
        default: XCTFail("This shouldn't happen because the mock has a default success")
        }
    }
    
    func testFetchCocktailCategoriesFailure() async {
        let cocktailServiceProtocolMock = CocktailServiceProtocolMock()
        cocktailServiceProtocolMock.shouldGetCategoriesWork = false
        let cocktailGridViewModel = CocktailGridViewModel(service: cocktailServiceProtocolMock)
        
        await cocktailGridViewModel.viewDidLoad()
        
        switch cocktailGridViewModel.state {
        case let .error(error):
            XCTAssertEqual(error, .noDataFound)
        default: XCTFail("This shouldn't happen because the mock should always fail")
        }
    }
    
    func testFetchDrinksByName() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        
        await cocktailGridViewModel.fetchCocktailByName(name: "Margarita")
        
        switch cocktailGridViewModel.state {
        case let .loadedCocktails(drinks):
            XCTAssertEqual(
                drinks,
                .init(
                    drinks: [CocktailDetail(
                        id: "1502",
                        name: "Margarita",
                        category: "Ordinary Drink",
                        instruction: "Shake and strain into a chilled cocktail glass."
                    )]
                )
            )
        default: XCTFail("This shouldn't happen because the mock has a default success")
        }
    }
    
    func testFetchDrinksByNameFailure() async {
        let cocktailServiceProtocolMock = CocktailServiceProtocolMock()
        cocktailServiceProtocolMock.shouldGetByNameWork = false
        let cocktailGridViewModel = CocktailGridViewModel(service: cocktailServiceProtocolMock)
        
        await cocktailGridViewModel.fetchCocktailByName(name: "Margarita")
        
        switch cocktailGridViewModel.state {
        case let .error(error):
            XCTAssertEqual(error, .noDataFound)
        default: XCTFail("This shouldn't happen because the mock should always fail")
        }
    }
    
    func testFetchCocktailThumbnail() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        
        await cocktailGridViewModel.fetchCocktailThumbnail(category: "Shake")
        
        switch cocktailGridViewModel.state {
        case let .loaded(model):
            XCTAssertEqual(
                model.cocktails,
                [
                    CocktailThumbnail(id: "5962", drink: "Vodka", drinkThumb: "drinkThumb")
                ]
            )
        default: XCTFail("This shouldn't happen because the mock has a default success")
        }
    }
    
    func testFetchCocktailThumbnailFailure() async {
        let cocktailServiceProtocolMock = CocktailServiceProtocolMock()
        cocktailServiceProtocolMock.shouldGetThumbnailWork = false
        let cocktailGridViewModel = CocktailGridViewModel(service: cocktailServiceProtocolMock)
        
        await cocktailGridViewModel.fetchCocktailThumbnail(category: "Shake")
        
        switch cocktailGridViewModel.state {
        case let .error(error):
            XCTAssertEqual(error, .noDataFound)
        default: XCTFail("This shouldn't happen because the mock should always fail")
        }
    }
    
    func testGetCocktailByPosition() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        await cocktailGridViewModel.fetchCocktailThumbnail(category: "Shake")
        
        let cocktail = cocktailGridViewModel.getCocktailByPosition(0)
        
        XCTAssertEqual(cocktail?.drink, "Vodka")
        XCTAssertEqual(cocktail?.id, "5962")
        XCTAssertEqual(cocktail?.drinkThumb, "drinkThumb")
    }
    
    func testGetCocktailByPositionFailureGivenNoCocktails() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        
        let cocktail = cocktailGridViewModel.getCocktailByPosition(0)
        
        XCTAssertNil(cocktail)
    }
    
    func testGetCocktailByPositionFailureGivenNoValidPosition() async {
        let cocktailGridViewModel = CocktailGridViewModel(service: CocktailServiceProtocolMock())
        await cocktailGridViewModel.fetchCocktailThumbnail(category: "Shake")
        
        let cocktail = cocktailGridViewModel.getCocktailByPosition(-4)
        
        XCTAssertNil(cocktail)
    }
}
