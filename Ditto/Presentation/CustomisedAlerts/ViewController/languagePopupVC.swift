//
//  languagePopupVC.swift
//  Ditto
//
//  Created by Kune Rohith on 14/07/23.
//  Copyright © 2023 Infosys. All rights reserved.
//

//Rohith
//new class for  Popup of multi language option

import UIKit

class languagePopupVC: UIViewController {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var alertView: UIView!

    @IBOutlet var tittleLabel: UILabel!
    @IBOutlet var englishBtn: UIButton!
    @IBOutlet var frenchBtn: UIButton!
    
    var onFrenchTapped: (() -> Void )?
    var onEnglishTapped: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func frenchbtntapped(_ sender: UIButton) {
        self.onFrenchTapped?()
    }
    
    @IBAction func englishBtnTapped(_ sender: Any) {
        self.onEnglishTapped?()

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
