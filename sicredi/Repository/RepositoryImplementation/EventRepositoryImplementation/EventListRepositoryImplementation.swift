//
//  EventListRepositoryImplementation.swift
//  sicredi
//
//  Created by Daniel Rambo on 04/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation

struct EventListRepositoryImplementation {
    
    // MARK: - Init
    
    init() {
        self.remote = URLSessionRemote()
        self.urlRequest = "https://5f5a8f24d44d640016169133.mockapi.io/api/events"
    }
    
    // MARK: - Properties
    
    private var remote: URLSessionRemote!
    private var urlRequest: String!
    
    // MARK: Methods
    
    func execute(onCompletion: @escaping ([EventListModel]?, Error?) -> Void) {
        let request = RemoteServiceRequest(httpMethod: .get,
                                           urlPath: urlRequest,
                                           urlQueries: nil,
                                           httpBody: nil
        )
        
        remote.execute(request: request) { response in
            if let error = response.error {
                onCompletion(nil, error)
                return
            }
             
            do {
                let decodeJSON = try! JSONDecoder().decode([EventListModel].self, from: response.data!)
                onCompletion(decodeJSON, nil)
            } catch {
                onCompletion(nil, error)
            }
        }
    }
}
