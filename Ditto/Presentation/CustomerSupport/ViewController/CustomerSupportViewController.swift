//
//  CustomerSupportViewController.swift
//  Ditto
//
//  Created by Neb Shaw on 5/10/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class CustomerSupportViewController: UIViewController {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: VARIABLE DECLARATION 
    var customerSupportViewModel = CustomerSupportViewModel()
    var touchFlag: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavTitle()
        self.title = FormatsString.customerSupportLabel
        self.customerSupportViewModel.spaceBetweenCells = UIDevice.isPad ? 30 : 16
        Proxy.shared.registerCollViewNib(self.collectionView, nibName: ReusableCellIdentifiers.customerSupportCellIdentifier, identifierCell: ReusableCellIdentifiers.customerSupportCellIdentifier)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.touchFlag = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
