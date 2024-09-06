//
//  ErrorView.swift
//  CocktailDB
//
//  Created by Tatiana Carvajal on 22/08/24.
//

import Foundation
import UIKit

class ErrorView: UIView {
    lazy var errorImageView: UIImageView = {
        let errorImageView = UIImageView(frame: UIScreen.main.bounds)
        errorImageView.image = UIImage(named: "spillingLiquid")
        errorImageView.contentMode = .scaleToFill
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        return errorImageView
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = .systemFont(ofSize: 20, weight: .bold)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        return messageLabel
    }()
    
    lazy var tryAgainButton: UIButton = {
        let tryAgainButton = UIButton()
        tryAgainButton.setTitle("Try Again", for: .normal)
        tryAgainButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        tryAgainButton.setTitleColor(.black, for: .normal)
        tryAgainButton.backgroundColor = .white.withAlphaComponent(0.8)
        tryAgainButton.layer.cornerRadius = 8
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.addTarget(self, action: #selector(pressed(_:)), for: .touchUpInside)
        return tryAgainButton
    }()
    
    let retryAction: () -> Void
    
    init(_ error: String, retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
        super.init(frame: .zero)
        self.messageLabel.text = error
        
        setupErrorImageView()
        setupMessageLabel()
        setupTryAgainButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pressed(_ sender: UIButton) {
        removeFromSuperview()
        retryAction()
    }
    
    func setupErrorImageView() {
        addSubview(errorImageView)
        NSLayoutConstraint.activate(
            [
                errorImageView.topAnchor.constraint(equalTo: topAnchor),
                errorImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                errorImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                errorImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
    func setupMessageLabel() {
        addSubview(messageLabel)
        NSLayoutConstraint.activate(
            [
                messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 120),
                messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ]
        )
    }
    
    func setupTryAgainButton() {
        addSubview(tryAgainButton)
        NSLayoutConstraint.activate(
            [
                tryAgainButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40),
                tryAgainButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
                tryAgainButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60)
            ]
        )
    }
}
