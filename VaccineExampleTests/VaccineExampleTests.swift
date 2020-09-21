//
//  VaccineExampleTests.swift
//  VaccineExampleTests
//
//  Created by Munir Xavier Wanis on 2020-09-21.
//

import XCTest
@testable import VaccineExample
import Vaccine

class VaccineExampleTests: XCTestCase {

    private var serviceMock: ServiceMock!
    
    override func setUpWithError() throws {
        serviceMock = ServiceMock()
        Vaccine.setCure(for: ChuckNorrisServicing.self, with: self.serviceMock)
    }

    override func tearDownWithError() throws {
        serviceMock = nil
    }

    func testViewModelSuccess() throws {
        let response = ChuckNorrisResponse(iconUrl: "", id: "", url: "", value: "My name is Chuck Norris")
        serviceMock.expectedJoke = response
        let testExpectation = expectation(description: "Request ends")
        
        JokeViewModel().getRandomJoke { result in
            defer { testExpectation.fulfill() }
            switch result {
            case .success(let model):
                XCTAssertTrue(model.joke == response.value)
            case .failure(let error):
                XCTFail("Test failed with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [testExpectation], timeout: 10.0)
    }
    
    func testViewModelError() throws {
        serviceMock.expectedError = URLError(.unknown)
        let testExpectation = expectation(description: "Request ends")
        
        JokeViewModel().getRandomJoke { result in
            defer { testExpectation.fulfill() }
            switch result {
            case .success:
                XCTFail("Test should fail")
            case .failure(let error):
                XCTAssertEqual(error as! URLError, URLError(.unknown))
            }
        }
        
        wait(for: [testExpectation], timeout: 10.0)
    }
}

private class ServiceMock: ChuckNorrisServicing {
    var expectedJoke: ChuckNorrisResponse?
    var expectedError: Error?
    
    func getRandomJoke(callback: @escaping (Result<ChuckNorrisResponse, Error>) -> Void) {
        if let joke = expectedJoke {
            callback(.success(joke))
        }
        
        if let error = expectedError {
            callback(.failure(error))
        }
    }
}
