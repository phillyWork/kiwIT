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
                .responseDecodable(of: T.self, emptyResponseCodes: [200, 204, 205]) { response in
                    switch response.result {
                    case .success(let payload):
                        promise(.success(payload))
                    case .failure(let error):
                        guard let statusCode = response.response?.statusCode else {
                            return
                        }
                        
                        if let networkError = NetworkError.init(statusCode: statusCode, message: NetworkErrorMessage(status: statusCode, errorCase: errorCase).message) {
                            promise(.failure(networkError))
                        } else {
                            promise(.failure(error))
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
