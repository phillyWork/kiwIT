//
//  NetworkManager.swift
//  kiwIT
//
//  Created by Heedon on 3/20/24.
//

import Foundation
import Alamofire
import Combine

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    func request<T: Decodable>(type: T.Type, api: Router, errorCase: NetworkErrorCase) {
        
        //Observable return처럼 Future return 필요
        AF.request(api)
            .validate(statusCode: 200..<202)
            .responseDecodable(of: T.self) { response in
                print("response: \(response.debugDescription)")
                
                guard let statusCode = response.response?.statusCode else {
                    print("No Status Code!!!")
                    return
                }
                
                switch response.result {
                case .success(let payload):
                    print("payload: \(payload)")
                case .failure(let error):
                    print("error description: \(error.localizedDescription)")
                    
                    
                    
                }
            }
    }
    
}
