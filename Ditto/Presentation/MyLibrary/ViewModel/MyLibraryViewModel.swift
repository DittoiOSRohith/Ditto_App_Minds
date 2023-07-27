//
//  MyLibraryViewModel.swift
//  JoannTraceApp
//
//  Created by Abiya Joy on 26/03/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit.UIImage
import CoreData
import Alamofire
import SDWebImage

class MyLibraryViewModel: NSObject, UISearchBarDelegate {
    // MARK: - VARIABLE DECLARATION
    var delegate: MyLibrarryViewController?
    let myLibraryInteractor = MainContainer.sharedContainer.container.resolve(MyLibraryUseCaseInteractorProtocol.self)
    var patternArray = [PatternObject]()
    var currentSelectedPatternIndex: Int = 0
    var patternDBArray = [Pattern]()
    var filterdpatternDBArray = [Pattern]()
    var workspaceArrayActive = [Workspace]()
    var workspaceCompletedArray = [Workspace]()
    var pattern: Pattern?
    var fetchType = Constants.fromAllPatterns
    var workSpace: Workspace?
    let cellsAcross: CGFloat = 4
    let spaceBetweenCells: CGFloat = 5
    let insetValues: CGFloat = 10
    var count: Int = 0
    var offlinePattern = [MyLibraryPatterns]()
    var status: Bool = false
    var arrayCount: Int = 0
    var noActivityActiveLabel: String = MessageString.noActivityActive
    var noActivityCompletedLabel: String = MessageString.noActivityCompleted
    var isSearching = Bool()
    var myFolderArray = [String]()
    var selectedPattern: Int!
    var objMylibData = MyLibraryData()
    let patternDescription = PatternDescriptionDataModel()
    let folderData = FolderDataModel()
    var reloadCollectionView: (() -> Void)?
    var trailPatternArray = [PatternModelObject]()
    var errorMessage = String()
    var apiMyfolderArray = [String]()
    var apimyFolderCompleted = false
    // MARK: - Logical Functions
    func savePatternsMetaDataToDB(pdata: [String: AnyObject]) {   // Save Patterns MetaData To DB
        let context = DatabaseHelper().managedObjectContext
        if let patternEntity = Pattern(context: context) as Pattern? {
            patternEntity.patternIndex = (pdata["id"] as? Int16)!
            patternEntity.patternImage = pdata["thumbnailImagePath"] as? String
            patternEntity.patternTitle = pdata["patternName"] as? String
            patternEntity.totalPieces = (pdata["totalPieces"] as? Int16)!
            patternEntity.status = pdata["status"] as? String
            patternEntity.patternInstruction = pdata["description"] as? String
            patternEntity.patternPDF = pdata["patternPDF"] as? String
            if let descriptionData = pdata["descriptionImages"] {
                for data in ((descriptionData as? [AnyObject])!) {
                    if let descriptionEntity = DescriptionImages(context: context) as DescriptionImages? {
                        descriptionEntity.id = (data["id"] as? Int16)!
                        if descriptionEntity.id == 1 {
                            patternEntity.patternDescriptionImage = data["imagePath"] as? String
                        }
                        descriptionEntity.imagePath = data["imagePath"] as? String
                        descriptionEntity.pattern = patternEntity
                        patternEntity.addToDescImages(descriptionEntity)
                    }
                }
            }
            if let selvagesData = pdata["selvages"] {
                for data in ((selvagesData as? [AnyObject])!) {
                    if let selvagesEntity = Selvages(context: context) as Selvages? {
                        selvagesEntity.imagePath = data["imagePath"] as? String
                        selvagesEntity.fabricLength = data["fabricLength"] as? String
                        selvagesEntity.tabCategory = data["tabCategory"] as? String
                    }
                }
            }
            if let patternPieceData = pdata["patternPieces"] {
                for data in ((patternPieceData as? [AnyObject])!) {
                    if let pieceEntity = PatternPieceDetails(context: context) as PatternPieceDetails? {
                        if let idVal = (data["id"]) as? Int16 {
                            pieceEntity.id = idVal
                        }
                        pieceEntity.parentPatten = data["parentPattern"] as? String
                        pieceEntity.imagePath = data["imagePath"] as? String
                        pieceEntity.size = data["size"] as? String
                        pieceEntity.view = data["view"] as? String
                        pieceEntity.pieceNumber = data["pieceNumber"] as? String
                        pieceEntity.pieceDescription = data["pieceDescription"] as? String
                        pieceEntity.positionInTabLineUp = data["positionInTab"] as? String
                        pieceEntity.tabCategory = data["tabCategory"] as? String
                        pieceEntity.cutQuantity = data["cutQuantity"] as? String
                        pieceEntity.spliceScreenQuantity = data["spliceScreenQuantity"] as? String
                        pieceEntity.thumbnailImagePath = data["thumbnailImagePath"] as? String
                        pieceEntity.spliceDirection = data["spliceDirection"] as? String
                        pieceEntity.contrast = data["contrast"] as? String
                        let spliceStr = data["splice"] as? String
                        pieceEntity.splice = spliceStr == AlertTitle.YES ? true: false
                        let mirrorStr = data["mirrorOption"] as? String
                        pieceEntity.mirrorOption = mirrorStr == AlertTitle.YES ? true: false
                        if let splicedPieceData = data["splicedImages"] {
                            for data in ((splicedPieceData as? [AnyObject])!) {
                                if let spliceEntity = SplicedImages(context: context) as SplicedImages? {
                                    spliceEntity.id = (data["id"] as? Int16)!
                                    spliceEntity.imagePath = data["imagePath"] as? String
                                    spliceEntity.referenceSplice = data["reference_splice"] as? String ?? FormatsString.emptyString
                                    spliceEntity.id = Int16(data["id"] as? Int ?? 0)
                                    spliceEntity.row = Int16(data["row"] as? Int ?? 0)
                                    spliceEntity.coloumn = Int16(data["column"] as? Int ?? 0)
                                }
                            }
                        }
                    }
                }
            }
        }
        DatabaseHelper().saveContext(context)
    }
    func fetchFormFromDB(fetchType: String) {   // Fetch Patterns from the DB
        self.patternArray.removeAll()
        self.patternDBArray.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntities.pattenDb)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "patternTitle", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedObjects = try contextData.fetch(fetchRequest) as! [Pattern]
            _ = fetchedObjects.map { (pattern)  in
                let patternObject = PatternObject()
                patternObject.patternImage = pattern.patternImage!
                patternObject.patternTitle = pattern.patternTitle!
                patternObject.patternInstructions = pattern.patternInstruction!
                self.patternDBArray.append(pattern)
                self.patternArray.append(patternObject)
            }
            self.delegate?.reloadCollectionViewData(type: Constants.fromAllPatterns)
        } catch {
        }
    }
    func fetchActive(entityName: String, fetchType: String) {
        self.workspaceArrayActive.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntities.workspaceDb)
        let predicate = NSPredicate(format: "status == %@", "Active")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            if let fetchedObjects = try contextData.fetch(fetchRequest) as? [Workspace] {
                _ =     fetchedObjects.map { (workspace)  in
                    self.workspaceArrayActive.append(workspace)
                }
                self.delegate?.reloadCollectionViewData(type: Constants.fromActive)
            }
        } catch {
            // Handle the error!
        }
    }
    func fetchCompletedWorkspace(entityName: String, fetchType: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntities.workspaceDb)
        let predicate = NSPredicate(format: "status == %@", "Completed")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        self.workspaceCompletedArray.removeAll()
        do {
            let fetchedObjects = try contextData.fetch(fetchRequest) as! [Workspace]
            _ = fetchedObjects.map { (workspace)  in
                self.workspaceCompletedArray.append(workspace)
            }
            self.delegate?.reloadCollectionViewData(type: Constants.fromCOMPLETED)
        } catch {
            // Handle the error!
        }
    }
    func noActivityfontFunction() -> UIFont {
        let font = UIFont(name: FontName.openSans, size: UIDevice.isPhone ? 14.0: 18.0)!
        return font
    }
    func addProjectfontFunction() -> UIFont {
        let font = UIFont(name: FontName.openSansSemiBold, size: UIDevice.isPhone ? 12.0: 16.0)!
        return font
    }
    func DBFetch() {
        self.fetchFormFromDB(fetchType: FormatsString.emptyString)
    }
    func buttonActionFetch(label: String) -> Bool {
        let value = CommonConst.userDefault.bool(forKey: CommonConst.isworkspaceadded)
        if label == WorkspaceScreenType.fromActive.rawValue {
            self.fetchType = Constants.fromActive
            if value {
                self.fetchActive(entityName: EntityName.Active, fetchType: Constants.fromActive)
            } else {
                CommonConst.userDefault.setValue(false, forKeyPath: CommonConst.isworkspaceadded)
            }
        } else if label == WorkspaceScreenType.fromCompleted.rawValue {
            if value {
                self.fetchCompletedWorkspace(entityName: EntityName.Workspace, fetchType: FormatsString.emptyString)
            }
        }
        return value
    }
    func arrayCountFetch(label: String) -> Int {
        if label == WorkspaceScreenType.fromActive.rawValue {
            self.arrayCount = self.workspaceArrayActive.count
        } else if label == WorkspaceScreenType.fromCompleted.rawValue {
            self.arrayCount = self.workspaceCompletedArray.count
        }
        return self.arrayCount
    }
    func butonActionFunction(type: String) -> Int? {
        if type == WorkspaceScreenType.fromAllPatterns.rawValue {
            self.DBFetch()
            return nil
        } else {
            let status = self.buttonActionFetch(label: type)
            let arrayCount = self.arrayCountFetch(label: type)
            return status ? arrayCount : nil
        }
    }
    func numOfItemsCollectionView() -> Int {
        return self.isSearching ? self.filterdpatternDBArray.count : self.objMylibData.prod.count
    }
    func cellOfCollectionView(addtofolderimgstatus: Bool = false, cell: HomeCollectionViewCell, index: Int) -> HomeCollectionViewCell {
        if self.isSearching {
            if !self.filterdpatternDBArray.isEmpty && self.filterdpatternDBArray.indices.contains(index) {
                cell.progressViews.isHidden = true
                let pattern = self.filterdpatternDBArray[index]
                cell.titleLabel.text = pattern.tailornovaDesignName
                cell.iconImageVeiw.image =  UIImage(named: "\(pattern.patternImage!)")
            }
        } else {
            guard let folderswichStatus = self.delegate?.folderSwitch else { return cell }
            if folderswichStatus {
                if !self.myFolderArray.isEmpty && self.myFolderArray.indices.contains(index) {
                    let imgPadding = UIDevice.isPhone ? CGFloat(20) : CGFloat(30)
                    cell.flagImageView.isHidden = true
                    cell.progressViews.isHidden = true
                    cell.trialLbl.isHidden = true
                    cell.subscribedLbl.isHidden = true
                    cell.pausedLbl.isHidden = true
                    cell.titleLabel.text = self.myFolderArray[index]
                    cell.iconImageVeiw.frame = cell.bounds
                    cell.iconImageVeiw.isHidden = false
                    cell.centerImage.isHidden = true
                    cell.addToFolderImg.isHidden = true
                    cell.iconImageVeiw.contentMode = .scaleAspectFit
                    cell.containerView.backgroundColor = ColorHandler.addFolderBgCOlor
                    switch index {
                    case 0:
                        cell.iconImageVeiw.image = UIImage(named: ImageNames.whiteFolderImage)?.addPadding(imgPadding)
                    case 1, 2:
                        cell.iconImageVeiw.image = UIImage(named: ImageNames.yellowFolderImage)?.addPadding(imgPadding)
                    default:
                        cell.iconImageVeiw.image = UIImage(named: ImageNames.yellowFolderImage)?.addPadding(imgPadding)
                        cell.addToFolderImg.isHidden = false
                        cell.addToFolderImg.image = UIImage(named: ImageNames.threedots)
                        cell.selectionItem = {
                            self.selectedPattern = index
                            self.delegate?.collectionView.reloadData()
                        }
                        cell.closeItem = {
                            self.selectedPattern = nil
                            self.delegate?.collectionView.reloadData()
                        }
                        cell.deleteItem = {
                            self.selectedPattern = nil
                            DispatchQueue.main.async {
                                let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
                                viewc.alertArray = [FormatsString.emptyString, AlertMessage.sureToDeleteFolder, AlertTitle.CANCEL, AlertTitle.OKButton]
                                viewc.screenType = ScreenTypeString.deleteFolder
                                viewc.modalPresentationStyle = .overFullScreen
                                viewc.onCancelInDeleteFolderPressed = {
                                    Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                                }
                                viewc.onOkInDeleteFolderPressed = {
                                    Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                                    let folderName = self.myFolderArray[index]
                                    self.removeFolder(folderName: "\(folderName)") { (responsestatus) in
                                        if responsestatus {
                                            self.getFolder { _ in
                                                self.myFolderArray = self.folderData.folderNameArray
                                                self.addDefaultFolders()
                                                self.reloadCollectionView!()
                                            }
                                        }
                                    }
                                }
                                if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                                    Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
                                }
                                self.delegate?.collectionView.reloadData()
                            }
                        }
                        cell.renameItem = {
                            let folderName = self.myFolderArray[index]
                            self.selectedPattern = nil
                            self.createOrRenameFolderAlert(oldFolderName: folderName, index: index, screentype: ScreenTypeString.myLibraryRenameFolder)
                            self.delegate?.collectionView.reloadData()
                        }
                    }
                    cell.renameOrDeleteView.isHidden = index == selectedPattern ? false: true
                    cell.addToFavoritesImg.isHidden = true
                }
            } else {
                cell.selectionItem = {
                    if !self.objMylibData.prod.isEmpty && self.objMylibData.prod.indices.contains(index) {
                        if self.apimyFolderCompleted {
                            self.folderPopupAlert(pattternIndex: index)
                        } else {
                            self.getFolder { _ in
                                self.apimyFolderCompleted = true
                                self.folderPopupAlert(pattternIndex: index)
                            }
                        }
                    }
                }
                cell.iconImageVeiw.frame = cell.bounds
                cell.iconImageVeiw.isHidden = false
                cell.addToFolderImg.isHidden = addtofolderimgstatus
                cell.addToFolderImg.image = UIImage(named: ImageNames.plusIconRedCircle)
                cell.renameOrDeleteView.isHidden = true
                cell.centerImage.isHidden = true
                cell.containerView.backgroundColor = UIColor.white
                cell.flagImageView.isHidden = CommonConst.guestUserCheck ? false: true
                cell.progressViews.isHidden = true
                var myLibraryPattern = MyLibraryPatterns()
                if let manager = NetworkReachabilityManager(), manager.isReachable {
                    if !self.objMylibData.prod.isEmpty && self.objMylibData.prod.indices.contains(index) {
                        myLibraryPattern = self.objMylibData.prod[index]
                    }
                } else {
                    if !self.offlinePattern.isEmpty, self.offlinePattern.indices.contains(index) {
                        myLibraryPattern = self.offlinePattern[index]
                    } else {
                        if !self.objMylibData.prod.isEmpty && self.objMylibData.prod.indices.contains(index) {
                            myLibraryPattern = self.objMylibData.prod[index]
                        }
                    }
                }
                cell.titleLabel.text = myLibraryPattern.tailornovaDesignName
                cell.titleLabel.text = (cell.titleLabel.text == FormatsString.emptyString) ? myLibraryPattern.name: cell.titleLabel.text
                cell.trialLbl.isHidden = true
                cell.subscribedLbl.isHidden = true
                cell.pausedLbl.isHidden = true
                if CommonConst.guestUserCheck {
                    cell.flagImageView.isHidden = true
                    cell.trialLbl.isHidden = false
                } else {
                    if myLibraryPattern.status == FormatsString.new {
                        if myLibraryPattern.patternType == FormatsString.Trial || myLibraryPattern.patternType == FormatsString.TRIAL {
                            cell.flagImageView.isHidden = true
                            cell.trialLbl.isHidden = false
                        } else {
                            cell.flagImageView.isHidden = true
                            cell.trialLbl.isHidden = false
                            cell.trialLbl.text = FormatsString.NEW
                        }
                    } else if myLibraryPattern.status == FormatsString.OWNED {
                        cell.flagImageView.isHidden = true
                        cell.trialLbl.isHidden = false
                        cell.trialLbl.text = FormatsString.OWNED
                    } else if myLibraryPattern.status == FormatsString.EXPIRED {
                        cell.flagImageView.isHidden = true
                        cell.subscribedLbl.isHidden = true
                        cell.pausedLbl.isHidden = false
                        cell.pausedLbl.text = FormatsString.EXPIRED
                    } else if myLibraryPattern.status == FormatsString.Trial || myLibraryPattern.status == FormatsString.TRIAL {
                        cell.flagImageView.isHidden = true
                        cell.trialLbl.isHidden = false
                    } else if myLibraryPattern.status == FormatsString.SUBSCRIBED {
                        cell.flagImageView.isHidden = true
                        cell.subscribedLbl.isHidden = false
                    } else if myLibraryPattern.status == FormatsString.PAUSED {
                        cell.flagImageView.isHidden = true
                        cell.subscribedLbl.isHidden = true
                        cell.pausedLbl.isHidden = false
                    } else {
                        cell.flagImageView.isHidden = true
                    }
                }
                cell.iconImageVeiw.contentMode = .scaleAspectFit
                cell.iconImageVeiw.sd_setImage(with: URL(string: myLibraryPattern.image), placeholderImage: UIImage(named: ImageNames.placeholderImage)) { (image, err, _, _) in
                    if err == nil {
                        cell.iconImageVeiw.image = image
                    } else {
                        cell.iconImageVeiw.image = UIImage(named: ImageNames.placeholderImage)
                    }
                }
                cell.addToFavoritesImg.isHidden = false
                cell.addToFavoritesImg.tag = index
                cell.addToFavoritesImg.addTarget(self, action: #selector(self.addAsFavourite(sender:)), for: .touchUpInside)
                cell.addToFavoritesImg.isHidden = addtofolderimgstatus
                if myLibraryPattern.isFavo == true {
                    cell.addToFavoritesImg.setImage(UIImage(named: ImageNames.heartFilled), for: .normal)
                } else {
                    cell.addToFavoritesImg.setImage(UIImage(named: ImageNames.heartUnFilled), for: .normal)
                }
                if let manager = NetworkReachabilityManager(), !manager.isReachable || CommonConst.guestUserCheck {
                    cell.addToFavoritesImg.isHidden = true
                    cell.addToFolderImg.isHidden = true
                }
            }
        }
        return cell
    }
    func removeFilterUserDefaults() {
        CommonConst.userDefault.removeObject(forKey: CommonConst.SelectedFilterObjectss)
        CommonConst.userDefault.removeObject(forKey: CommonConst.SelectedFilterIndices)
        CommonConst.userDefault.removeObject(forKey: CommonConst.SelectedFilters)
    }
    func addDefaultFolders() {
        self.myFolderArray.insert(FormatsString.createNewFolder, at: 0)
        self.myFolderArray.insert(FormatsString.Owned, at: 1)
        self.myFolderArray.insert(FormatsString.Favorites, at: 2)
    }
    @objc func addAsFavourite(sender: UIButton) {
        let index = sender.tag
        if !self.objMylibData.prod.isEmpty && self.objMylibData.prod.indices.contains(index) {
            let favoStatus = self.objMylibData.prod[index].isFavo
            let designID = self.objMylibData.prod[index].tailornovaDesignID
            let actionStatus = favoStatus ? "deleteFavorite": "addToFavorite"
            let paramDict = ["OrderFilter": ["purchasedPattern": MyLibraryAttribute.purchasedPattern,
                                             "subscriptionList": MyLibraryAttribute.subscriptionList,
                                             "allQuery": MyLibraryAttribute.allQuery,
                                             "trialPattern": MyLibraryAttribute.trialPattern,
                                             "emailID": "\(CommonConst.loginEmailText)"],
                             "FoldersConfig": [
                                "Favorite": ["\(designID)"]],
                             "patternsPerPage": FormatsString.patternsPerPageCount,
                             "searchTerm": FormatsString.emptyString,
                             "ProductFilter": []] as [String: Any]
            self.updateFavouritePattern(params: paramDict, updateStatus: actionStatus) { _ in
                self.objMylibData.prod[index].isFavo = favoStatus ? false: true
                self.reloadCollectionView!()
            }
        }
    }
    func createOrRenameFolderAlert(designID: String = FormatsString.emptyString, folderIndex: Int = 0, oldFolderName: String = FormatsString.emptyString, index: Int = 0, screentype: String) {
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithButtonsAndOneTextField.instantiateViewController(identifier: Constants.AlertWithButonsTextFieldVCIdentifier) as AlertWithButtonsAndOneTextFieldViewController
            viewc.fromScreen = screentype
            if screentype == ScreenTypeString.myLibraryRenameFolder {
                viewc.alertArray = [AlertTitle.renamefolder, AlertTitle.FOLDERNAME, FormatsString.emptyString, AlertTitle.RENAMEFOLDER, AlertTitle.CANCEL]
                viewc.renameFolder = {
                    guard let folder = viewc.folderNameTextField.text else {
                        return
                    }
                    guard folder.isEmpty != true else {
                        self.folderPopupAlert()
                        return
                    }
                    self.delegate?.folderSwitch = true
                    self.delegate?.collectionView.reloadData()
                    self.delegate?.myFolderUnderLineLbl.isHidden = false
                    self.delegate?.allPatternsUnderLineLbl.isHidden = true
                    self.delegate?.navigationtitleLabel.text = FormatsString.myfolders
                    self.delegate?.allPatternsLabel.textColor = ColorHandler.myfolderLableColor
                    self.delegate?.myFoldersLabel.textColor = ColorHandler.allpatternLableColor
                    Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                    self.renameFolder(oldFolderName: oldFolderName, newFolderName: folder) { (responseStatus) in
                        if responseStatus {
                            self.getFolder { _ in
                                self.myFolderArray = self.folderData.folderNameArray
                                self.addDefaultFolders()
                                self.reloadCollectionView!()
                            }
                        }
                    }
                }
            } else if screentype == ScreenTypeString.myLibraryFolder {
                viewc.alertArray = [AlertTitle.NEWFOLDER, AlertTitle.FOLDERNAME, FormatsString.emptyString, AlertTitle.CREATEFOLDER, AlertTitle.CANCEL]
                viewc.createFolder = {
                    guard let folder = viewc.folderNameTextField.text else {
                        return
                    }
                    guard folder.isEmpty != true else {
                        self.folderPopupAlert()
                        return
                    }
                    self.delegate?.folderSwitch = true
                    self.delegate?.collectionView.reloadData()
                    self.delegate?.myFolderUnderLineLbl.isHidden = false
                    self.delegate?.allPatternsUnderLineLbl.isHidden = true
                    self.delegate?.navigationtitleLabel.text = FormatsString.myfolders
                    self.delegate?.allPatternsLabel.textColor = ColorHandler.myfolderLableColor
                    self.delegate?.myFoldersLabel.textColor = ColorHandler.allpatternLableColor
                    Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                    self.createUpdateFolder(withPattern: "\(designID)", folderName: folder) { (responseStatus) in
                        if responseStatus {
                            self.getFolder { _ in
                                self.myFolderArray = self.folderData.folderNameArray
                                self.addDefaultFolders()
                                self.reloadCollectionView!()
                            }
                        }
                    }
                }
            }
            viewc.modalPresentationStyle = .custom
            Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: true, completion: nil)
        }
    }
    func folderPopupAlert(pattternIndex: Int = 0) {
        DispatchQueue.main.async {
            let folderAlert = Constants.AlertWithTableViewAndBottons.instantiateViewController(identifier: Constants.AlertWithTableBotonsVCIdentifier) as AlertWithTableViewAndBottonsViewController
            folderAlert.modalPresentationStyle = .custom
            folderAlert.folderName.removeAll()
            folderAlert.folderName = self.folderData.folderNameArray
            folderAlert.alertArray = [AlertImg.closeIconThick, AlertTitle.ADDTOFOLDER]
            folderAlert.newFolderTapped = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                if self.objMylibData.prod.count > pattternIndex {
                    let designID = self.objMylibData.prod[pattternIndex].tailornovaDesignID
                    self.createOrRenameFolderAlert(designID: "\(designID)", folderIndex: 0, screentype: ScreenTypeString.myLibraryFolder)
                }
            }
            folderAlert.exsistingFolderTapped = { foldername in
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                if self.objMylibData.prod.count > pattternIndex {
                    let designID = self.objMylibData.prod[pattternIndex].tailornovaDesignID
                    self.createUpdateFolder(withPattern: designID, forUpdateFolder: true, folderName: foldername) { (responseStatus) in
                        if responseStatus {
                            self.getFolder { _ in
                                self.delegate?.myFolderClicked(UIButton())
                            }
                        }
                    }
                }
            }
            Proxy.shared.keyWindow?.rootViewController?.present(folderAlert, animated: false, completion: nil)
        }
    }
    func selectItemCollectionView(index: Int) {
        if self.isSearching {
            if self.filterdpatternDBArray.indices.contains(index) {
                self.pattern = self.filterdpatternDBArray[index]
            }
        } else {
            if self.patternDBArray.indices.contains(index) {
                self.pattern = self.patternDBArray[index]
            }
        }
    }
    // MARK: - Get My LibraryAPI
    func getMyLibraryData(atributeType: AttributeType, prodfilter: [String: [String]], showLoader: Bool = true, cleareProdArray: Bool = false, pageid: String = FormatsString.oneLabel, foldername: String = FormatsString.emptyString, searchStr: String = FormatsString.emptyString, completion: @escaping(_ ResponseDict: MyLibraryData) -> Void) {
        var orderfilter = [String: Any]()
        switch atributeType {
            //  *** TRIAL PATTERNS REMOVED IN PRODUCTION AS PER CLIENT FEEDBACK, FOR THAT allQuery IS KEPT AS FALSE*//
        case .myLibrary:
            orderfilter = ["purchasedPattern": MyLibraryAttribute.purchasedPattern, "subscriptionList": MyLibraryAttribute.subscriptionList, "allQuery": MyLibraryAttribute.allQuery, "trialPattern": MyLibraryAttribute.trialPattern, "emailID": "\(CommonConst.loginEmailText)"]
        case .onClickFolder:
            orderfilter = ["purchasedPattern": OnClickFolderAttribute.purchasedPattern, "subscriptionList": foldername == "Owned" ? false : OnClickFolderAttribute.subscriptionList, "allQuery": foldername == "Owned" ? false : OnClickFolderAttribute.allQuery, "trialPattern": OnClickFolderAttribute.trialPattern, "emailID": "\(CommonConst.loginEmailText)", "FolderName": "\(foldername == "Owned" ? FormatsString.emptyString: foldername == "\(FormatsString.favorite)s" ? FormatsString.favorite: foldername)"]
        case .sync:
            orderfilter = ["purchasedPattern": true, "subscriptionList": true, "allQuery": false, "emailID": "\(CommonConst.loginEmailText)"]
        default:
            orderfilter = ["purchasedPattern": true, "subscriptionList": true, "allQuery": false, "emailID": "\(CommonConst.loginEmailText)"]
        }
        let paramDict = ["OrderFilter": orderfilter, "pageId": pageid, "patternsPerPage": FormatsString.patternsPerPageCount, "searchTerm": searchStr, "ProductFilter": prodfilter] as [String: Any]
        ServiceManagerProxy.shared.postData(urlStr: "\(Apis.MyLibraryURL)", params: paramDict as Dictionary, showIndicator: showLoader) { (response) in
            if response!.success {
                if let dictData = response!.data {
                    let error = dictData["errorMsg"] as? String ?? FormatsString.emptyString
                    if error.isEmpty {
                        if cleareProdArray {
                            self.objMylibData.prod.removeAll()
                        }
                        self.objMylibData.setMyLibraryData(dictData: dictData)
                        completion(self.objMylibData )
                    }
                }
            }
        }
    }
    // MARK: - Get Pattern Description
    func getPatternDescription(completion: @escaping (_ ResponseDict: PatternDescriptionDataModel) -> Void) {
        ServiceManagerProxy.shared.getData(urlStr: "\(Apis.PatternDescURL)") { (response) in
            if response!.success {
                if let dictData = response!.data {
                    self.patternDescription.setPatternDescriptionDataModel(dictData: dictData)
                    completion(self.patternDescription )
                }
            }
        }
    }
    // MARK: - FolderAPI
    func getFolder(completion: @escaping (_ ResponseDict: FolderDataModel) -> Void) {
        let paramDict = ["OrderFilter": ["purchasedPattern": FolderAttribute.purchasedPattern,
                                          "subscriptionList": FolderAttribute.subscriptionList,
                                          "allQuery": FolderAttribute.allQuery,
                                          "trialPattern": FolderAttribute.trialPattern,
                                          "emailID": "\(CommonConst.loginEmailText)"]] as [String: Any]
        ServiceManagerProxy.shared.postData(urlStr: Apis.getFolderURL, params: paramDict as Dictionary) { (response) in
            if response!.success {
                if let dictData = response!.data {
                    let error = dictData["errorMsg"] as? String ?? FormatsString.emptyString
                    if error.isEmpty {
                        Proxy.shared.dismissLottie()
                        self.folderData.folderNameArray.removeAll()
                        self.folderData.setGetFolderData(dictData: dictData)
                        self.apiMyfolderArray = self.folderData.folderNameArray
                        Proxy.shared.dismissLottie()
                        completion(self.folderData )
                    }
                }
            }
        }
    }
    func renameFolder(oldFolderName: String, newFolderName: String, completion: @escaping (_ ResponseDict: Bool) -> Void) {
        guard newFolderName.lowercased() != "favorites" && newFolderName.lowercased() != "owned" && !self.myFolderArray.map({$0.lowercased()}).contains("\(newFolderName.lowercased())") else {
            ServiceManagerProxy.shared.displayerrorPopup(url: Apis.renameFolderURL, responseError: MessageString.folderAlreadyExist)
            return
        }
        let paramDict = ["OrderFilter": ["purchasedPattern": FolderAttribute.purchasedPattern,
                                          "subscriptionList": FolderAttribute.subscriptionList,
                                          "allQuery": FolderAttribute.allQuery,
                                          "trialPattern": FolderAttribute.trialPattern,
                                          "emailID": "\(CommonConst.loginEmailText)",
                                          "oldname": "\(oldFolderName)",
                                          "newname": "\(newFolderName)"]] as [String: Any]
        ServiceManagerProxy.shared.postData(urlStr: Apis.renameFolderURL, params: paramDict as Dictionary) { (response) in
            if response!.success {
                if let dictData = response!.data {
                    let error = dictData["errorMsg"] as? String ?? FormatsString.emptyString
                    if error.isEmpty {
                        let status = dictData["responseStatus"] as? Bool ?? false
                        if status {
                            completion(status)
                        } else {
                            completion(status)
                        }
                    }
                }
            }
        }
    }
    func createUpdateFolder(withPattern: String = FormatsString.emptyString, forUpdateFolder: Bool = false, folderName: String, completion: @escaping (_ ResponseDict: Bool) -> Void) {
        if folderName.lowercased() == "favorites" || folderName.lowercased() == "owned" {
            ServiceManagerProxy.shared.displayerrorPopup(url: Apis.createUpdateFolderURL, responseError: MessageString.folderAlreadyExist)
        } else if self.myFolderArray.map({$0.lowercased()}).contains("\(folderName.lowercased())") && !forUpdateFolder {
            ServiceManagerProxy.shared.displayerrorPopup(url: Apis.createUpdateFolderURL, responseError: MessageString.folderAlreadyExist)
        } else {
            let designPatternArray = ["\(withPattern)"] as NSArray
            let folderConfigDict = ["\(folderName)": withPattern != FormatsString.emptyString ? designPatternArray: []] as NSDictionary
            let paramDict = ["OrderFilter": ["purchasedPattern": FolderAttribute.purchasedPattern,
                                              "subscriptionList": FolderAttribute.subscriptionList,
                                              "allQuery": FolderAttribute.allQuery,
                                              "trialPattern": FolderAttribute.trialPattern,
                                              "emailID": "\(CommonConst.loginEmailText)"],
                             "FoldersConfig": folderConfigDict] as [String: Any]
            ServiceManagerProxy.shared.postData(urlStr: Apis.createUpdateFolderURL, params: paramDict as Dictionary) { (response) in
                if response!.success {
                    if let dictData = response!.data {
                        let error = dictData["errorMsg"] as? String ?? FormatsString.emptyString
                        if error.isEmpty {
                            let status = dictData["responseStatus"] as? Bool ?? false
                            if status {
                                completion(status)
                            } else {
                                completion(status)
                            }
                        }
                    }
                }
            }
        }
    }
    func removeFolder(folderName: String, completion: @escaping (_ ResponseDict: Bool) -> Void) {
        let paramDict = ["OrderFilter": ["purchasedPattern": FolderAttribute.purchasedPattern,
                                          "subscriptionList": FolderAttribute.subscriptionList,
                                          "allQuery": FolderAttribute.allQuery,
                                          "trialPattern": FolderAttribute.trialPattern,
                                          "emailID": "\(CommonConst.loginEmailText)"],
                         "FoldersConfig": ["\(folderName)": []]] as [String: Any]
        ServiceManagerProxy.shared.postData(urlStr: Apis.removeFoldeURL, params: paramDict as Dictionary) { (response) in
            if response!.success {
                if let dictData = response!.data {
                    let error = dictData["errorMsg"] as? String ?? FormatsString.emptyString
                    if error.isEmpty {
                        let status = dictData["responseStatus"] as? Bool ?? false
                        if status {
                            completion(status)
                        } else {
                            completion(status)
                        }
                    }
                }
            }
        }
    }
    func onClickFolder(folderName: String, completion: @escaping (_ ResponseDict: [String: AnyObject]) -> Void) {
        var orderFilter = [String: Any]()
        if folderName == "\(FormatsString.favorite)s" {
            orderFilter["purchasedPattern"] = FavFolderAttribute.purchasedPattern
            orderFilter["subscriptionList"] = FavFolderAttribute.subscriptionList
            orderFilter["allQuery"] = FavFolderAttribute.allQuery
            orderFilter["FolderName"] = FormatsString.favorite
            orderFilter["trialPattern"] = FavFolderAttribute.trialPattern
        } else {
            orderFilter["purchasedPattern"] = OnClickFolderAttribute.purchasedPattern
            orderFilter["subscriptionList"] = folderName == "Owned" ? false : OnClickFolderAttribute.subscriptionList
            if folderName == "Owned"{
                orderFilter["allQuery"] = false
                orderFilter["FolderName"] = FormatsString.emptyString
            } else {
                orderFilter["allQuery"] = OnClickFolderAttribute.allQuery
                orderFilter["FolderName"] = "\(folderName)"
            }
            orderFilter["trialPattern"] = OnClickFolderAttribute.trialPattern
        }
        orderFilter["emailID"] = "\(CommonConst.loginEmailText)"
        let paramDict = ["OrderFilter": orderFilter, "pageId": FormatsString.oneLabel, "patternsPerPage": FormatsString.patternsPerPageCount, "searchTerm": FormatsString.emptyString, "ProductFilter": []] as [String: Any]
        ServiceManagerProxy.shared.postData(urlStr: Apis.onClickFolderURL, params: paramDict as Dictionary) { (response) in
            if response!.success {
                if let dictData = response!.data {
                    let error = dictData["errorMsg"] as? String ?? FormatsString.emptyString
                    if error.isEmpty {
                        self.objMylibData.prod.removeAll()
                        self.objMylibData.setMyLibraryData(dictData: dictData)
                        completion(dictData)
                    }
                }
            }
        }
    }
    // MARK: - Update Favourite
    func updateFavouritePattern(params: [String: Any], updateStatus: String, completion: @escaping (_ ResponseDict: [String: AnyObject]) -> Void) {   // Hit Favorite Pattern API and update the favorite pattern in server
        ServiceManagerProxy.shared.postData(urlStr: "\(Apis.updateFavouriteURL)\(updateStatus)", params: params as Dictionary) { (response) in
            if response!.success {
                if let dictData = response!.data {
                    let error = dictData["errorMsg"] as? String ?? FormatsString.emptyString
                    if error.isEmpty {
                        completion(dictData)
                    }
                }
            }
        }
    }
    func setofflineData(trailArray: [PatternModelObject]) {   // Set Offline patterns when Network is turned of
        self.offlinePattern.removeAll()
        if !trailArray.isEmpty {
            _ = trailArray.map({ (trailPattern) in
                if trailPattern.designID != CommonConst.offlineDesignIdText {
                    let offlinepatt = MyLibraryPatterns()
                    offlinepatt.name = trailPattern.patternName
                    offlinepatt.prodDescription = trailPattern.tailornovaDescription
                    offlinepatt.image = trailPattern.patternDescriptionImageURL
                    offlinepatt.tailornovaDesignID = trailPattern.designID
                    offlinepatt.patternType = trailPattern.patternType
                    offlinepatt.customization = (trailPattern.customization) ? FormatsString.oneLabel : FormatsString.zeroLabel
                    offlinepatt.type.append(trailPattern.type)
                    offlinepatt.seasons.append(trailPattern.season)
                    offlinepatt.occasion = trailPattern.occasion
                    offlinepatt.suitableFor = trailPattern.suitableFor
                    offlinepatt.size = trailPattern.size
                    offlinepatt.gender = trailPattern.gender
                    offlinepatt.brand = trailPattern.brand
                    offlinepatt.tailornovaDesignName = trailPattern.patternName
                    offlinepatt.status = FormatsString.Trial
                    offlinepatt.selectedTabCategory = FormatsString.garment
                    offlinepatt.lastModifiedSizeDate = FormatsString.emptyString
                    offlinepatt.customSizeFitName = FormatsString.emptyString
                    offlinepatt.selectedSizeName = FormatsString.emptyString
                    offlinepatt.selectedViewCupSizeName = FormatsString.emptyString
                    offlinepatt.id = FormatsString.emptyString
                    var dropDetailsArray = [DropPiecesDetails]()
                    let context = DatabaseHelper().managedObjectContext
                    let fetchRequest: NSFetchRequest<Pattern> = Pattern.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "tailornovadesignID == %@", trailPattern.designID)
                    do {
                        let objects = try context.fetch(fetchRequest)
                        if !objects.isEmpty {
                            if let patternEntity = objects[0] as Pattern? {
                                for item in patternEntity.dropPiecesDetails?.allObjects as! [DropPiecesDetails] {
                                    if let patternPiece = item as DropPiecesDetails? {
                                        dropDetailsArray.append(patternPiece)
                                    }
                                }
                            }
                        }
                    } catch _ {
                    }
                    for item in dropDetailsArray {
                        if let drop = item as DropPiecesDetails? {
                            let dropObject =  UserDefaultWSSaveModel()
                            dropObject.idVal = Int(drop.idVal)
                            dropObject.tailornovaIndex = Int(drop.tailornovaIndex)
                            dropObject.tabCategory = drop.tabCategory!
                            dropObject.xcor = drop.xVal
                            dropObject.ycor = drop.yVal
                            dropObject.centerX = drop.centerX
                            dropObject.centerY = drop.centerY
                            dropObject.transformD = drop.transformD
                            dropObject.transformA = drop.transformA
                            dropObject.isRotated = drop.isRotated
                            dropObject.rotatedAngle = drop.rotatedAngle
                            dropObject.patternTitle = drop.patternName!
                            dropObject.patternType = drop.patternType!
                            dropObject.currentSplicedPieceRow = drop.currentSplicedPieceRow
                            dropObject.currentSplicedPieceColumn = drop.currentSplicedPieceColumn
                            dropObject.showMirrorDialog = drop.showMirrorDialog
                            offlinepatt.dropPieceArray.append(dropObject)
                        }
                    }
                    self.offlinePattern.append(offlinepatt)
                }
            })
        }
        _ = self.patternDBArray.map { (pattern)  in
            if pattern.tailornovadesignID == CommonConst.offlineDesignIdText {
                let offlinepatt = MyLibraryPatterns()
                let arr: [Mannequin] = pattern.mannequins?.allObjects as! [Mannequin]
                for item in arr {
                    if let maniq = item as Mannequin? {
                        let maniqObject =  MannequinIDObject()
                        maniqObject.mannequinID = maniq.id ?? FormatsString.emptyString
                        maniqObject.mannequinName = maniq.name ?? FormatsString.emptyString
                        offlinepatt.mannequinIDArray.append(maniqObject)
                    }
                }
                let arry: [DropPiecesDetails] = pattern.dropPiecesDetails?.allObjects as! [DropPiecesDetails]
                for item in arry {
                    if let drop = item as DropPiecesDetails? {
                        let dropObject =  UserDefaultWSSaveModel()
                        dropObject.idVal = Int(drop.idVal)
                        dropObject.tailornovaIndex = Int(drop.tailornovaIndex)
                        dropObject.tabCategory = drop.tabCategory!
                        dropObject.xcor = drop.xVal
                        dropObject.ycor = drop.yVal
                        dropObject.centerX = drop.centerX
                        dropObject.centerY = drop.centerY
                        dropObject.transformD = drop.transformD
                        dropObject.transformA = drop.transformA
                        dropObject.isRotated = drop.isRotated
                        dropObject.rotatedAngle = drop.rotatedAngle
                        dropObject.patternTitle = drop.patternName!
                        dropObject.patternType = drop.patternType!
                        dropObject.currentSplicedPieceRow = drop.currentSplicedPieceRow
                        dropObject.currentSplicedPieceColumn = drop.currentSplicedPieceColumn
                        dropObject.showMirrorDialog = drop.showMirrorDialog
                        offlinepatt.dropPieceArray.append(dropObject)
                    }
                }
                offlinepatt.name = pattern.patternTitle ?? FormatsString.emptyString
                offlinepatt.notes = pattern.addNotes ?? FormatsString.emptyString
                offlinepatt.prodDescription = pattern.patternInstruction ?? FormatsString.emptyString
                offlinepatt.yardagedetails = pattern.yardagedetails ?? FormatsString.emptyString
                offlinepatt.notiondetails = pattern.notiondetails ?? FormatsString.emptyString
                offlinepatt.yardagePdfUrl = pattern.yardagePdfUrl ?? FormatsString.emptyString
                offlinepatt.image = pattern.patternImage ?? FormatsString.emptyString
                offlinepatt.orderNo = pattern.orderNo ?? FormatsString.emptyString
                offlinepatt.purchasedSizeID = pattern.purchasedSizeID ?? FormatsString.emptyString
                offlinepatt.tailornovaDesignID = pattern.tailornovadesignID ?? FormatsString.emptyString
                offlinepatt.patternType = pattern.patternType ?? FormatsString.emptyString
                offlinepatt.subscriptionExpiryDate = pattern.subscriptionExpiryDate ?? FormatsString.emptyString
                offlinepatt.tailornovaDesignName = pattern.tailornovaDesignName ?? FormatsString.emptyString
                offlinepatt.status = ((pattern.status == FormatsString.new) ? FormatsString.OWNED: pattern.status) ?? FormatsString.emptyString
                offlinepatt.size = pattern.patternSize ?? FormatsString.emptyString
                offlinepatt.brand = pattern.patternBrand ?? FormatsString.emptyString
                offlinepatt.selectedTabCategory = pattern.selectedTabCategory ?? FormatsString.emptyString
                offlinepatt.lastModifiedSizeDate = pattern.lastModifiedSizeDate ?? FormatsString.emptyString
                offlinepatt.customSizeFitName = pattern.customSizeFitName ?? FormatsString.emptyString
                offlinepatt.selectedSizeName = pattern.selectedSizeName ?? FormatsString.emptyString
                offlinepatt.selectedViewCupSizeName = pattern.selectedViewCupSizeName ?? FormatsString.emptyString
                offlinepatt.id = pattern.productId ?? FormatsString.emptyString
                self.offlinePattern.append(offlinepatt)
            }
        }
    }
    func retrieveImage(forKey key: String, inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem: break   // Retrieve image from disk
        case .userDefaults:
            if let imageData = CommonConst.userDefault.object(forKey: key) as? Data {
                let image = UIImage(data: imageData)
                return image
            }
        }
        return UIImage()
    }
}
