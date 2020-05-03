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
    //
    // MARK: - Variables And Properties
    //
    var YearWiseData: [[String: [[String: String]]]] = []
    var results: [Record] = []
    var years: [String] = ["2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018"]
    ///
    /// View did load
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = DataRequest()
        data.getResults(completion: { results, errorMessage in
            ///
            /// Get the results from Api request or fetch from  core data for offline usage
            ///
            if let result = results, results?.count ?? 0 > 0 {
                 self.results = result
            } else {
                if self.results.count == 0 {
                    if let data = getRequest() {
                       if data.count > 0 {
                        for res in data {
                            self.results.append(Record(id: Int(res.id), quarter: res.quarter!, volumeOfMobileData: res.data!))
                        }
                    } 
                    }
                }
            }
            self.extractData()
            self.tableView.reloadData()
            if !errorMessage.isEmpty {
                print("Error: " + errorMessage)
            }
        })
    }
    fileprivate func extractData() {
        for  res in self.results {
            let component = res.quarter.components(separatedBy: "-")
            switch component[0] {
            case "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018":
                ///
                /// Extract the data  for 2008 to 2018 year
                ///
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
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.YearWiseData.count
    }
    
    fileprivate func showQuarterData(_ cell: RecordTableViewCell, _ q1: Double, _ q2: Double, _ q3: Double, _ q4: Double) {
        ///
        /// Show the pop up on image view click
        ///
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
                ///
                /// Present the view to show quarter data
                ///
                self.present(vc, animated: true, completion: nil)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecordTableViewCell else {
            return UITableViewCell()
        }
        ///
        /// Get quarter data
        ///
        let q1 = self.YearWiseData[indexPath.section][self.years[indexPath.section]]![0]["Q1"]!.toDouble()!
        let q2 = self.YearWiseData[indexPath.section][self.years[indexPath.section]]![1]["Q2"]!.toDouble()!
        let q3 = self.YearWiseData[indexPath.section][self.years[indexPath.section]]![2]["Q3"]!.toDouble()!
        let q4 = self.YearWiseData[indexPath.section][self.years[indexPath.section]]![3]["Q4"]!.toDouble()!
        cell.shadowView.backgroundColor = #colorLiteral(red: 0.9530798106, green: 0.9772792079, blue: 1, alpha: 1)
        cell.year.text = years[indexPath.section]
        ///
        /// Get total year data
        ///
        cell.data.text = String(q1 + q2 + q3 + q4)
        ///
        /// Set tag for image view
        ///
        cell.rightImageView.tag = indexPath.section
        ///
        /// Logic to set green and red images
        ///
        if (q1 <= q2 && q2 <= q3 && q3 <= q4) {
            cell.rightImageView.image = UIImage(named: "greentriangle")
            
        } else {
            cell.rightImageView.image = UIImage(named: "redtriangle")
        }
        ///
        /// Show quarter wise data for the selected year
        ///
        showQuarterData(cell, q1, q2, q3, q4)
        return cell
    }
}
