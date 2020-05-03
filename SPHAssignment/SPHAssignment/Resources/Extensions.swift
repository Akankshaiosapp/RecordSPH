
//  Created by Akanksha Thakur on 3/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
