//
//  Errors.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Moya
import Foundation

enum NetworkingError: Error, LocalizedError {

    case decodingError(Error)
    case offline(Error)
    case moyaError(MoyaError)
    case serverError(ServerError)
    case defaultError

    internal var errorDescription: String? {
        switch self {
        case .decodingError:
            return "DecodingError"
        case .moyaError(let moyaError):
            return moyaError.localizedDescription
        case .offline(let error):
            return error.localizedDescription
        case .defaultError:
            return "DefaultError"
        case .serverError(let serverError):
            switch serverError {
            case .error(let description):
                return description
            }
        }
    }
}

enum ServerError {
    case error(String)
}

extension ServerError: Decodable {

    enum CodingKeys: String, CodingKey {
        case error = "error"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let errorDescription = try container.decode(String.self, forKey: .error)
        self = .error(errorDescription)
    }
}
