//
//  FilterViewController.swift
//  Ditto
//
//  Created by niranjan on 19/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation
import UIKit

protocol FilterDelegate: AnyObject {
    func applyProductFilter(isFilterParamsPresent: Bool)
    func clearProductFilter()
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var titleTableView: UITableView!
    @IBOutlet weak var contentsTableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    // MARK: - Global Variables
    var patternDict: NSDictionary?
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
        // MARK: - Getting the filter datas as dictionary from plist for now.
        self.patternDict = NSDictionary(contentsOfFile: modelObj.path!)
        // Remaining cells are replaced with a blank view.
        let ttView = UIView()
        ttView.backgroundColor = UIColor(rgb: 0xF7F7F7)
        titleTableView.tableFooterView = ttView
        contentsTableView.tableFooterView = UIView()
        self.view.frame = UIScreen.main.bounds
        self.navigationController?.navigationBar.isHidden = true
        // If the filter is not applied and closed without applying the previous filtered is retained
        if UserDefaults.standard.object(forKey: "SelectedFilters") != nil && (UserDefaults.standard.object(forKey: "SelectedFilterIndices") != nil) {
            self.dictIndices = UserDefaults.standard.object(forKey: "SelectedFilterIndices") as! [String: [Int]]
            self.filterDictionary = UserDefaults.standard.object(forKey: "SelectedFilters") as! [String: [String]]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        print("The FilterViewController Updated Filter Model =>")
        dump(self.UpdatedFilterObj.updatedFilterArr)
        self.titleTableView.reloadData()
        self.contentsTableView.reloadData()
        self.contentArray = self.UpdatedFilterObj.updatedFilterArr[0].SubArr
        self.selectedTitle = self.UpdatedFilterObj.updatedFilterArr[0].title
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.titleTableView.reloadData()
        self.contentsTableView.reloadData()
        self.getContentsForSelectedTitle(selectedTitle: self.selectedCategory)
    }
    // MARK: - Table View Datasource & Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == titleTableView {
            return self.UpdatedFilterObj.updatedFilterArr.count
        } else {
            return self.contentArray.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == titleTableView {
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! TitleTableViewCell
            let title = self.UpdatedFilterObj.updatedFilterArr[indexPath.row].title
            print("The Filter Title", title)
            if title == "productTypes" {
                titleCell.titleLabel.text = "Product Types"
            } else {
                titleCell.titleLabel.text = Title.capitalized // keys[indexPath.row]
            }
            if selectedCategory == indexPath.row {
                titleCell.arrowBtn.isHidden = false
                titleCell.backgroundColor = UIColor.white
                if UIDevice.isPhone {
                    titleCell.titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
                } else {
                    titleCell.titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
                }
            } else {
                titleCell.arrowBtn.isHidden = true
                if UIDevice.isPhone {
                    titleCell.titleLabel.font = UIFont(name: "Avenir Next LT Pro", size: 12)
                } else {
                    titleCell.titleLabel.font = UIFont(name: "Avenir Next LT Pro", size: 19)
                }
                titleCell.backgroundColor = UIColor(rgb: 0xF7F7F7)
            }
            return titleCell
        } else {
            let contentsCell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as! ContentsTableViewCell
            let content = self.contentArray[indexPath.row]
            contentsCell.contentLabel.text = content
            if ((self.dictIndices[self.selectedTitle]?.contains(indexPath.row)) != nil) && self.dictIndices[self.selectedTitle]!.contains(indexPath.row) {
                contentsCell.contentSelectedBtnImage.image = UIImage(named: "selected_square")
            } else {
                contentsCell.contentSelectedBtnImage.image = UIImage(named: "unSelected_square")
            }
            contentsCell.selectionItem = {
                    if contentsCell.contentSelectedBtnImage?.image == UIImage(named: "unSelected_square") {
                        contentsCell.contentSelectedBtnImage.image = UIImage(named: "selected_square")
                        self.selectedContents.append(indexPath.row)
                        self.tempArr.append(self.contentArray[indexPath.row])
                        var contentTempStrArr: [String] = []
                        var contentTempIndArr: [Int] = []
                        if self.filterDictionary[self.selectedTitle] == nil {
                            contentTempStrArr = self.tempArr
                            contentTempIndArr = self.selectedContents
                        } else {
                            var someArr: [String] = []
                            someArr.append(self.contentArray[indexPath.row])
                            var someIndArr: [Int] = []
                            someIndArr.append(indexPath.row)
                            contentTempStrArr = self.filterDictionary[self.selectedTitle]! + someArr
                            contentTempIndArr = self.dictIndices[self.selectedTitle]! + someIndArr
                        }
                        self.dictIndices[self.selectedTitle] = contentTempIndArr
                        self.filterDictionary[self.selectedTitle] = contentTempStrArr
                    } else {
                        contentsCell.contentSelectedBtnImage.image = UIImage(named: "unSelected_square")
//                        let thatArray = self.patternDict![self.selectedTitle] as! [String]
                        let theContent = self.contentArray[indexPath.row]
                        let selectIndices = self.filterDictionary[self.selectedTitle]!
                        let thatIndex = selectIndices.firstIndex(of: theContent)
                        self.dictIndices[self.selectedTitle]?.remove(at: thatIndex!)
                        self.filterDictionary[self.selectedTitle]?.remove(at: thatIndex!)
                    }
                    print("Final Filter: ", self.filterDictionary)
                }
            return contentsCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == titleTableView {
            self.selectedCategory = indexPath.row
            let tempArray = self.UpdatedFilterObj.updatedFilterArr   // patternDict?.allKeys as! [String]
            self.selectedTitle = tempArray[indexPath.row].title
            tableView.reloadData()
            self.tempArr.removeAll()
            self.selectedContents.removeAll()
            getContentsForSelectedTitle(selectedTitle: indexPath.row)
        }
    }
    // MARK: - Getting the contents for the title selected
    func getContentsForSelectedTitle(selectedTitle: Int) {
        self.contentArray.removeAll()
        self.contentArray = self.UpdatedFilterObj.updatedFilterArr[selectedTitle].SubArr
        self.contentsTableView.reloadData()
    }
    func removeEmptyArrayObjects(dict: [String: [String]]) -> [String: [String]] {
        var temp = dict
        for item in dict where item.value.isEmpty {
            print("Yes, Remove the entire object")
            temp.removeValue(forKey: item.key)
        }
        return temp
    }
    // MARK: _ Button Actions
    @IBAction func clearFilter(_ sender: UIButton) {
        self.dictIndices.removeAll()
        self.filterDictionary.removeAll()
        self.selectedContents.removeAll()
        self.tempArr.removeAll()
        UserDefaults.standard.removeObject(forKey: "SelectedFilterIndices")
        UserDefaults.standard.removeObject(forKey: "SelectedFilters")
        self.contentsTableView.reloadData()
        print("Final filter:", self.filterDictionary)
        delegate?.clearProductFilter()
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func dismiss(_ sender: UIButton) {
//        UserDefaults.standard.set(self.dictIndices, forKey: "SelectedFilterIndices")
//        UserDefaults.standard.set(self.filterDictionary, forKey: "SelectedFilters")
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func applyFilter(_ sender: UIButton) {
        self.filterDictionary = removeEmptyArrayObjects(dict: self.filterDictionary)
        UserDefaults.standard.set(self.dictIndices, forKey: "SelectedFilterIndices")
        UserDefaults.standard.set(object: self.filterDictionary, forKey: "SelectedFilterObjectss")
        UserDefaults.standard.set(self.filterDictionary, forKey: "SelectedFilters")
        let productfilter = UserDefaults.standard.object([String: [String]].self, with: "SelectedFilterObjectss")
        if productfilter?.count != 0 {
            print("The Filer is there")
            self.dismiss(animated: false, completion: nil)
            delegate?.applyProductFilter(isFilterParamsPresent: true)
        } else {
            print("The Filer is Not there")
            self.dismiss(animated: false, completion: nil)
            delegate?.applyProductFilter(isFilterParamsPresent: false)
        }
    }
}
// MARK: - TableviewCell classes and their members
class TitleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowBtn: UIImageView!
}

class ContentsTableViewCell: UITableViewCell {
    var selectionItem: (() -> Void)?
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentSelectedBtn: UIButton!
    @IBOutlet weak var contentSelectedBtnImage: UIImageView!
    @IBAction func selectContent(_ sender: UIButton) {
        if let btnAction = self.selectionItem {
            btnAction()
        }
    }
}
