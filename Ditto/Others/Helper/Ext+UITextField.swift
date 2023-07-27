//
//  Ditto
//
//  Created by Gaurav Rajan on 21/03/21.
//

import UIKit

extension UITextField {
    var isBlank: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
}
extension String {
    var isBlank: Bool {
        return (self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
}
