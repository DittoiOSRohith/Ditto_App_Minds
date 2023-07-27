//
//  FilterViewController.swift
//  Ditto
//
//  Created by niranjan on 19/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation
import UIKit

@objc protocol FilterDelegate {
    func applyProductFilter(isFilterParamsPresent: Bool)
    func clearProductFilter()
}

class FilterViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var titleTableView: UITableView!
    @IBOutlet weak var contentsTableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    // MARK: - Global Variables
    var selectedCategory: Int = 0
    var contentArray: [String] = []
    var filterDictionary: [String: [String]] = [:]
    var selectedTitle: String!
    var selectedContents: [Int] = []
    var tempArr: [String] = []
    var dictIndices: [String: [Int]] = [:]
    let modelObj = FilterViewModel()
    var updatedFilterObj = FilterModel()
    var delegate: FilterDelegate?
    override func viewDidLoad() {
        // MARK: - Remaining cells are replaced with a blank view.
        let ttView = UIView()
        ttView.backgroundColor = ColorHandler.FilterTitleTablebgColor
        self.titleTableView.tableFooterView = ttView
        self.contentsTableView.tableFooterView = UIView()
        self.view.frame = UIScreen.main.bounds
        self.navigationController?.navigationBar.isHidden = true
        // If the filter is not applied and closed without applying the previous filtered is retained
        if let selectedFiltersValue = CommonConst.userDefault.object(forKey: CommonConst.SelectedFilters), let selectedFilterIndices =  CommonConst.userDefault.object(forKey: CommonConst.SelectedFilterIndices) {
            self.dictIndices = selectedFilterIndices as! [String: [Int]]
            self.filterDictionary = selectedFiltersValue as! [String: [String]]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.titleTableView.reloadData()
        self.contentsTableView.reloadData()
        if !self.updatedFilterObj.updatedFilterArr.isEmpty {
            self.contentArray = self.updatedFilterObj.updatedFilterArr[0].subArr
            self.selectedTitle = self.updatedFilterObj.updatedFilterArr[0].title
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.titleTableView.reloadData()
        self.contentsTableView.reloadData()
        self.getContentsForSelectedTitle(selectedTitle: self.selectedCategory)
    }
    // MARK: - Button Actions
    @IBAction func clearFilter(_ sender: UIButton) {
        self.dictIndices.removeAll()
        self.filterDictionary.removeAll()
        self.selectedContents.removeAll()
        self.tempArr.removeAll()
        CommonConst.userDefault.removeObject(forKey: CommonConst.SelectedFilterIndices)
        CommonConst.userDefault.removeObject(forKey: CommonConst.SelectedFilters)
        self.contentsTableView.reloadData()
        self.delegate?.clearProductFilter()
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func applyFilter(_ sender: UIButton) {
        self.filterDictionary = self.modelObj.removeEmptyArrayObjects(dict: self.filterDictionary)
        CommonConst.userDefault.set(self.dictIndices, forKey: CommonConst.SelectedFilterIndices)
        CommonConst.userDefault.set(object: self.filterDictionary, forKey: CommonConst.SelectedFilterObjectss)
        CommonConst.userDefault.set(self.filterDictionary, forKey: CommonConst.SelectedFilters)
        if let productfilter = CommonConst.userDefault.object([String: [String]].self, with: CommonConst.SelectedFilterObjectss) {
            self.dismiss(animated: false, completion: nil)
            self.delegate?.applyProductFilter(isFilterParamsPresent: !productfilter.isEmpty ? true: false)
        }
    }
}
