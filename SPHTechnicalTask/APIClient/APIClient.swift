//
//  APIClient.swift
//  SPHTechnicalTask
//
//  Created by Baveendran Nagendran on 1/4/20.
//  Copyright © 2020 rbtechsolutions. All rights reserved.
//

import Foundation

typealias ApiResponseCallBack = ((DataUsageApiResponse?, _ error: String?) -> Void)

enum NetworkResponse: String {
    case success
    case authenticationError = "Server Error"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

class APIClient {
    let baseUrl = "https://data.gov.sg"
    static let shared = APIClient()
    private init() { }
        
    func fetchUsedMobileData(nextUrl: String, callBack: @escaping ApiResponseCallBack) {
        let url = baseUrl+nextUrl
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 60.0)
        request.httpMethod = "GET"
    
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {[weak self] (data, urlResponse, error) in
            
            if error != nil {
                callBack(nil, "Please check your network connection.")
                return
            }
        
            if let response = urlResponse as? HTTPURLResponse, let result = self?.handleNetworkResponse(response) {
                switch result {
                case .success:
                    guard let responseData = data else {
                        callBack(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(DataUsageApiResponse.self, from: responseData)
                        callBack(apiResponse,nil)
                    }catch {
                        callBack(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    callBack(nil, networkFailureError)
                }
            }
            
        })
        dataTask.resume()
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200:
            return .success
        case 401...500:
            return .failure(NetworkResponse.badRequest.rawValue)
        case 501...599:
            return .failure(NetworkResponse.authenticationError.rawValue)
        case 600:
            return .failure(NetworkResponse.outdated.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
}
