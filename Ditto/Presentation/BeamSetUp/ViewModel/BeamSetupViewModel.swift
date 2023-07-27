//
//  BeamSetupViewModel.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import  RxSwift

class BeamSetupViewModel {
    //MARK: VARIABLE DECLARATION
    var imagvPopUp = UIImageView()
    let popupBackground = UIView()
    var resourceName = FormatsString.emptyString
    var beamCurrentIndex = 0
    var typeofScreen = TutorialDataFetchType.beamSetup
    var selectedIndex = FormatsString.zeroLabel
    var selectedSegment = FormatsString.zeroLabel
    var isFromCalibration: Bool = false
    var initial: Int = 0
    var ishandleBackForCamera = false
    let disposeBag = DisposeBag()
    var instructionsArray = [InstructionObject]()
    let beamSetUpInteractor = MainContainer.sharedContainer.container.resolve(BeamSetUpUseCaseInteractorProtocol.self)
    var fetchType = FormatsString.emptyString
    var fromScreenType = FromScreenType.getStartedd.rawValue
    //  FUNCTION LOGICS
    func fetchInstructionFormDataBase(completion: @escaping() -> Void) {    // Fetching already saved tutorial data from DB
        guard let beamSetUpManager = beamSetUpInteractor else { fatalError("Missing Dependencies")}
        beamSetUpManager.fetchInstrunctionfromDataBase().fetchInstructionsFromDataBase(fetchType: fetchType)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {data in
                self.instructionsArray.removeAll()
                _ = data.map { (instruction)  in
                    let instructionObject = InstructionObject()
                    instructionObject.instructionTitle = instruction.instructionTitle ?? FormatsString.emptyString
                    instructionObject.instructionDescription = instruction.instructionDescription ?? FormatsString.emptyString
                    instructionObject.instructionType = instruction.instructionType ?? FormatsString.emptyString
                    instructionObject.instructionImage = instruction.instructionImage ?? FormatsString.emptyString
                    instructionObject.instructionVdoPath = instruction.instructionVideoPath ?? FormatsString.emptyString
                    instructionObject.tabIndex = instruction.tabIndex ?? FormatsString.emptyString
                    instructionObject.tutorialPdfUrl = instruction.tutorialPdfUrl ?? FormatsString.emptyString
                    instructionObject.tabName = instruction.tabName ?? FormatsString.emptyString
                    self.instructionsArray.append(instructionObject)
                }
                completion()
            },
            onError: { _ in
            },
            onCompleted: {
            },
            onDisposed: {
            })
            .disposed(by: disposeBag)
    }
    func getArrayForSelectedIndex(selectedTabIndex: String, type: String) -> [InstructionObject] {   // Fetching array with given tab index and type
        let array = self.instructionsArray.filter {($0.tabIndex == selectedTabIndex) && ($0.instructionType == type)}
        return array
    }
}
