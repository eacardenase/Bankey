//
//  DecimalUtil.swift
//  Bankey
//
//  Created by Edwin Cardenas on 2/26/23.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
