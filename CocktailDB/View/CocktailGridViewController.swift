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
    
    // MARK: - UI Components
    lazy var cocktailGrid: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cocktailGrid = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cocktailGrid.translatesAutoresizingMaskIntoConstraints = false
        cocktailGrid.dataSource = self
        cocktailGrid.delegate = self
        cocktailGrid.backgroundColor = .clear
        cocktailGrid.register(CocktailGridViewCell.self, forCellWithReuseIdentifier: CocktailGridViewCell.identifier)
        return cocktailGrid
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search a cocktail"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .white.withAlphaComponent(0.8)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
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
    
    lazy var cocktailImageView: UIImageView = {
        let cocktailImageView = UIImageView(frame: UIScreen.main.bounds)
        cocktailImageView.image = UIImage(named: "wood.jpg")
        cocktailImageView.contentMode = .scaleToFill
        return cocktailImageView
    }()
    
    lazy var loaderView: SpinnerView = {
        let loaderView = SpinnerView()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        return loaderView
    }()
    
    // MARK: - Init
    init(viewModel: CocktailGridViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(cocktailImageView, at: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.setupSearchBarView()
        self.setupCategoryStackView()
        self.setupCocktailGridView()
        self.setupSubscribers()
        Task {
            await self.viewModel.viewDidLoad()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupSubscribers() {
        self.viewModel.$model
            .sink { [weak self] model in
                self?.setupCategoryStack(categories: model.categories)
                self?.cocktailGrid.reloadData()
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$destination
            .sink { [weak self] destination in
                switch destination {
                case let .showErrorAlert(error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    self?.present(alert, animated: true)
                    
                case let .showErrorScreen(error):
                    let errorScreen = ErrorView(error.errorDescription ?? "") {
                        Task {
                            await self?.viewModel.viewDidLoad()
                        }
                    }
                    self?.setupErrorScreen(errorView: errorScreen)
                case let .showSearchCocktailList(cocktailList):
                    print(cocktailList)
                case .none: break
                }
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$isLoading
            .sink { [weak self] value in
                value ? self?.showLoader() : self?.hideLoader()
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - UI Setup
    func setupCocktailGridView() {
        view.addSubview(cocktailGrid)
        NSLayoutConstraint.activate([
            cocktailGrid.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 20),
            cocktailGrid.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            cocktailGrid.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cocktailGrid.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    func setupSearchBarView() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            searchBar.heightAnchor.constraint(equalToConstant: 42),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    func setupCategoryStack(categories: [CocktailCategory]) {
        categoryStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        categories.forEach { cocktailCategory in
            let button = CategoryButton(title: cocktailCategory.category) { [weak self] category in
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
    
    func showLoader() {
        view.addSubview(loaderView)
        loaderView.showLoader()
        NSLayoutConstraint.activate([
            loaderView.topAnchor.constraint(equalTo: view.topAnchor),
            loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func hideLoader() {
        loaderView.hideLoader()
        NSLayoutConstraint.deactivate(loaderView.constraints)
        loaderView.removeFromSuperview()
    }
    
    func setupErrorScreen(errorView: ErrorView) {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
// MARK: - SearchBar Functions
extension CocktailGridViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Task {
            guard let query = searchBar.text else {
                return
            }
            await viewModel.fetchCocktailByName(name: query)
        }
    }
}

// MARK: - CollectionView Functions
extension CocktailGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model.cocktails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailGridViewCell.identifier, for: indexPath) as? CocktailGridViewCell,
              let cocktail = viewModel.getCocktailByPosition(indexPath.item) else {
            return UICollectionViewCell()
        }
        Task {
            await cell.configureCell(cocktail: cocktail)
        }
        return cell
    }
}

extension CocktailGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel.getCocktailByPosition(indexPath.row)?.id else {
            return
        }
        let viewModel = CocktailDetailViewModel(service: CocktailServiceFacade(), id: id)
        let viewController = CocktailDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CocktailGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let innerPadding: CGFloat = 10
        let width = (collectionView.frame.size.width - innerPadding) / 2
        return CGSize(width: width, height: 250)
    }
}
