
//  Created by Akanksha Thakur on 1/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    public typealias ActionClickHandler = (_ tag: Int) -> Void
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.23
        shadowView.layer.shadowRadius = 4
        shadowView.layer.cornerRadius = 8
        ///
        ///Add tap event on Image View to show quarter data in pop up and heighlight the row if data is decreasing.
        ///
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.clickOnTopRightImage))
        self.rightImageView.addGestureRecognizer(gesture)
        self.rightImageView.isUserInteractionEnabled = true
    }
  public var actionClickHandler: ActionClickHandler?
     @objc func clickOnTopRightImage(sender : UITapGestureRecognizer) {
           if let handler = self.actionClickHandler {
            handler(rightImageView.tag)
            }
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
