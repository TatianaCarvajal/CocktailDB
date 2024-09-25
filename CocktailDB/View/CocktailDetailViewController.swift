//
//  CocktailDetailViewController.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 6/09/24.
//

import Foundation
import UIKit
import Combine

class CocktailDetailViewController: UIViewController {
    var viewModel: CocktailDetailViewModel
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    lazy var cocktailImageView: UIImageView = {
        let cocktailImageView = UIImageView(frame: UIScreen.main.bounds)
        cocktailImageView.image = UIImage(named: "wood.jpg")
        cocktailImageView.contentMode = .scaleToFill
        return cocktailImageView
    }()
    
    lazy var cocktailImage: UIImageView = {
        let cocktailImage = UIImageView()
        cocktailImage.image = UIImage(systemName: "questionMark")
        cocktailImage.clipsToBounds = true
        cocktailImage.translatesAutoresizingMaskIntoConstraints = false
        return cocktailImage
    }()
    
    lazy var cocktailTitleLabel: UILabel = {
        let cocktailTitle = UILabel()
        cocktailTitle.translatesAutoresizingMaskIntoConstraints = false
        cocktailTitle.font = .systemFont(ofSize: 28, weight: .bold)
        cocktailTitle.textColor = .white
        cocktailTitle.numberOfLines = 0
        cocktailTitle.textAlignment = .center
        cocktailTitle.sizeToFit()
        return cocktailTitle
    }()
    
    var cocktailInformationLabel: UILabel = {
        let cocktailInformation = UILabel()
        cocktailInformation.translatesAutoresizingMaskIntoConstraints = false
        cocktailInformation.font = .systemFont(ofSize: 20, weight: .semibold)
        cocktailInformation.textColor = .white
        cocktailInformation.numberOfLines = 0
        cocktailInformation.textAlignment = .justified
        // cocktailInformation.sizeToFit()
        return cocktailInformation
    }()
    
    lazy var ingredientsTitleLabel: UILabel = {
        let ingredientsTitle = UILabel()
        let underlineAttriString = NSAttributedString(
            string: "Ingredients",
            attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        ingredientsTitle.attributedText = underlineAttriString
        ingredientsTitle.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTitle.font = .italicSystemFont(ofSize: 24)
        ingredientsTitle.textColor = .white
        ingredientsTitle.textAlignment = .left
        return ingredientsTitle
    }()
    
    lazy var cocktailIngredientsStackView: UIStackView = {
        let cocktailStackView = UIStackView()
        cocktailStackView.translatesAutoresizingMaskIntoConstraints = false
        cocktailStackView.axis = .vertical
        cocktailStackView.distribution = .fillEqually
        return cocktailStackView
    }()
    
    
    lazy var detailScrollView: UIScrollView = {
        let detailScrollView = UIScrollView()
        detailScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return detailScrollView
    }()
    
    lazy var loaderView: SpinnerView = {
        let loaderView = SpinnerView()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        return loaderView
    }()
    
    // MARK: - Init
    init(viewModel: CocktailDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        self.setupDetailScrollView()
        self.setupCocktailTitle()
        self.setupCocktailImage()
        self.setupCocktailInformation()
        self.setupIngredientsTitle()
        self.setupCocktailIngredientsStackView()
        self.setupSubscribers()
        Task {
            await viewModel.fetchCocktailDetail()
        }
    }
    
    func setupSubscribers() {
        self.viewModel.$model.sink { [weak self] model in
            guard let self = self else {
                return
            }
            Task {
                await self.cocktailImage.load(url: model?.image)
            }
            self.cocktailTitleLabel.text = model?.name
            self.cocktailInformationLabel.text = model?.instruction
            if let firstIngredient = model?.firstIngredient {
                let ingredientLabel = self.createCocktailIngredientsLabel(ingredient: firstIngredient)
                self.cocktailIngredientsStackView.addArrangedSubview(ingredientLabel)
            }
            if let secondIngredient = model?.secondIngredient {
                let ingredientLabel = self.createCocktailIngredientsLabel(ingredient: secondIngredient)
                self.cocktailIngredientsStackView.addArrangedSubview(ingredientLabel)
            }
            if let thirdIngredient = model?.thirdIngredient {
                let ingredientLabel = self.createCocktailIngredientsLabel(ingredient: thirdIngredient)
                self.cocktailIngredientsStackView.addArrangedSubview(ingredientLabel)
            }
            if let fourthIngredient = model?.fourthIngredient {
                let ingredientLabel = self.createCocktailIngredientsLabel(ingredient: fourthIngredient)
                self.cocktailIngredientsStackView.addArrangedSubview(ingredientLabel)
            }
            if let fifthIngredient = model?.fifthIngredient {
                let ingredientLabel = self.createCocktailIngredientsLabel(ingredient: fifthIngredient)
                self.cocktailIngredientsStackView.addArrangedSubview(ingredientLabel)
            }
        }
        .store(in: &cancellables)
        
        self.viewModel.$error
            .sink { error in
                let errorScreen = ErrorView(error ?? "") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    func createCocktailIngredientsLabel(ingredient: String) -> UILabel {
        let cocktailIngredientsLabel = UILabel()
        cocktailIngredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        cocktailIngredientsLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        cocktailIngredientsLabel.textColor = .white
        cocktailIngredientsLabel.numberOfLines = 0
        cocktailIngredientsLabel.text = ingredient
        return cocktailIngredientsLabel
    }
    
    // MARK: - UI Setup
    func setupCocktailImage() {
        detailScrollView.addSubview(cocktailImage)
        NSLayoutConstraint.activate(
            [
                cocktailImage.topAnchor.constraint(equalTo: cocktailTitleLabel.bottomAnchor, constant: 10),
                cocktailImage.centerXAnchor.constraint(equalTo: detailScrollView.centerXAnchor),
                cocktailImage.widthAnchor.constraint(equalToConstant: 250),
                cocktailImage.heightAnchor.constraint(equalToConstant: 220)
            ]
        )
    }
    
    func setupCocktailTitle() {
        detailScrollView.addSubview(cocktailTitleLabel)
        NSLayoutConstraint.activate(
            [
                cocktailTitleLabel.topAnchor.constraint(equalTo: detailScrollView.safeAreaLayoutGuide.topAnchor),
                cocktailTitleLabel.leadingAnchor.constraint(equalTo: detailScrollView.leadingAnchor),
                cocktailTitleLabel.trailingAnchor.constraint(equalTo: detailScrollView.trailingAnchor),
            ]
        )
    }
    
    func setupCocktailInformation() {
        detailScrollView.addSubview(cocktailInformationLabel)
        NSLayoutConstraint.activate(
            [
                cocktailInformationLabel.topAnchor.constraint(equalTo: cocktailImage.bottomAnchor, constant: 20),
                cocktailInformationLabel.leadingAnchor.constraint(equalTo: detailScrollView.leadingAnchor, constant: 20),
                cocktailInformationLabel.trailingAnchor.constraint(equalTo: detailScrollView.trailingAnchor, constant: -20)
            ]
        )
    }
    
    func setupIngredientsTitle() {
        detailScrollView.addSubview(ingredientsTitleLabel)
        NSLayoutConstraint.activate(
            [
                ingredientsTitleLabel.topAnchor.constraint(equalTo: cocktailInformationLabel.bottomAnchor, constant: 20),
                ingredientsTitleLabel.leadingAnchor.constraint(equalTo: detailScrollView.leadingAnchor, constant: 20),
                ingredientsTitleLabel.trailingAnchor.constraint(equalTo: detailScrollView.trailingAnchor)
            ]
        )
        
    }
    
    func setupCocktailIngredientsStackView() {
        detailScrollView.addSubview(cocktailIngredientsStackView)
        NSLayoutConstraint.activate(
            [
                cocktailIngredientsStackView.topAnchor.constraint(equalTo: ingredientsTitleLabel.bottomAnchor, constant: 20),
                cocktailIngredientsStackView.leadingAnchor.constraint(equalTo: detailScrollView.leadingAnchor, constant: 20),
                cocktailIngredientsStackView.trailingAnchor.constraint(equalTo: detailScrollView.trailingAnchor, constant: -20),
            ]
        )
    }
    
    
    func setupDetailScrollView() {
        detailScrollView.insertSubview(cocktailImageView, at: 0)
        view.addSubview(detailScrollView)
        NSLayoutConstraint.activate(
            [
                detailScrollView.topAnchor.constraint(equalTo: view.topAnchor),
                detailScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                detailScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                detailScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}
