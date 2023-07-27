//
//  ProductsTests.swift
//  WorkBenchTests
//
//  Created by Kavita Kanwar on 17/10/19.
//  Copyright © 2019 Infosys. All rights reserved.
//

import XCTest

@testable import WorkBench

class ProductsTests: XCTestCase {
    var productViewModel: ProductListViewModel!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        productViewModel = ProductListViewModel()
        if let path = Bundle(for: type(of: self)).path(forResource: "ProductData", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                 let jsonResult = productViewModel.decodeJsonDataToProduct(data: data)
                 productViewModel.bindDataToArray(list: jsonResult!.data)
              } catch {
                   // handle error
              }
        }
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        productViewModel = nil
    }
    func testIsArrayEmpty() {
        XCTAssertFalse(productViewModel.productArray.isEmpty)
    }
    func testValidTitleForCategory() {
        XCTAssertTrue(Utilities.validateString(string: productViewModel.productArray[0].title), "No Title")
    }
}
