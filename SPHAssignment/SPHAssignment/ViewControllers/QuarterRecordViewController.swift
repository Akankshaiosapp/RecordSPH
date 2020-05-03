
//  Created by Akanksha Thakur on 2/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.
//

import UIKit

class QuarterRecordViewController: UIViewController {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var q1Label: UILabel!
    @IBOutlet weak var q1DataLabel: UILabel!
    @IBOutlet weak var q2Label: UILabel!
    @IBOutlet weak var q2DataLabel: UILabel!
    @IBOutlet weak var q3Label: UILabel!
    @IBOutlet weak var q3DataLabel: UILabel!
    @IBOutlet weak var q4Label: UILabel!
    @IBOutlet weak var q4DataLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.backgroundColor = #colorLiteral(red: 0.9274971203, green: 1, blue: 0.8045932644, alpha: 1)
        cardView.layer.masksToBounds = false
        cardView.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.23
        cardView.layer.shadowRadius = 4
        cardView.layer.cornerRadius = 8
        q1Label.text = "Q1"
        q2Label.text = "Q2"
        q3Label.text = "Q3"
        q4Label.text = "Q4"
        /// Set data quarterly
        yearLabel.text = year
        q1DataLabel.text = q1
        q2DataLabel.text = q2
        q3DataLabel.text = q3
        q4DataLabel.text = q4
        ///
        /// Add the logic to heighlight the row if the quarter showing decrease in data.
        ///
        if let first = q1?.toDouble(),
            let second = q2?.toDouble(),
            let third = q3?.toDouble(),
            let forth = q4?.toDouble()
        {
            if first > second {
            q2DataLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.753464313, blue: 0.8226654866, alpha: 1)
            }
            if second > third {
            q3DataLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.753464313, blue: 0.8226654866, alpha: 1)
            }
            if third > forth {
            q4DataLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.753464313, blue: 0.8226654866, alpha: 1)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    /// Set selected year
    public var year: String? {
        didSet {
            if yearLabel != nil {
                yearLabel.text = year
            }
        }
    }
    /// Set quarter 1 data
    public var q1: String? {
        didSet {
            if q1DataLabel != nil {
                q1DataLabel.text = q1
            }
        }
    }
    /// Set quarter 2 data
    public var q2: String? {
        didSet {
            if q2DataLabel != nil {
                q2DataLabel.text = q2
            }
        }
    }
    /// Set quarter 3 data
    public var q3: String? {
        didSet {
            if q3DataLabel != nil {
                q3DataLabel.text = q3
            }
        }
    }
    /// Set quarter 4 data
    public var q4: String? {
        didSet {
            if q4DataLabel != nil {
                q4DataLabel.text = q4
            }
        }
    }
}
