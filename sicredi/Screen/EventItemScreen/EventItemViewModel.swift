//
//  EventItemViewModel.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import UIKit

enum EventItemViewEvent {
    case viewDidApper
    case tapCheck(UIViewController)
    case tapShared
}

enum EventItemState {
    case isLoading
    case modalError(Error)
    case shared(String)
    case updateValues(Values)
    
    struct Values {
        var title: String?
        var description: String?
        var image: UIImage?
        var date: String?
        var price: String?
    }
}

final class EventItemViewModel {
    
    // MARK: Init
    
    init(idEvent: String) {
        self.idEvent = idEvent
        self.repository = EventItemRepositoryImplementation()
    }
    
    // MARK: - Loaded Properties
    
    private var event: EventItemModel?
    
    // MARK: Properties
    
    private let idEvent: String!
    private let repository: EventItemRepositoryImplementation!
    private var stateValues = EventItemState.Values()
    private var observable: ((EventItemState) -> Void)?
}

// MARK: - Methods

extension EventItemViewModel {
    func send(in event: EventItemViewEvent) {
        switch event {
        case .viewDidApper:
            fetchEvent()
        case .tapCheck(let viewController):
            tapCheckin(in: viewController)
        case .tapShared:
            tapShared()
        }
    }
    
    func setObservable(observable: @escaping ((EventItemState) -> Void)) {
        self.observable = observable
    }
}

// MARK: - Private Methods

private extension EventItemViewModel {
    
    func fetchEvent() {
        guard let observable = self.observable else { return }
        observable(.isLoading)
        repository.execute(idEvent: idEvent) { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    guard let observable = self.observable else { return }
                    observable(.modalError(error))
                    return
                }
                
                guard let result = response else { return }
                self.event = result
                self.stateValues.date = Date(timeIntervalSince1970: Double(result.date)).stringFormatted()
                self.stateValues.description = result.description
                self.stateValues.title = result.title
                self.stateValues.price = String(result.price).currencyPtBRFormatted
                
                DispatchQueue.global().async {
                    if let url = URL(string: result.image) {
                        if let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                self.stateValues.image = UIImage(data: data)
                                observable(.updateValues(self.stateValues))
                            }
                        } else {
                            DispatchQueue.main.async {
                                observable(.modalError(EventItemError.imageNotFound))
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            observable(.modalError(EventItemError.imageNotFound))
                        }
                    }
                }
            }
        }
    }
    
    func tapShared() {
        guard let result = event else { return }
        let text = """
        \(result.title)
        \(String(result.price).currencyPtBRFormatted ?? "R$ 0,00") - \
        \(Date(timeIntervalSince1970: Double(result.date)).stringFormatted())
        \(result.description)
        """
        
        guard let observable = self.observable else { return }
        observable(.shared(text))
    }
}

// MARK: - Routers

private extension EventItemViewModel {
    func tapCheckin(in rootViewController: UIViewController) {
        let viewModel = EventCheckinViewModel(idEvent: idEvent)
        let viewController = EventCheckinView(viewModel: viewModel)
        rootViewController.navigationController?.present(viewController, animated: true, completion: nil)
    }
}

