//
//  RemoteServiceRequest.swift
//  sicredi
//
//  Created by Daniel Rambo on 04/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation

public struct RemoteServiceRequest: Equatable {
    let httpMethod: RemoteMethod
    let urlPath: String
    let urlQueries: [String: String]?
    let httpBody: Data?
}
