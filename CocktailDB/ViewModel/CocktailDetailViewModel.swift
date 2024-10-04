//
//  CocktailDetailViewModel.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 10/09/24.
//

import Foundation

@MainActor
class CocktailDetailViewModel {
    
    private let service: CocktailServiceProtocol
    private let id: String
    @Published var isLoading = false
    @Published var model: CocktailDetail?
    @Published var error: String?
   
    init(service: CocktailServiceProtocol, id: String) {
        self.service = service
        self.id = id
    }
    
    func fetchCocktailDetail() async {
        isLoading = true
        do {
            self.model = try await service.fetchCocktailDetail(id: id).drinks.first
        }
        catch {
            self.error = "Sorry, something went wrong with the detail, please try again later"
        }
        isLoading = false
    }
}
