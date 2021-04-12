//
//  DemoTests.swift
//  DemoTests
//
//  Created by TOxIC on 08/04/2021.
//

import XCTest
@testable import Demo


class DemoTests: XCTestCase {
    
    let viewModel = GamesViewModel(networkingService: NetworkClient() as NetworkingService)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        
        
    }
    /**
     MARK: - Decoding Tests
     */
    
    // MARK: - Validation of decoding of `GamesResponse` object
    func testgamesApiEndPointDecoding() throws {
        /// When the Data initializer or parsing of GamesResponse object fails it is throwing an error, the test will fail.
        viewModel.startFetchingGames()
        let expectation = XCTestExpectation.init(description: "Should parse games response.")
        let urlString = "https://api.rawg.io/api/games?page_size=10&page=1"
        let request = URLRequest(url: URL(string: urlString)!)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data,
                      let _ = try? JSONDecoder().decode(GamesResponse.self, from: data) else {
                    XCTFail("Fail")
                        return
                }
                expectation.fulfill()
            }
        }
        task.resume()
    }
    
    // MARK: - Validation of decoding of `Results` (Game details) object
    func testgameDetailsApiEndPointDecoding() throws {
        /// When the Data initializer or parsing of Resulsts object fails it is throwing an error, the test will fail.
        viewModel.startFetchingGames()
        let expectation = XCTestExpectation.init(description: "Should parse game details reponse.")
        let urlString = "https://api.rawg.io/api/games/3498"
        let request = URLRequest(url: URL(string: urlString)!)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data,
                      let _ = try? JSONDecoder().decode(Results.self, from: data) else {
                    XCTFail("Fail")
                        return
                }
                expectation.fulfill()
            }
        }
        task.resume()
    }
    
    // MARK: - Validation of decoding of search results (`GamesResponse Object`) object
    func testSearchApiEndPointDecoding() throws {
        /// When the Data initializer or parsing of GamesResponse object fails it is throwing an error, the test will fail.
        viewModel.startFetchingGames()
        let expectation = XCTestExpectation.init(description: "Should parse game details reponse.")
        let urlString = "https://api.rawg.io/api/games?page_size=10&page=1&search=gtav"
        let request = URLRequest(url: URL(string: urlString)!)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data,
                      let _ = try? JSONDecoder().decode(Results.self, from: data) else {
                    XCTFail("Fail")
                        return
                }
                expectation.fulfill()
            }
        }
        task.resume()
    }
    
    
    
    
}
