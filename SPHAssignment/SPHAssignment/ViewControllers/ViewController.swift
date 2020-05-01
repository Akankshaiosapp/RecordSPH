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
var results: [Record] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = DataRequest()
            data.getSearchResults(completion: { results, errorMessage in
              if let result = results {
                self.results = result
                for  res in self.results {
                    print(res.quarter)
                    print(res.volumeOfMobileData)
                }
              }

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
        return 10
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecordTableViewCell else {
                         return UITableViewCell()
                      }
        return cell
    }
}
