//
//  CocktailSearchListViewController.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 10/10/24.
//

import Foundation
import UIKit

class CocktailSearchListViewController: UIViewController {
    private let cocktails: [CocktailDetail]
    
    // MARK: - UI Components
    private let cocktailBackgroundImage = UIImage(named: "wood.jpg") ?? .init()
    
    lazy var cocktailGridView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cocktailGridView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        cocktailGridView.translatesAutoresizingMaskIntoConstraints = false
        cocktailGridView.dataSource = self
        cocktailGridView.delegate = self
        cocktailGridView.backgroundColor = .clear
        cocktailGridView.showsVerticalScrollIndicator = false
        cocktailGridView.register(CocktailGridViewCell.self, forCellWithReuseIdentifier: CocktailGridViewCell.identifier)
        return cocktailGridView
    }()
    
    // MARK: - Init
    init(cocktails: [CocktailDetail]) {
        self.cocktails = cocktails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCocktailListView()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.view.backgroundColor = UIColor(patternImage: cocktailBackgroundImage)
    }
    
    // MARK: - UI Setup
    func setupCocktailListView() {
        view.addSubview(cocktailGridView)
        NSLayoutConstraint.activate([
            cocktailGridView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            cocktailGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            cocktailGridView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cocktailGridView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
}

// MARK: - CollectionView functions
extension CocktailSearchListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cocktails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailGridViewCell.identifier, for: indexPath) as? CocktailGridViewCell else {
            return UICollectionViewCell()
        }
        let cocktail = cocktails[indexPath.row]
        Task {
            await cell.configureCell(cocktail: CocktailThumbnail(id: cocktail.id, drink: cocktail.name, drinkThumb: cocktail.drinkThumb))
        }
        return cell
    }
}

extension CocktailSearchListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cocktail = cocktails[indexPath.row]
        let detailViewModel = CocktailDetailViewModel(service: CocktailServiceFacade(), id: cocktail.id)
        let detailViewController = CocktailDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension CocktailSearchListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let innerPadding: CGFloat = 10
        let width = (collectionView.frame.size.width - innerPadding) / 2
        return CGSize(width: width, height: 250)
    }
}
