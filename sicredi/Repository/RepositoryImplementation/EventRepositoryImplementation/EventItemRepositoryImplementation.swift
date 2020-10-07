//
//  EventItemRepositoryImplementation.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation

struct EventItemRepositoryImplementation {
    
    // MARK: - Init
    
    init() {
        self.remote = URLSessionRemote()
        self.urlRequest = "https://5f5a8f24d44d640016169133.mockapi.io/api/events"
    }
    
    // MARK: - Properties
    
    private var remote: URLSessionRemote!
    private var urlRequest: String!
    
    // MARK: Methods
    
    func execute(idEvent: String, onCompletion: @escaping (EventItemModel?, Error?) -> Void) {
        let urlRequestEvent = urlRequest + "/\(idEvent)"
        let request = RemoteServiceRequest(httpMethod: .get,
                                           urlPath: urlRequestEvent,
                                           urlQueries: nil,
                                           httpBody: nil
        )
        
        remote.execute(request: request) { response in
            if let error = response.error {
                onCompletion(nil, error)
                return
            }
             
            do {
                let decodeJSON = try! JSONDecoder().decode(EventItemModel.self, from: response.data!)
                onCompletion(decodeJSON, nil)
            } catch {
                onCompletion(nil, error)
            }
        }
    }
}
