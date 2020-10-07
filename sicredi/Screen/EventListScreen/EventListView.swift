//
//  EventListView.swift
//  sicredi
//
//  Created by Daniel Rambo on 04/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import UIKit

final class EventListView: CustomViewController {
    
    // MARK: Init
    
    init(viewModel: EventListViewModel) {
        super.init()
        
        self.viewModel = viewModel
    }
    
    required public init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Property
    
    private var viewModel: EventListViewModel!
    private var events: [EventListModel] = []
    private var tableView: UITableView!
}

// MARK: - Public Methods

extension EventListView {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObserver()
        setupInitial()
    }
}

// MARK: - Layout

private extension EventListView {
    func setupInitial() {
        title = .title
        
        let stackView = buildMainStackView(scrollViewEnabled: false, padding: .zero)
        stackView.axis = .vertical
        stackView.spacing = 0.0
        
        setupTableView(in: stackView)
        viewModel.send(in: .viewDidApper)
    }
    
    func setupTableView(in stackView: UIStackView) {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(EventListTableViewCell.self,
                 forCellReuseIdentifier: "EventListTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
        
        stackView.addArrangedSubview(tableView)
    }
}

// MARK: - Delegate

extension EventListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventListTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "EventListTableViewCell",
            for: indexPath
        ) as! EventListTableViewCell
        
        let item = events[indexPath.row]
        cell.setup(event: item.title, image: item.image)
        cell.observeSelectedIndex { [weak self] in
            guard let self = self else { return }
            self.viewModel.send(in: .selectedEvent(self, indexPath.row))
        }
        
        return cell
    }
}


// MARK: - ViewModel

private extension EventListView {
    func setupObserver() {
        viewModel.setObservable { state in
            switch state {
            case .isLoading:
                self.toggleLoading(true)
                
            case .modalError(let error):
                self.toggleLoading(false)
                self.presentAlert(error: error)
                
            case .updateValues(let values):
                self.toggleLoading(false)
                self.events = values.events
                self.tableView.reloadData()
                
            }
        }
    }
}

// MARK: String

fileprivate extension String {
    static let title = "Lista de Eventos"
}
