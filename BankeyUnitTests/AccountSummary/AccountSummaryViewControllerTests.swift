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
    var mockManager: MockProfileManager!
    
    class MockProfileManager: ProfileManageable {
        var profile: Profile?
        var error: NetworkError?
        
        func fetchProfile(forUserId userId: String, completion: @escaping (Result<Bankey.Profile, Bankey.NetworkError>) -> Void) {
            if error != nil {
                completion(.failure(error!))
                
                return
            }
            
            profile = Profile(id: "1", firstName: "FirstName", lastName: "LastName")
            completion(.success(profile!))
        }
    }
    
    override func setUp() {
        super.setUp()
        
        mockManager = MockProfileManager()
        
        vc = AccountSummaryViewController()
        vc.profileManager = mockManager
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
    
    func testAlertForServerError() throws {
        mockManager.error = .serverError
        vc.fetchProfileForTesting()
        
        XCTAssertEqual("Server Error", vc.errorAlert.title)
        XCTAssertEqual("Ensure you are connected to the internet. Please try again.", vc.errorAlert.message)
    }
    
    func testAlertForDecodingError() {
        mockManager.error = .decodingError
        vc.fetchProfileForTesting()
        
        XCTAssertEqual("Decoding Error", vc.errorAlert.title)
        XCTAssertEqual("We could not process your request. Please try again.", vc.errorAlert.message)
    }
}
