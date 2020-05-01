
//  Created by Akanksha Thakur on 1/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.23
        shadowView.layer.shadowRadius = 4
        shadowView.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
