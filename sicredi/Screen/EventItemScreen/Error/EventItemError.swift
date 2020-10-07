//
//  EventItemError.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation

enum EventItemError: Error, LocalizedError {
    case imageNotFound
    
    var errorDescription: String? {
        switch self {
        case .imageNotFound:
            return "Imagem não encontrada."
        }
    }
}
