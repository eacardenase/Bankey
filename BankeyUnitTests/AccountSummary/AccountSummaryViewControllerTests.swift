//
//  AccountSummaryViewControllerTests.swift
//  BankeyUnitTests
//
//  Created by Edwin Cardenas on 3/1/23.
//

import Foundation
import XCTest

@testable import Bankey

class AccountSummaryViewControllerTests: XCTestCase {
    var vc: AccountSummaryViewController!
    
    override func setUp() {
        super.setUp()
        
        vc = AccountSummaryViewController()
//        vc.loadViewIfNeeded()
    }
    
    func testTitleAndMessageForServerError() throws {
        let titleAndMessage = vc.titleAndMessageForTesting(for: .serverError)
        
        XCTAssertEqual("Server Error", titleAndMessage.title)
        XCTAssertEqual("Ensure you are connected to the internet. Please try again.", titleAndMessage.message)
    }
    
    func testTitleAndMessageForEncodingError() throws {
        let titleAndMessage = vc.titleAndMessageForTesting(for: .decodingError)
        
        XCTAssertEqual("Decoding Error", titleAndMessage.title)
        XCTAssertEqual("We could not process your request. Please try again.", titleAndMessage.message)
    }
}
