
//  Created by Akanksha Thakur on 1/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.
//

import Foundation

//
// MARK: - Records
//

/// Query service creates record objects
class Record {
  //
  // MARK: - Constants
  //
  let id: Int
  let quarter: String
  let volumeOfMobileData: String
  
  // MARK: - Initialization
  //
  init(id: Int, quarter: String, volumeOfMobileData: String) {
    self.id = id
    self.quarter = quarter
    self.volumeOfMobileData = volumeOfMobileData
  }
}
