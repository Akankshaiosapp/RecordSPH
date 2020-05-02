//
//  ViewController.swift
//  SPHAssignment
//
//  Created by Akanksha Thakur on 1/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var YearWiseData: [[String: [[String: String]]]] = []
    var results: [Record] = []
    var years: [String] = ["2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = DataRequest()
        data.getSearchResults(completion: { results, errorMessage in
            if let result = results {
                self.results = result
                for  res in self.results {
           let component = res.quarter.components(separatedBy: "-")
             switch component[0] {
             case "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018":
                 if self.YearWiseData.count > 0 {
                    if (self.YearWiseData[self.YearWiseData.count - 1][component[0]] != nil) {
                        var data: [[String: String]] = self.YearWiseData[self.YearWiseData.count - 1][component[0]]!
                        print("data is \(data)")
                        data.append([component[1]: res.volumeOfMobileData])
                        self.YearWiseData[self.YearWiseData.count - 1][component[0]] = data
                     } else {
                         self.YearWiseData.append([component[0] : [[component[1]: res.volumeOfMobileData]]])
                     }
                 } else {
                    self.YearWiseData.append([component[0] : [[component[1]: res.volumeOfMobileData]]])
                 }
             default:
                 print("")
             }
                    print("YearWiseData \(self.YearWiseData)")
                    
                }
            }
            self.tableView.reloadData()
            if !errorMessage.isEmpty {
                print("Error: " + errorMessage)
            }
        })
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.YearWiseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecordTableViewCell else {
            return UITableViewCell()
        }
        let q1 = self.YearWiseData[indexPath.section][self.years[indexPath.section]]![0]["Q1"]!.toDouble()!
        let q2 = self.YearWiseData[indexPath.section][self.years[indexPath.section]]![1]["Q2"]!.toDouble()!
        let q3 = self.YearWiseData[indexPath.section][self.years[indexPath.section]]![2]["Q3"]!.toDouble()!
        let q4 = self.YearWiseData[indexPath.section][self.years[indexPath.section]]![3]["Q4"]!.toDouble()!
        cell.shadowView.backgroundColor = #colorLiteral(red: 0.9530798106, green: 0.9772792079, blue: 1, alpha: 1)
        cell.year.text = years[indexPath.section]
        cell.data.text = String(q1 + q2 + q3 + q4)
        cell.rightImageView.tag = indexPath.section
        
        if (q1 <= q2 && q2 <= q3 && q3 <= q4) {
            cell.rightImageView.image = UIImage(named: "greentriangle")
            
        } else {
            cell.rightImageView.image = UIImage(named: "redtriangle")
        }
        cell.actionClickHandler = { tagName in
            print(tagName)
          self.dismiss(animated: true, completion: {
                let vc = QuarterRecordViewController()
                 print(tagName)
                vc.year = self.years[tagName]
                vc.q1 = String(q1)
                vc.q2 = String(q2)
                vc.q3 = String(q3)
                vc.q4 = String(q4)
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            })
        }
        return cell
    }
}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
