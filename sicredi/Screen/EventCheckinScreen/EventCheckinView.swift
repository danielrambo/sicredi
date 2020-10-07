//
//  EventCheckinView.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import UIKit

final class EventCheckinView: CustomViewController {
    
    // MARK: Init
    
    init(viewModel: EventCheckinViewModel) {
        super.init()
        
        self.viewModel = viewModel
    }
    
    required public init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Property
    
    private var viewModel: EventCheckinViewModel!
    private var fields: [EventCheckinField: UITextField] = [:]
}

// MARK: - Public Methods

extension EventCheckinView {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObserver()
        setupInitial()
    }
}

// MARK: - Layout

private extension EventCheckinView {
    func setupInitial() {
        let stackView = buildMainStackView(scrollViewEnabled: true)
        stackView.axis = .vertical
        stackView.spacing = 15.0
        
        setupTitle(in: stackView)
        setupLine(in: stackView, labelText: .name, placeholder: .placeholderName, field: .name)
        setupLine(in: stackView, labelText: .email, placeholder: .placeholderEmail, field: .email)
        setupActions(in: stackView)
    }
    
    func setupTitle(in stackView: UIStackView) {
        let labelTitle = UILabel()
        labelTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        labelTitle.textAlignment = .center
        labelTitle.numberOfLines = 0
        labelTitle.text = .title
        
        let viewContainer = UIView()
        viewContainer.embed(newView: labelTitle, padding: .all16)
        
        stackView.addArrangedSubview(viewContainer)
    }
    
    func setupLine(in stackView: UIStackView, labelText: String, placeholder: String, field: EventCheckinField) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = labelText
        
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = placeholder
        textField.textAlignment = .right
        textField.keyboardType = .default
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.tag = field.hashValue
        textField.addTarget(self, action: #selector(editingChangedClosureAction(sender:)), for: .editingChanged)
        fields[field] = textField
        
        let stackViewHorizontal = UIStackView()
        stackViewHorizontal.axis = .horizontal
        stackViewHorizontal.addArrangedSubview(label)
        stackViewHorizontal.addArrangedSubview(textField)
        
        stackView.addArrangedSubview(stackViewHorizontal)
    }
    
    @objc func editingChangedClosureAction(sender: UITextField) {
        var field: EventCheckinField!
        for (key, textField) in fields {
            if textField == sender {
                field = key
            }
        }
        
        self.viewModel.send(in: .setValue(field, sender))
    }
    
    func setupActions(in stackView: UIStackView) {
        let buttonConfirm = CustomButtom()
        buttonConfirm.setupDefaultStyle(with: .confirm)
        buttonConfirm.observeTouchUpInside { [weak self] in
            guard let self = self else { return }
            self.viewModel.send(in: .tapConfirm(self))
        }
        
        let buttonCancel = CustomButtom()
        buttonCancel.setupOutlineStyle(with: .cancel)
        buttonCancel.observeTouchUpInside { [weak self] in
            guard let self = self else { return }
            self.viewModel.send(in: .didClose(self))
        }
        
        stackView.addArrangedSubview(buttonConfirm)
        stackView.addArrangedSubview(buttonCancel)
    }
}


// MARK: - ViewModel

private extension EventCheckinView {
    func setupObserver() {
        viewModel.setObservable { state in
            switch state {
            case .isLoading:
                self.toggleLoading(true)
                
            case .modalError(let error):
                self.toggleLoading(false)
                self.presentAlert(error: error)
            }
        }
    }
}

// MARK: String

fileprivate extension String {
    static let title = "Check-in"
    static let confirm = "Confirmar"
    static let cancel = "Cancelar"
    static let name = "Nome"
    static let email = "E-mail"
    static let placeholderName = "Digite seu nome"
    static let placeholderEmail = "Digite seu e-mail"
}
