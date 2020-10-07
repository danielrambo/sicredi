//
//  CustomButtom.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import UIKit

final class CustomButtom: UIButton {
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: - Settings
    
    private struct Constants {
        static let contentSpace: CGFloat = 8.0
    }
    
    // MARK: - Properties
    
    private var touchUpInsideClosure: (() -> Void)?
    private var contentSubview: UIView?
}

// MARK: - Override

extension CustomButtom {
    override var isHighlighted: Bool {
        didSet {
            let newAlpha: CGFloat = isEnabled ? isHighlighted ? 0.8 : 1.0 : 0.65
            contentSubview?.alpha = newAlpha
            alpha = newAlpha
            let scale = CGAffineTransform.identity.scaledBy(x: 0.985, y: 0.985)
            transform = isHighlighted ? scale : .identity
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            isUserInteractionEnabled = isEnabled
            let newAlpha: CGFloat = isEnabled ? 1.0 : 0.65
            contentSubview?.alpha = newAlpha
            alpha = newAlpha
        }
    }
}

// MARK: - Private Methods

private extension CustomButtom {
    func edgeInsetsForImageAndTitle(adjust: Bool) {
        if adjust {
            imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: Constants.contentSpace)
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: Constants.contentSpace, bottom: 0.0, right: 0.0)
        } else {
            imageEdgeInsets = .zero
            titleEdgeInsets = .zero
        }
    }
    
    func setTitle(_ text: String?) {
        setTitle(text, for: .normal)
        setTitle(text, for: .highlighted)
        
        if text == nil {
            edgeInsetsForImageAndTitle(adjust: false)
        } else if titleLabel?.text != nil {
            edgeInsetsForImageAndTitle(adjust: true)
        }
    }
    
    func setTitleColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .highlighted)
    }
}

// MARK: - Public Methods

extension CustomButtom {
    func setupDefaultStyle(with title: String, height: CGFloat = 50.0) {
        setTitle(title)
        setTitleColor(.white)
        backgroundColor = UIColor(red: 0, green: 0.341, blue: 0.475, alpha: 1)
        heightAnchor.constraint(equalToConstant: height).isActive = true
        layer.cornerRadius = 10.0
        tintColor = .white
    }
    
    func setupOutlineStyle(with title: String, height: CGFloat = 50.0) {
        setTitle(title)
        setTitleColor(UIColor(red: 0, green: 0.341, blue: 0.475, alpha: 1))
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: height).isActive = true
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(red: 0, green: 0.341, blue: 0.475, alpha: 1).cgColor
        layer.borderWidth = 1.0
        tintColor = UIColor(red: 0, green: 0.341, blue: 0.475, alpha: 1)
    }
    
    func observeTouchUpInside(_ closure: @escaping () -> Void) {
        touchUpInsideClosure = closure
        addTarget(self, action: #selector(touchUpInsideClosureAction), for: .touchUpInside)
    }
    
    @objc private func touchUpInsideClosureAction() {
        touchUpInsideClosure?()
    }
    
    func setContent(_ subview: UIView) {
        subview.isUserInteractionEnabled = false
        contentSubview?.removeFromSuperview()
        contentSubview = subview
        embed(newView: subview)
    }
}
