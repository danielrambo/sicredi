//
//  RemoteMethod.swift
//  sicredi
//
//  Created by Daniel Rambo on 04/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation

enum RemoteMethod {
    case get
    case post
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
