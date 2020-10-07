//
//  StringExtension.swift
//  sicredi
//
//  Created by Daniel Rambo on 07/10/20.
//  Copyright © 2020 Daniel Rambo. All rights reserved.
//

import Foundation

public extension String {
    var currencyPtBRFormatted: String? {
        var value = self
        
        if let index = value.firstIndex(of: ".")?.utf16Offset(in: value), index == value.count - 2 {
            value += "0"
        }
        
        value = value.replacingOccurrences(of: ".", with: "")
        .replacingOccurrences(of: ",", with: "")
        .replacingOccurrences(of: Locale(identifier: "pt_BR").currencySymbol ?? "R$", with: "")
        .replacingOccurrences(of: " ", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let currencyValue = (Double(value) ?? 0.0) * 0.01
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        
        let transformed = formatter.string(from: NSNumber(value: currencyValue))
        return transformed
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
