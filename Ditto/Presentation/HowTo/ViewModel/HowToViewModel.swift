//
//  HowToViewModel.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 24/09/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import CoreData

class HowToViewModel: NSObject {
    //MARK: VARIABLE DECLARATION
    var instructionArray = [Instruction]()
    var presentindex = 0
    var setUpcollectionView: UICollectionView!
    var tabTitles = [String]()
    var selectedIndex = 0
    var collectionViewType = FormatsString.workspaceLabel
    var resourceName = FormatsString.emptyString
    var imagvPopUp = UIImageView()
    var howToIndexPath = IndexPath(row: 0, section: 0)
    //  FUNCTION LOGICS 
    func fetchAllInstructions(completion: @escaping() -> Void) {    // Fetching already saved tutorial data from DB
        self.instructionArray.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntities.instructionDb)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            defer {
                completion()
            }
            if  let fetchedObjects = try contextData.fetch(fetchRequest) as? [Instruction] {
                _ =  fetchedObjects.map { (instruction)  in
                    self.instructionArray.append(instruction)
                }
            }
        } catch {
        }
    }
    func getArrayForSelectedIndex(selectedTabIndex: String, type: String) -> [Instruction] {   // Fetching array with given tab index and type
        let array =  self.instructionArray.filter {($0.tabIndex! == selectedTabIndex) && ($0.instructionType! == type)}
        return array
    }
}
