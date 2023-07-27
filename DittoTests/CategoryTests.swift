//
//  CategoryTests.swift
//  WorkBenchTests
//
//  Created by Kavita Kanwar on 15/10/19.
//  Copyright © 2019 Infosys. All rights reserved.
//

import Foundation
import XCTest
@testable import WorkBench

class CategoryTests: XCTestCase {
    var categoryViewModel: CategoryListViewModel!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        categoryViewModel = CategoryListViewModel()
        if let path = Bundle(for: type(of: self)).path(forResource: "CategoryData", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                 let jsonResult = categoryViewModel.decodeJsonDataToCategory(data: data)
                 categoryViewModel.bindDataToArray(list: jsonResult!.data)
              } catch {
                   // handle error
              }
        }
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        categoryViewModel = nil
        super.tearDown()
    }
    func testIsArrayEmpty() {
        XCTAssertFalse(categoryViewModel.categoryArray.isEmpty)
    }
    func testCategoryHasTitle() {
        let category = Category(title: "Pendrive")
        XCTAssertEqual( category.title, "Pendrive", "category name should be set in initializer" )
     }
    func testValidTitleForCategory() {
        XCTAssertTrue(Utilities.validateString(string: categoryViewModel.categoryArray[0].title), "No Title")
    }
}
