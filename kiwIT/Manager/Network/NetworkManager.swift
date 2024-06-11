//
//  NetworkManager.swift
//  kiwIT
//
//  Created by Heedon on 3/20/24.
//

import Foundation
import Combine

import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    func request<T: Decodable>(type: T.Type, api: Router, errorCase: NetworkErrorCase) -> AnyPublisher<T, Error> {
        
        return Future<T, Error> { promise in
            AF.request(api)
                .validate()
                .responseDecodable(of: T.self) { response in
                    
                    print("response: \(response.debugDescription)")
                   
                    guard let statusCode = response.response?.statusCode else {
                        print("No Status Code!!!")
                        return
                    }

                    switch response.result {
                    case .success(let payload):
                        print("payload: \(payload)")
                        promise(.success(payload))
                    case .failure(let error):
                        print("error description: \(error.localizedDescription)")
                        
                        if let networkError = NetworkError.init(statusCode: statusCode, message: NetworkErrorMessage(status: statusCode, errorCase: errorCase).message) {
                            print("networkError: case - \(errorCase), message - \(networkError.description), statusCode - \(statusCode)")
                            promise(.failure(networkError))
                        } else {
                            print("other error: \(error)")
                            promise(.failure(error))
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
