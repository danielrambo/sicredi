//
//  EventCheckinRepositoryImplementation.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation

struct EventCheckinRepositoryImplementation {
    
    // MARK: - Init
    
    init() {
        self.remote = URLSessionRemote()
        self.urlRequest = "https://5f5a8f24d44d640016169133.mockapi.io/api/checkin"
    }
    
    // MARK: - Properties
    
    private var remote: URLSessionRemote!
    private var urlRequest: String!
    
    // MARK: Methods
    
    func execute(checkin: EventCheckinModel, onCompletion: @escaping (Error?) -> Void) {
        
        let params: [String: String] = [
            "eventId": checkin.id,
            "name": checkin.name,
            "email": checkin.email
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        let request = RemoteServiceRequest(httpMethod: .post,
                                           urlPath: urlRequest,
                                           urlQueries: nil,
                                           httpBody: httpBody
        )
        
        remote.execute(request: request) { response in
            if let error = response.error {
                onCompletion(error)
                return
            }
            
            onCompletion(nil)
        }
    }
}
