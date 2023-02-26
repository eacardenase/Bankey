//
//  CurrencyFormatter.swift
//  Bankey
//
//  Created by Edwin Cardenas on 2/26/23.
//

import UIKit

struct CurrencyFormatter {
    
    func makeAttributtedCurrency(_ amount: Decimal) -> NSMutableAttributedString {
        let tuple: (dollars: String, cents: String) = breakIntoDollarsAndCents(amount)
        
        return makeBalanceAttributed(dollars: tuple.dollars, cents: tuple.cents)
    }
    
    // Converts 929466.23 -> "929,466" "23"
    func breakIntoDollarsAndCents(_ amount: Decimal) -> (String, String) {
        let tuple = modf(amount.doubleValue)
        
        let dollars = convertDollar(tuple.0)
        let cents = convertCents(tuple.1)
        
        return (dollars, cents)
    }
    
    // Converts 929466 -> 929,466
    private func convertDollar(_ dollarPart: Double) -> String {
        let dollarsWithDecimal = dollarsFormatted(dollarPart)
        let formatter = NumberFormatter()
        let decimalSeparator = formatter.decimalSeparator!
        let dollarComponent = dollarsWithDecimal.components(separatedBy: decimalSeparator)
        var dollars = dollarComponent.first!
        
        dollars.removeFirst()
        
        return dollars
    }
    
    private func convertCents(_ centPart: Double) -> String {
        let cents: String
        
        if centPart == 0 {
            cents = "00"
        } else {
            cents = String(format: "%.0f", centPart * 100)
        }
        
        return cents
    }
    
    func dollarsFormatted(_ dollars: Double) -> String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        
        if let result = formatter.string(from: dollars as NSNumber) {
            return result
        }
        
        return ""
    }
    
    private func makeBalanceAttributed(dollars: String, cents: String) -> NSMutableAttributedString {
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
        let dollarAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title1)]
        let centAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .footnote), .baselineOffset: 8]
        
        let rootString = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString = NSAttributedString(string: cents, attributes: centAttributes)
        
        rootString.append(dollarString)
        rootString.append(centString)
        
        return rootString
    }
}
