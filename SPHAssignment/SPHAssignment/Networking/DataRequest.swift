
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
    
    func getSearchResults(completion: @escaping QueryResult) {
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
    }
    //
    // MARK: - Private Methods
    //
    private func extractData(_ data: Data) {
        var responses: JSONDictionary?
        records.removeAll()
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
            }
        }
    }
}
