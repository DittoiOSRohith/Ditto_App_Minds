//
//  AddNotesViewController.swift
//  Ditto
//
//  Created by Gokul Ramesh on 29/03/23.
//  Copyright © 2023 Infosys. All rights reserved.
//

import UIKit

class AddNotesViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    //MARK: VARIABLE DECLARATION
    var SavedNotes: ((_ notes: String)->Void)?
    var receivedSavedNotes = String()
    var numberOfLetters: Int? {
        willSet (totalChar) {
            if let TotalTextCount = totalChar, TotalTextCount <= numberOfQuickNotesWords {
                self.textCountLabel.text = "\(TotalTextCount)" + "/" + "\(numberOfQuickNotesWords)"
            } else {
                print("The Char limit got exceeded")
            }
        }
    }
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.15, delay: 0) {
            self.view.backgroundColor = .black.withAlphaComponent(0.7)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.view.backgroundColor = .clear
        }
    }
    func setUI() {
        self.textCountLabel.text = "\(self.notesTextView.text.count)" + "/" + "\(numberOfQuickNotesWords)"
        _ = self.receivedSavedNotes.isEmpty ? self.setPlaceHolder() : self.setPreviouslySavedNotes(notes: receivedSavedNotes)
     }
    func setPlaceHolder() {
        self.notesTextView.text = FormatsString.EnterYourNotes
        self.notesTextView.textColor = .lightGray
        self.textCountLabel.text = "0" + "/" + "\(numberOfQuickNotesWords)"
    }
    func setPreviouslySavedNotes(notes: String) {
        self.notesTextView.text = notes
        self.notesTextView.textColor = AppColor.needleGrey
//        let responseTxt = notes.replacingOccurrences(of: "\n", with: "")
        self.textCountLabel.text = "\(self.notesTextView.text.count)" + "/" + "\(numberOfQuickNotesWords)"
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func didClickClearButton(_ sender: Any) {
        self.setPlaceHolder()
        self.textCountLabel.text = "0" + "/" + "\(numberOfQuickNotesWords)"
    }
    @IBAction func didClickAddButton(_ sender: UIButton) {
        self.SavedNotes?(self.notesTextView.text != FormatsString.EnterYourNotes ? self.notesTextView.text : FormatsString.emptyString)
        self.dismiss(animated: true)
    }
    @IBAction func didClickCloseButton(_ sender: Any) {
//        self.SavedNotes?(self.notesTextView.text != FormatsString.EnterYourNotes ? self.receivedSavedNotes : FormatsString.emptyString)
        self.SavedNotes?(self.receivedSavedNotes)
        self.dismiss(animated: true)
    }
}
