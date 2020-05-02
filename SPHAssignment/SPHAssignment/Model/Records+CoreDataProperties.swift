
//  Created by Akanksha Thakur on 2/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.
//
//

import Foundation
import CoreData


extension Records {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Records> {
        return NSFetchRequest<Records>(entityName: "Records")
    }

    @NSManaged public var quarter: String?
    @NSManaged public var id: Int64
    @NSManaged public var data: String?

}
