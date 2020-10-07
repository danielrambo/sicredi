//
//  EventCheckinError.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation

enum EventCheckinError: Error, LocalizedError {
    case empty
    case invalidEmail
    
    var errorDescription: String? {
        switch self {
        case .empty:
            return "Todos os campos devem ser preenchidos."
        case .invalidEmail:
            return "E-mail inválido."
        }
    }
}
