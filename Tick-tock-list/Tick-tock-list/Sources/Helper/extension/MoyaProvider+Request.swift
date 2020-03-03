//
//  MoyaProvider+Request.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Moya
import Alamofire

public extension MoyaProvider {

    internal func request<T: Decodable>(_ target: Target,
                                        completion completionBlock: @escaping (Result<T>) -> Void,
                                        progress completionProgress: ((Float) -> Void)? = nil) -> Cancellable {
        return request(target, progress: { progress in
            completionProgress?(Float(progress.progress))
        }, completion: { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try Networking.decoder.decode(T.self, from: response.data)
                    completionBlock(.success(decoded))
                } catch {
                    completionBlock(.failure(self.handleServerError(in: response.data)))
                    if let stackTrace = String(data: response.data, encoding: .utf8) {
                        print(stackTrace)
                    }
                }
            case .failure(let error):
                if case .underlying(let (swiftError, _)) = error,
                    let urlError = swiftError as? URLError,
                    urlError.code == URLError.Code.notConnectedToInternet {
                    completionBlock(.failure(NetworkingError.offline(urlError)))
                } else {
                    completionBlock(.failure(error))
                }
            }
        })
    }

    private func handleServerError(in responseData: Data) -> NetworkingError {
        do {
            let decoded = try Networking.decoder.decode(ServerError.self, from: responseData)
            return NetworkingError.serverError(decoded)
        } catch {
            if let stackTrace = String(data: responseData, encoding: .utf8) {
                print(stackTrace)
            }
            return NetworkingError.decodingError(error)
        }
    }
}
