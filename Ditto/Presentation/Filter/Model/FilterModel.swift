//
//  FilterModel.swift
//  Ditto
//
//  Created by niranjan on 19/07/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class FilterModel {
    var filterValue = [String: AnyObject]()
    var keys = [String]()
    var updatedFilterArr = [FilterElements]()
    func setData(dictData: [String: AnyObject]) {
        if !dictData.keys.isEmpty {
            for item in dictData.keys {
                let objUpdatedFilter = FilterElements()
                objUpdatedFilter.title = item
                if let value = dictData[item] as? [String] {
                    for filtervalue in value.sorted() {
                        objUpdatedFilter.subArr.append(filtervalue)
                    }
                }
                self.updatedFilterArr.append(objUpdatedFilter)
            }
            for filtrIndex in self.updatedFilterArr.indices {
                if self.updatedFilterArr[filtrIndex].title == FormatsString.productTypes {
                    var filter = FilterElements()
                    filter = self.updatedFilterArr[filtrIndex]
                    if !self.updatedFilterArr.isEmpty {
                        self.updatedFilterArr.remove(at: filtrIndex)
                        self.updatedFilterArr.insert(filter, at: 0)
                    } else {
                        self.updatedFilterArr.remove(at: filtrIndex)
                        self.updatedFilterArr.insert(filter, at: 0)
                    }
                }
                if self.updatedFilterArr[filtrIndex].title == FormatsString.category {
                    var filter = FilterElements()
                    filter = self.updatedFilterArr[filtrIndex]
                    if self.updatedFilterArr.count > 1 {
                        self.updatedFilterArr.remove(at: filtrIndex)
                        self.updatedFilterArr.insert(filter, at: 1)
                    } else {
                        self.updatedFilterArr.remove(at: filtrIndex)
                        self.updatedFilterArr.insert(filter, at: 0)
                    }
                }
                if self.updatedFilterArr[filtrIndex].title == FormatsString.brand {
                    var filter = FilterElements()
                    filter = self.updatedFilterArr[filtrIndex]
                    if self.updatedFilterArr.count > 2 {
                        self.updatedFilterArr.remove(at: filtrIndex)
                        self.updatedFilterArr.insert(filter, at: 2)
                    } else {
                        self.updatedFilterArr.remove(at: filtrIndex)
                        self.updatedFilterArr.insert(filter, at: 0)
                    }
                }
            }
            self.updatedFilterArr = self.updatedFilterArr.sorted(by: { $0.title < $1.title })
        }
    }
}

class FilterElements {
    var title = String()
    var subArr = [String]()
}
