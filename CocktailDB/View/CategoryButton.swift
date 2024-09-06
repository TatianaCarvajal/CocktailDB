//
//  CategoryButton.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 22/07/24.
//

import Foundation
import UIKit

class CategoryButton: UIButton {
    private let title: String
    private let action: (String) -> Void
    
    init(title: String, action: @escaping (String) -> Void) {
        self.title = title
        self.action = action
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        setTitleColor(.black, for: .normal)
        backgroundColor = .white.withAlphaComponent(0.8)
        layer.cornerRadius = 8
        addTarget(self, action: #selector(pressed(_:)), for: .touchUpInside)
    }
    
    @objc private func pressed(_ sender: UIButton) {
        action(title)
    }
}
