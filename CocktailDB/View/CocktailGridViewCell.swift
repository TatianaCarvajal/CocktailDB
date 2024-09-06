//
//  CocktailGridViewCell.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 30/07/24.
//

import UIKit

class CocktailGridViewCell: UICollectionViewCell {
    static let identifier = "CocktailGridViewCell"
    
    // MARK: - UI Components
    private var cocktailImage: UIImageView = {
        let cocktailImage = UIImageView()
        cocktailImage.translatesAutoresizingMaskIntoConstraints = false
        cocktailImage.contentMode = .scaleAspectFill
        cocktailImage.image = UIImage(systemName: "questionMark")
        cocktailImage.clipsToBounds = true
        return cocktailImage
    }()
    
    private var cocktailTitle: UILabel = {
        let cocktailTitle = UILabel()
        cocktailTitle.translatesAutoresizingMaskIntoConstraints = false
        cocktailTitle.font = .systemFont(ofSize: 16, weight: .bold)
        cocktailTitle.textColor = .white
        cocktailTitle.numberOfLines = 0
        cocktailTitle.textAlignment = .center
        cocktailTitle.sizeToFit()
        return cocktailTitle
    }()
    
    
    // MARK: - UI Setup
    func setupCocktailImage() {
        self.contentView.addSubview(cocktailImage)
        NSLayoutConstraint.activate([
            cocktailImage.topAnchor.constraint(equalTo: self.topAnchor),
            cocktailImage.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 50) / 2),
            cocktailImage.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setupCocktailTitle() {
        self.contentView.addSubview(cocktailTitle)
        NSLayoutConstraint.activate([
            cocktailTitle.topAnchor.constraint(lessThanOrEqualTo: cocktailImage.bottomAnchor, constant: 2),
            cocktailTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            cocktailTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            cocktailTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
    
    func configureCell(cocktail: CocktailThumbnail) async {
        setupCocktailImage()
        setupCocktailTitle()
        cocktailTitle.text = cocktail.drink
        await cocktailImage.load(url: cocktail.image)
    }
}

extension UIImageView {
    @MainActor
    func load(url: URL?) async {
        guard let url = url else {
            return
        }
        
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            return
        }
        image = UIImage(data: data)
    }
}
