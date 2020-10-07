//
//  URLSessionRemote.swift
//  sicredi
//
//  Created by Daniel Rambo on 04/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation

public struct URLSessionRemote {
    
    let urlRegEx = "http[s]?://(([^/:.[:space:]]+(.[^/:.[:space:]]+)*)|([0-9](.[0-9]{3})))(:[0-9]+)?((/[^?#[:space:]]+)([^#[:space:]]+)?(#.+)?)?"
    func execute(request: RemoteServiceRequest, onCompletion: @escaping (RemoteServiceResponse) -> Void) {
        var urlComponents = URLComponents(string: request.urlPath)
        if request.httpMethod == .get, let urlQueries = request.urlQueries, urlQueries.isEmpty == false {
            var queryItems: [URLQueryItem] = []

            for (key, value) in urlQueries {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }

            urlComponents?.queryItems = queryItems
        }
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray: [urlRegEx])
        guard let url = urlComponents?.url, predicate.evaluate(with: url.absoluteString) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.description
        urlRequest.httpBody = request.httpBody
        
        if request.httpMethod == .get, let urlQueries = request.urlQueries, urlQueries.isEmpty == false {
            var queryItems: [URLQueryItem] = []

            for (key, value) in urlQueries {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }

            urlComponents?.queryItems = queryItems
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            let response = RemoteServiceResponse(data: data, error: error)
            onCompletion(response)
        }
        
        task.resume()
    }
    
}
