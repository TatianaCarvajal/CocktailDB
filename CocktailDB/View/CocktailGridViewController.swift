//
//  CocktailGridViewController.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 17/06/24.
//

import UIKit
import Combine

class CocktailGridViewController: UIViewController {
    var viewModel: CocktailGridViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CocktailGridViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.setupSearchBarView()
        self.setupCategoryStackView()
//        self.setupCocktailGridView()
        self.setupSubscribers()
        Task {
            await self.viewModel.viewDidLoad()
        }
    }
    
    func setupSubscribers() {
        self.viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case .loading:
                    print("Voy a mostrar estado de cargando")
                case .error(let error):
                    print("Voy a mostrar estado de error")
                case .idle:
                    break
                case .loaded(let model):
                    print("Voy a cargar la vista con searchbar, grid, y categories")
                    self?.setupCategoryStack(categories: model.categories)
                case .loadedCocktails(let cocktails):
                    print("tengo que a navegar al detalle")
                    break
                }
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - UI Components
    lazy var cocktailGrid: UICollectionView = {
        let cocktailGrid = UICollectionView()
        cocktailGrid.translatesAutoresizingMaskIntoConstraints = false
        cocktailGrid.dataSource = self
        //cocktailGrid.delegate = self
        return cocktailGrid
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search a cocktail"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        return searchBar
    }()
    
    lazy var categoryStackView: UIStackView = {
        let categoryStackView = UIStackView()
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        categoryStackView.axis = .horizontal
        categoryStackView.distribution = .fillEqually
        categoryStackView.spacing = 15
        return categoryStackView
    }()
    
    // MARK: - UI Setup
    func setupCocktailGridView() {
        view.addSubview(cocktailGrid)
        NSLayoutConstraint.activate([
            cocktailGrid.topAnchor.constraint(equalTo: view.topAnchor),
            cocktailGrid.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupSearchBarView() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupCategoryStack(categories: [CocktailCategory]) {
        categoryStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        categories.forEach { cocktailCategory in
            let button = CategoryButton(title: cocktailCategory.category) { [weak self] category in
                print("me tocaroooon soy \(category)")
                Task {
                    await self?.viewModel.fetchCocktailThumbnail(category: category)
                }
            }
            categoryStackView.addArrangedSubview(button)
        }
    }
    
    func setupCategoryStackView() {
        let categoriesScrollView = UIScrollView()
        categoriesScrollView.translatesAutoresizingMaskIntoConstraints = false
        categoriesScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(categoriesScrollView)
        categoriesScrollView.addSubview(categoryStackView)
        
        NSLayoutConstraint.activate([
            categoriesScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            categoriesScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoriesScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoriesScrollView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            categoryStackView.topAnchor.constraint(equalTo: categoriesScrollView.topAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: categoriesScrollView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: categoriesScrollView.trailingAnchor),
            categoryStackView.heightAnchor.constraint(equalTo: categoriesScrollView.heightAnchor)
        ])
    }
}

// MARK: - CollectionView Functions
extension CocktailGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.model?.cocktails.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

