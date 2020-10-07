//
//  EventCheckinViewModel.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import UIKit

enum EventCheckinEvent {
    case setValue(EventCheckinField, UITextField)
    case tapConfirm(UIViewController)
    case didClose(UIViewController)
}

enum EventCheckinState {
    case isLoading
    case modalError(Error)
}

enum EventCheckinField: Int {
    case name = 1
    case email = 2
}

final class EventCheckinViewModel {
    
    // MARK: Init
    
    init(idEvent: String) {
        self.idEvent = idEvent
        self.repository = EventCheckinRepositoryImplementation()
    }
    
    // MARK: - Loaded Properties
    
    private var fields: [EventCheckinField: String] = [:]
    
    // MARK: Properties
    
    private let idEvent: String!
    private let repository: EventCheckinRepositoryImplementation!
    private var observable: ((EventCheckinState) -> Void)?
}

// MARK: - Methods

extension EventCheckinViewModel {
    func send(in event: EventCheckinEvent) {
        switch event {
        case .setValue(let field, let textField):
            setValue(field: field, textField: textField)
        case .tapConfirm(let viewController):
            tapConfirm(in: viewController)
        case .didClose(let viewController):
            didClose(in: viewController)
        }
    }
    
    func setObservable(observable: @escaping ((EventCheckinState) -> Void)) {
        self.observable = observable
    }
}

// MARK: - Private Methods

private extension EventCheckinViewModel {
    func setValue(field: EventCheckinField, textField: UITextField) {
        if let text = textField.text {
            fields[field] = text
        }
    }
    
    func validateForm() {
        var isError: Bool = false
        for (_, text) in fields {
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                isError = true
            }
        }
        
        if fields.count == 0 {
            isError = true
        }
        
        guard let observable = observable else { return }
        if isError {
            observable(.modalError(EventCheckinError.empty))
            return
        }
        
        guard let email = fields[.email] else { return }
        if email.isValidEmail == false {
            observable(.modalError(EventCheckinError.invalidEmail))
            return
        }
    }
    
    func tapConfirm(in rootViewController: UIViewController) {
        validateForm()
        
        guard let name = fields[.name] else { return }
        guard let email = fields[.email] else { return }
        
        guard let observable = self.observable else { return }
        observable(.isLoading)
        
        let model = EventCheckinModel(id: idEvent, name: name, email: email)
        repository.execute(checkin: model) { error in
            DispatchQueue.main.async {
                if let error = error {
                    observable(.modalError(error))
                    return
                }
                
                self.didClose(in: rootViewController)
            }
        }
    }
}

// MARK: - Router

private extension EventCheckinViewModel {
    func didClose(in rootViewController: UIViewController) {
        rootViewController.dismiss(animated: true, completion: nil)
    }
}
