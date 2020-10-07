//
//  EventListViewModel.swift
//  sicredi
//
//  Created by Daniel Rambo on 04/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import UIKit

enum EventListEvent {
    case viewDidApper
    case selectedEvent(UIViewController, Int)
}

enum EventListState {
    case isLoading
    case modalError(Error)
    case updateValues(Values)
    
    struct Values {
        var events: [EventListModel] = []
    }
}

final class EventListViewModel {
    
    // MARK: Init
    
    init() {
        self.repository = EventListRepositoryImplementation()
    }
    
    // MARK: - Loaded Properties
    
    private var events: [EventListModel] = []
    
    // MARK: Properties
    
    private let repository: EventListRepositoryImplementation!
    private var stateValues = EventListState.Values()
    private var observable: ((EventListState) -> Void)?
}

// MARK: - Methods

extension EventListViewModel {
    func send(in event: EventListEvent) {
        switch event {
        case .viewDidApper:
            fetchList()
        case .selectedEvent(let viewController, let index):
            selectedEvent(viewController: viewController, index: index)
        }
    }
    
    func setObservable(observable: @escaping ((EventListState) -> Void)) {
        self.observable = observable
    }
}

// MARK: - Private Methods

private extension EventListViewModel {
    func selectedEvent(viewController: UIViewController, index: Int) {
        let item = events[index]
        tapDetails(in: viewController, event: item)
    }
    
    func fetchList() {
        guard let observable = self.observable else { return }
        observable(.isLoading)
        repository.execute { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    guard let observable = self.observable else { return }
                    observable(.modalError(error))
                    return
                }
                
                self.stateValues.events = response ?? []
                self.events = response ?? []
                observable(.updateValues(self.stateValues))
            }
        }
    }
}

// MARK: - Routers

private extension EventListViewModel {
    func tapDetails(in rootViewController: UIViewController, event: EventListModel) {
        let viewModel = EventItemViewModel(idEvent: event.id)
        let viewController = EventItemView(viewModel: viewModel)
        
        rootViewController.navigationController?.pushViewController(viewController, animated: true)
    }
}
