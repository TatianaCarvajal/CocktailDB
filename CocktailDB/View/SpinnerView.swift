//
//  SpinnerView.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 20/08/24.
//

import Foundation
import UIKit

class SpinnerView: UIView {
    lazy var loaderView: UIActivityIndicatorView = {
        let loaderView = UIActivityIndicatorView(style: .large)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.color = .white
        return loaderView
    }()
    
    lazy var cocktailImageView: UIImageView = {
        let cocktailImageView = UIImageView(frame: UIScreen.main.bounds)
        cocktailImageView.image = UIImage(named: "wood.jpg")
        cocktailImageView.contentMode = .scaleToFill
        return cocktailImageView
    }()
    
    func showLoader() {
        self.insertSubview(cocktailImageView, at: 0)
        addSubview(loaderView)
        loaderView.startAnimating()
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func hideLoader() {
        loaderView.stopAnimating()
        NSLayoutConstraint.deactivate(loaderView.constraints)
        loaderView.removeFromSuperview()
    }
}
