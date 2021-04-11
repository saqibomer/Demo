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
        
        viewModel.didFetchGames = { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.viewModel.games.count > 0 {
//                XCTAssertTrue()
            }
        }
    }

    func testGamesFetch() throws {
        
        viewModel.startFetchingGames()
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDecoding() throws {
        /// When the Data initializer is throwing an error, the test will fail.
        let jsonData = try Data(contentsOf: URL(string: "https://api.rawg.io/api/games?page_size=10&page=1")!)

        /// The `XCTAssertNoThrow` can be used to get extra context about the throw
        XCTAssertNoThrow(try JSONDecoder().decode(GamesResponse.self, from: jsonData))
    }

}
