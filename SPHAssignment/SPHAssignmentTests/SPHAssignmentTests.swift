
//  Created by Akanksha Thakur on 1/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.
//

import XCTest
@testable import SPHAssignment

class SPHAssignmentTests: XCTestCase {
    // MARK: - Constants
    //
    let defaultSession = URLSession(configuration: .default)
    let views = ViewController()
    
    //
    // MARK: - Variables And Properties
    //
    var responses: JSONDictionary?
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var YearWiseData: [[String: [[String: String]]]] = []
    var results: [Record] = []
    var years: [String] = ["2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018"]
    
    // MARK: - Type Alias
    //
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Record]?, String) -> Void
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testDownloadData() {
        
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Download mobile data")
        if Reachability.isConnectedToNetwork(){
            
            dataTask?.cancel()
            if let urlComponents = URLComponents(string: "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f") {
                
                guard let url = urlComponents.url else {
                    return
                }
                dataTask = defaultSession.dataTask(with: url) { data, response, error in
                    defer {
                        self.dataTask = nil
                    }
                    if let error = error {
                        XCTFail(error.localizedDescription)
                    } else if
                        let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        XCTAssertNotNil(data)
                        expectation.fulfill()
                    }
                }
                dataTask?.resume()
            }
        }
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    func testReadJsonFile() {
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Download mobile data")
        
        if let path = Bundle.main.path(forResource: "Record", ofType: "json") {
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                XCTAssertNotNil(data)
                expectation.fulfill()
                results.removeAll()
                do {
                    responses = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                } catch let parseError as NSError {
                    XCTFail(parseError.localizedDescription)
                    return
                }
                guard let array = responses!["result"] as? [String: Any] else {
                    XCTFail("Does not contain result")
                    return
                }
                guard let newarr = array["records"] as? [Any] else {
                    XCTFail("Does not contain records")
                    return
                }
                for trackDictionary in newarr {
                    if let trackDictionary = trackDictionary as? [String: Any],
                        let id = trackDictionary["_id"] as? Int,
                        let quarter = trackDictionary["quarter"] as? String,
                        let mobileData = trackDictionary["volume_of_mobile_data"] as? String{
                        results.append(Record(id: id, quarter: quarter, volumeOfMobileData: mobileData))
                    }
                }
                XCTAssertNotNil(results)
                extractData()
                XCTAssertNotNil(years)
                XCTAssertNotNil(YearWiseData)
                views.years = years
                views.results = results
                views.YearWiseData = YearWiseData
                
            } catch let error as NSError {
                XCTFail(error.localizedDescription)
                return
            }
        }
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
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
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
