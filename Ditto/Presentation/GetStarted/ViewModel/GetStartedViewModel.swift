//
//  getStartedViewModel.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import Foundation
import RxSwift

class GetStartedViewModel {
    //MARK: VARIABLE DECLARATION
    var isFromWorkspace = false
    var isFromCalibFailure = false
    var isPresentedFromWorkSpace = false
    let disposeBag = DisposeBag()
    var tutorialModel: Tutorial?
    var getStartedTileArray = [GetStartedCollectionModel]()
    let interactor = MainContainer.sharedContainer.container.resolve(GetStartedUseCaseInteractorProtocol.self)
    func fetchAllTutorialInstructionsFromDataBase(completion: @escaping() -> Void) {  //  Logic to fetch the instructions saved in Database
        guard let updateManager = interactor else {fatalError("Missing Dependencies")}
        updateManager.fetchGetStartedData().fetchTutorialsInstructionsFromDb().observe(on: MainScheduler.instance).subscribe(onNext: { data in
            self.getStartedTileArray.removeAll()
            _ = data.map { (instruction)  in
                let instructionObject = GetStartedCollectionModel()
                instructionObject.tileTitle = instruction.insOverviewTitle ?? FormatsString.emptyString
                instructionObject.tileDescription = instruction.instructionOverviewDescription ?? FormatsString.emptyString
                instructionObject.tileImage = instruction.instructionOverviewImagePath ?? FormatsString.emptyString
                self.getStartedTileArray.append(instructionObject)
            }
            completion()
        }, onError: { _ in
        }, onCompleted: {
        }, onDisposed: {
        }).disposed(by: disposeBag)
    }
    func getArrayForOnboardingScreen() -> [GetStartedCollectionModel] {   // Onboarding screen text and images fetched to array logic
        let getArray = self.getStartedTileArray
        self.getStartedTileArray.removeAll()
        for objects in getArray where !self.getStartedTileArray.contains(where: {$0.tileTitle == objects.tileTitle}) {
            self.getStartedTileArray.append(objects)
        }
        return self.getStartedTileArray
    }
    func getContentForGetStartedAndTutorials(completion: @escaping(Tutorial) -> Void) {  // Content of tutorials and getstarted is fetched from API and saved to database when app is launched for first time.
        ServiceManagerProxy.shared.getData(urlStr: "\(ApiUrlStrings.getStartedURL)\(AppKeys.clientKeyServerAuth)", forpatternDesc: false) { response in
            if let resp = response {
                if resp.success {
                    DispatchQueue.main.async {
                        Proxy.shared.dismissLottie()
                    }
                    if resp.data != nil, let jsonData = resp.jsonData {
                        let jsonDecoder = JSONDecoder()
                        do {
                            self.tutorialModel = try jsonDecoder.decode(Tutorial.self, from: jsonData)
                            if let onboardingArray: [Onboarding] = self.tutorialModel?.tutorialContent!.onboardingg {
                                for onboard in onboardingArray {
                                    let instructionItemArray: [InstructionItem] = onboard.instructionss
                                    let instructionOverViewTitle = onboard.titlee
                                    let instructionOverViewDescription = onboard.descriptionn
                                    let instructionOverImagePath  = onboard.imagePathh
                                    let instructionType = onboard.titlee
                                    var tabIndexItem = 0
                                    var tabNameItem = FormatsString.emptyString
                                    _ = instructionItemArray.enumerated().map { (index, instructionObjon)  in
                                        tabIndexItem = index
                                        tabNameItem = instructionObjon.titlee
                                        if instructionType != TutorialDataFetchType.beamSetup && instructionType != TutorialDataFetchType.howTo {
                                            self.saveIntructionToDb(instructionItem: instructionObjon, instructionType: instructionType, mainTitle: instructionOverViewTitle, mainImagePath: instructionOverImagePath, mainDescription: instructionOverViewDescription, tabIndex: FormatsString.emptyString, tabName: FormatsString.emptyString)
                                        } else {
                                            let instructionArray: [InstructionItem] = instructionObjon.instructionss
                                            for instructionObj in instructionArray {
                                                self.saveIntructionToDb(instructionItem: instructionObj, instructionType: instructionType, mainTitle: instructionOverViewTitle, mainImagePath: instructionOverImagePath, mainDescription: instructionOverViewDescription, tabIndex: "\(tabIndexItem)", tabName: "\(tabNameItem)")
                                            }
                                        }
                                    }
                                }
                                completion(self.tutorialModel!)
                            }
                        } catch {
                        }
                    }
                }
            }
        }
    }
    func saveIntructionToDb(instructionItem: InstructionItem, instructionType: String, mainTitle: String, mainImagePath: String, mainDescription: String, tabIndex: String, tabName: String) {  // saving contents to Database logic
        let dictionary1 = ["instructionTitle": "\(instructionItem.titlee)", "instructionType": "\(instructionType)", "instructionDescription": "\(instructionItem.descriptionn.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<br/>", with: "\n"))", "instructionImage": "\(String(describing: instructionItem.imagePathh))", "tabIndex": "\(tabIndex)", "tabName": "\(tabName)", "instructionVideoPath": "\(instructionItem.videoPathh)", "insOverviewTitle": "\(mainTitle)", "instructionOverviewDescription": "\(mainDescription)", "instructionOverviewImagePath": "\(mainImagePath)", "tutorialPdfUrl": "\(instructionItem.tutorialPdfUrll)"]
        DatabaseHelper().insertNewRecordIntoEntity(DBEntities.instructionDb, withDict: dictionary1 as [String: AnyObject])
    }
}
