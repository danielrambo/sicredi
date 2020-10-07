//
//  EventItemView.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import UIKit

final class EventItemView: CustomViewController {
    
    // MARK: Init
    
    init(viewModel: EventItemViewModel) {
        super.init()
        
        self.viewModel = viewModel
    }
    
    required public init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Property
    
    private var viewModel: EventItemViewModel!
    private weak var viewContainer: UIView!
}

// MARK: - Public Methods

extension EventItemView {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObserver()
        setupInitial()
    }
}

// MARK: - Layout

private extension EventItemView {
    func setupInitial() {
        title = .title
        
        let stackView = buildMainStackView(scrollViewEnabled: true)
        stackView.axis = .vertical
        stackView.spacing = 0.0
        
        let viewContainer = UIView()
        self.viewContainer = viewContainer
        
        stackView.addArrangedSubview(self.viewContainer)
        viewModel.send(in: .viewDidApper)
    }
    
    func setupContainer(values: EventItemState.Values) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        
        setupTitle(in: stackView, text: values.title)
        setupImageView(in: stackView, in: values.image)
        setupPriceAndDate(in: stackView, price: values.price, date: values.date)
        setupDescription(in: stackView, text: values.description)
        setupActions(in: stackView)
        
        viewContainer.embed(newView: stackView)
    }
    
    func setupTitle(in stackView: UIStackView, text: String?) {
        let labelTitle = UILabel()
        labelTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        labelTitle.textAlignment = .center
        labelTitle.numberOfLines = 0
        labelTitle.text = text
        
        stackView.addArrangedSubview(labelTitle)
    }
    
    func setupImageView(in stackView: UIStackView, in image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        imageView.contentMode = .scaleAspectFill
        
        let viewContainerImageView = UIView()
        viewContainerImageView.embed(newView: imageView, padding: .v36)
        
        stackView.addArrangedSubview(viewContainerImageView)
    }
    
    func setupPriceAndDate(in stackView: UIStackView, price: String?, date: String?) {
        let labelPrice = UILabel()
        labelPrice.font = UIFont.systemFont(ofSize: 14.0)
        labelPrice.textAlignment = .left
        labelPrice.numberOfLines = 0
        labelPrice.text = price
        
        let labelDate = UILabel()
        labelDate.font = UIFont.systemFont(ofSize: 14.0)
        labelDate.textAlignment = .left
        labelDate.numberOfLines = 0
        labelDate.text = date
        
        let stackViewHorizontal = UIStackView()
        stackViewHorizontal.axis = .horizontal
        stackViewHorizontal.spacing = 15.0
        stackViewHorizontal.addArrangedSubview(labelPrice)
        stackViewHorizontal.addArrangedSubview(labelDate)
        
        stackView.addArrangedSubview(stackViewHorizontal)
    }
    
    func setupDescription(in stackView: UIStackView, text: String?) {
        let labelDescription = UILabel()
        labelDescription.font = UIFont.systemFont(ofSize: 14.0)
        labelDescription.textAlignment = .left
        labelDescription.numberOfLines = 0
        labelDescription.text = text
        
        stackView.addArrangedSubview(labelDescription)
    }
    
    func setupActions(in stackView: UIStackView) {
        let buttonCheck = CustomButtom()
        buttonCheck.setupDefaultStyle(with: .check)
        buttonCheck.observeTouchUpInside { [weak self] in
            guard let self = self else { return }
            self.viewModel.send(in: .tapCheck(self))
        }
        
        let buttonShared = CustomButtom()
        buttonShared.setupOutlineStyle(with: .shared)
        buttonShared.observeTouchUpInside { [weak self] in
            guard let self = self else { return }
            self.viewModel.send(in: .tapShared)
        }
        
        stackView.addArrangedSubview(buttonCheck)
        stackView.addArrangedSubview(buttonShared)
    }
}


// MARK: - ViewModel

private extension EventItemView {
    func setupObserver() {
        viewModel.setObservable { state in
            switch state {
            case .isLoading:
                self.toggleLoading(true)
                
            case .modalError(let error):
                self.toggleLoading(false)
                self.presentAlert(error: error)
                
            case .shared(let text):
                let items = [text]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
                
            case .updateValues(let values):
                self.toggleLoading(false)
                self.setupContainer(values: values)
                
            }
        }
    }
}

// MARK: String

fileprivate extension String {
    static let title = "Evento"
    static let check = "Checkin"
    static let shared = "Compartilhar"
}
