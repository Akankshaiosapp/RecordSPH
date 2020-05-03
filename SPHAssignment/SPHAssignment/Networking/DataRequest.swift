
//  Created by Akanksha Thakur on 1/5/20.
//  Copyright © 2020 Akanksha Thakur. All rights reserved.

import Foundation

class DataRequest {
    // MARK: - Constants
    //
    let defaultSession = URLSession(configuration: .default)
    
    //
    // MARK: - Variables And Properties
    //
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var records: [Record] = []
    
    // MARK: - Type Alias
    //
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Record]?, String) -> Void
    //
    // MARK: - Internal Methods
    //
    
    func getResults(completion: @escaping QueryResult) {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        
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
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.extractData(data)
                    DispatchQueue.main.async {
                        completion(self.records, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
        } else{
                if let data = getRequest() {
                    if data.count > 0 {
                    for res in data {
                        self.records.append(Record(id: Int(res.id), quarter: res.quarter ?? "", volumeOfMobileData: res.data ?? ""))
                    }
                    } else {
                        readFile()
                    }
                    DispatchQueue.main.async {
                        completion(self.records, self.errorMessage)
                    }
                }
            }
    }
    //
    // MARK: - Private Methods
    //
    private func extractData(_ data: Data) {
        var responses: JSONDictionary?
        records.removeAll()
        deleteRecord()
        do {
            responses = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        guard let array = responses!["result"] as? [String: Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        guard let newarr = array["records"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        for trackDictionary in newarr {
            if let trackDictionary = trackDictionary as? [String: Any],
                let id = trackDictionary["_id"] as? Int,
                let quarter = trackDictionary["quarter"] as? String,
                let mobileData = trackDictionary["volume_of_mobile_data"] as? String{
                records.append(Record(id: id, quarter: quarter, volumeOfMobileData: mobileData))
                save(id: id, quarter: quarter, data: mobileData)
            }
        }
    }
    func readFile() {
        if let path = Bundle.main.path(forResource: "Record", ofType: "json") {
                                  do {
                                   
                                     let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                                    extractData(data)
                                        
                                    } catch let parseError as NSError {
                                        errorMessage += "JSON error: \(parseError.localizedDescription)\n"
                                        return
                                    }
                              }
    }
}
