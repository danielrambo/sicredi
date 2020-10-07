//
//  EventItemModel.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation

struct EventItemModel: Codable {
    let id: String
    let title: String
    let date: Int
    let image: String
    let description: String
    let price: Double
}
