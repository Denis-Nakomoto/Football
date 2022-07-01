//
//  NetworkingManager.swift
//  Football
//
//  Created by Denis Svetlakov on 30.06.2022.
//

import Foundation
import Combine

enum APIError: Swift.Error, Equatable {
    
    case noDataInResponse
    case decodingError
    case unknownError(Int)
    
    var errorDescription: String? {
        
        switch self {
        case .noDataInResponse:
            return "No data in response"
        case .decodingError:
            return "Decoding from json error"
        case let .unknownError(code):
            return "Unexpected HTTP code: \(code)"
        }
    }
}

enum Routes {
    
    case getAllLeagues
    case leagueDetails(String)
    case leaguesSeasons(String)
    case leaguesStandings(String)
    
    var routes: String? {
        
        switch self {
        case .getAllLeagues:
            return "/leagues"
        case let .leagueDetails(id):
            return "/leagues/\(id)"
        case let .leaguesSeasons(id):
            return "/leagues/\(id)/seasons"
        case let .leaguesStandings(id):
            return "/leagues/\(id)/standings"
        }
    }
}

class NetworkingManager {
    
    let apiEndPoint = "https://api-football-standings.azharimm.site"
    
    let sessionManager: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // seconds
        configuration.timeoutIntervalForResource = 30 // seconds
        return URLSession(configuration: configuration)
    }()
    
    func sendRequest<T: Decodable>(endPoint: String) -> Future<T, APIError> {
        return Future { promise in
            let url = URL(string: "\(self.apiEndPoint)\(endPoint)")!
            var request = URLRequest (url: url)
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
            request.httpMethod = "GET"
            self.sessionManager.dataTask(with: request) {
                guard let data = $0 else {
                    promise(.failure(.noDataInResponse))
                    print ("No data in response:\($2?.localizedDescription ?? "Unknown error").")
                    return
                }
                let responseStatus = $1 as! HTTPURLResponse
                if (200..<300).contains(responseStatus.statusCode) {
                    if let decoded = try? JSONDecoder().decode(T.self, from: data){
                        DispatchQueue.main.async {
                            promise(.success(decoded))
                        }
                    } else {
                        let dataString = String(decoding: data, as: UTF8.self)
                        print("Data: \(dataString)")
                        promise(.failure(.decodingError))
                    }
                } else if responseStatus.statusCode > 399 {
                    promise(.failure(.unknownError(responseStatus.statusCode)))
                }
            }.resume()
        }
    }
    
//    func fetchLogo(path: String, imageUrl: String) -> Future<Data, APIError> {
//        return Future { promise in
//            let url = URL(string: imageUrl)!
//            var request = URLRequest (url: url)
//            request.addValue("application/json", forHTTPHeaderField: "content-type")
//            request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
//            request.httpMethod = "GET"
//            self.sessionManager.dataTask(with: request) {
//                guard let data = $0 else {
//                    promise(.failure(.noDataInResponse))
//                    print ("No data in response:\($2?.localizedDescription ?? "Unknown error").")
//                    return
//                }
//                promise(.success(data))
//            }.resume()
//        }
//    }
    
}
