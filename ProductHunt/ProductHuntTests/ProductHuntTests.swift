//
//  ProductHuntTests.swift
//  ProductHuntTests
//
//  Created by Harsh Gangar on 20/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import XCTest
@testable import ProductHunt

class ProductHuntTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchTodaysPost(){
        let expectation = XCTestExpectation(description: "Download failed")
        PostsAPI.shared.fetchPost(from: .posts) { (result: Result<PostsData, PostsAPI.APIServiceError>) in
            switch result{
            case .success(let data):
                XCTAssertNotNil(data, "data resceived")
                expectation.fulfill()
                
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testPostOnDate(){
        let expectation = XCTestExpectation(description: "Call failed")
        PostsAPI.shared.fetchPostForDate(from: .posts, date: "2017-09-13") { (result) in
            switch result{
            case .success(let data):
                print(data)
                XCTAssertNotNil(data, "data resceived")
                expectation.fulfill()
                
            case .failure(let error):
                print(error.description)
                expectation.fulfill()
            }
            
        }
        wait(for: [expectation], timeout: 20.0)

    }

}
