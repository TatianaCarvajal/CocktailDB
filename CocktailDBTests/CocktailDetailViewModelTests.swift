//
//  CocktailDetailViewModelTests.swift
//  CocktailDBTests
//
//  Created by Tatiana Carvajal on 4/10/24.
//

import XCTest
@testable import CocktailDB

final class CocktailDetailViewModelTests: XCTestCase {

    @MainActor
    func testFetchCocktailDetail() async {
        let cocktailDetailViewModel = CocktailDetailViewModel(service: CocktailServiceProtocolMock(), id: "test")
        
        await cocktailDetailViewModel.fetchCocktailDetail()
        
        XCTAssertEqual(
            cocktailDetailViewModel.model,
            CocktailDetail(
                id: "5962",
                name: "Vodka",
                category: "Ordinary Drink",
                instruction: "Shake and strain into a chilled cocktail glass.",
                drinkThumb: "drinkThumb"
            )
        )
    }
}
