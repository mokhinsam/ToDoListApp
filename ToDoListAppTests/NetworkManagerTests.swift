//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Дарина Самохина on 29.08.2025.
//

import XCTest
@testable import ToDoListApp

final class NetworkManagerTests: XCTestCase {
        
    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        networkManager = NetworkManager.shared
    }

    override func tearDown() {
        networkManager = nil
        URLProtocol.unregisterClass(URLProtocolMock.self)
        super.tearDown()
    }

    func testFetchTodosSuccess() {
        let json = """
        {
          "todos": [
            {
              "todo": "Test ToDo",
              "completed": false
            }
          ]
        }
        """
        let data = json.data(using: .utf8)!
        URLProtocolMock.testData = data
        URLProtocol.registerClass(URLProtocolMock.self)

        let expectation = self.expectation(description: "FetchTodosSuccess")

        networkManager.fetchTodos { result in
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.todos.count, 1)
                XCTAssertEqual(todos.todos[0].todo, "Test ToDo")
                XCTAssertEqual(todos.todos[0].completed, false)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchTodosNoData() {
        URLProtocolMock.testData = nil
        URLProtocol.registerClass(URLProtocolMock.self)

        let expectation = expectation(description: "No Data Error")
        networkManager.fetchTodos { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noData)
            default:
                XCTFail("Expected noData error")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchTodosDecodingError() {
        let badJSON = """
        { "invalid": "structure" }
        """
        URLProtocolMock.testData = badJSON.data(using: .utf8)!
        URLProtocol.registerClass(URLProtocolMock.self)

        let expectation = expectation(description: "Decoding Error")
        networkManager.fetchTodos { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .decodingError)
            default:
                XCTFail("Expected decodingError")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

}

// MARK: - URLProtocolMock for intercepting network calls
class URLProtocolMock: URLProtocol {
    static var testData: Data?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let data = URLProtocolMock.testData {
            client?.urlProtocol(self, didLoad: data)
        } else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
