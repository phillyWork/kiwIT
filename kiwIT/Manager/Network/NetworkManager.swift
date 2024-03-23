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
        
    }
    
}
