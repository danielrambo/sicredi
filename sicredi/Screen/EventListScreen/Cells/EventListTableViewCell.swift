//
//  EventListTableViewCell.swift
//  sicredi
//
//  Created by Daniel Rambo on 06/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import UIKit

final class EventListTableViewCell: UITableViewCell {
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitial()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Properties
    
    private var viewContainerImage: UIView!
    private weak var eventLabel: UILabel?
    private var selectedIndexClosure: (() -> Void)?
}

// MARK: - Method

extension EventListTableViewCell {
    func setup(event: String, image: String) {
        if let label = eventLabel {
            label.text = event
        }
        
        DispatchQueue.global().async {
            if let url = URL(string: image) {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let imageView = UIImageView(image: UIImage(data: data))
                        imageView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
                        imageView.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
                        imageView.contentMode = .scaleAspectFit
                        
                        let stackViewVertical = UIStackView()
                        stackViewVertical.axis = .vertical
                        stackViewVertical.alignment = .leading
                        stackViewVertical.addArrangedSubview(imageView)
                        
                        self.viewContainerImage.embed(newView: stackViewVertical)
                    }
                }
            }
        }
    }
    
    func observeSelectedIndex(_ closure: @escaping () -> Void) {
        selectedIndexClosure = closure
    }
}

// MARK: - Private Method

private extension EventListTableViewCell {
    func setupInitial() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .black
        label.textAlignment = .left
        self.eventLabel = label
        
        let viewContainerImage = UIView()
        viewContainerImage.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        viewContainerImage.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        self.viewContainerImage = viewContainerImage
        
        let stackViewHorizontal = UIStackView()
        stackViewHorizontal.axis = .horizontal
        stackViewHorizontal.spacing = 14.0
        stackViewHorizontal.addArrangedSubview(viewContainerImage)
        stackViewHorizontal.addArrangedSubview(label)
        
        let viewContainer = UIView()
        viewContainer.embed(newView: stackViewHorizontal, padding: .all16)
        
        let stackVertical = UIStackView()
        stackVertical.axis = .vertical
        stackVertical.spacing = 5.0
        stackVertical.addArrangedSubview(viewContainer)
        setupBorder(in: stackVertical)
        
        let buttom = CustomButtom()
        buttom.setContent(stackVertical)
        buttom.observeTouchUpInside { [weak self] in
            guard let self = self else { return }
            guard let selectedIndexClosure = self.selectedIndexClosure else { return }
            selectedIndexClosure()
        }
        
        contentView.embed(newView: buttom)
    }
    
    func setupBorder(in stackView: UIStackView) {
        let viewBorder = UIView()
        viewBorder.backgroundColor = UIColor(red: 0.083, green: 0.083, blue: 0.083, alpha: 1)
        viewBorder.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        stackView.addArrangedSubview(viewBorder)
    }
}
