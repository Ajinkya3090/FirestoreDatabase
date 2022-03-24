//
//  RequestHelperOfHreokuapp .swift
//  FirestoreDatabase
//
//  Created by Admin on 23/03/22.
//

import Foundation

struct RequestHelper {
    static let path = Bundle.main.path(forResource: "Config", ofType: "plist")
    static let config = NSDictionary(contentsOfFile: path!)
    private static let baseURLString = config!["serverUrl"] as! String
    
    static func createRequest (_ path : String,
                               _ parameters : [String : String],
                               _ completionHandler : @escaping (_ result : Data) -> VarifyResult) {
        let urlPath = "\(baseURLString)/\(path)"
        print(urlPath)
        var components = URLComponents(string: urlPath)!
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        
        let url = components.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            if let jsonData = data {
                print(jsonData)
                let result = completionHandler(jsonData)
                print(result)
            } else {
                // error, no data returned
            }
        }
        task.resume()
    }
}

