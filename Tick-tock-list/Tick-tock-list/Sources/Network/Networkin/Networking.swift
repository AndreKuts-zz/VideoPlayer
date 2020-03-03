//
//  Networking.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Moya
import Result
import Alamofire

protocol Networkable {

    // MARK: - Providers

    var mainUserProvider: MoyaProvider<MainAPI> { get }
    var test: MoyaProvider<MainAPI> { get }

    // MARK: - Helpers

    static var decoder: JSONDecoder { get }
    static var encoder: JSONEncoder { get }

    static var loggerPlugin: LoggerPlugin { get }
    static var networkActivityPlugin: NetworkActivityPlugin { get }
    static var reachabilityManager: NetworkReachabilityManager? { get }
}

public class Networking: Networkable {

    public struct Configuration {
        public let baseUrl: URL
        public let headers: [String: Any]
        public static let shared = Configuration(baseUrl: Constants.serverURL, headers: Constants.queryHeaders)
    }

    lazy var mainUserProvider: MoyaProvider<MainAPI> = .init(plugins: [Networking.networkActivityPlugin, Networking.loggerPlugin])
    lazy var test: MoyaProvider<MainAPI> = .init(plugins: [Networking.networkActivityPlugin, Networking.loggerPlugin])

    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    static let encoder = JSONEncoder()

    static var loggerPlugin: LoggerPlugin = .init()
    static var networkActivityPlugin: NetworkActivityPlugin = .init { change, _ in
        UIApplication.shared.isNetworkActivityIndicatorVisible = change == .began
    }
    static var reachabilityManager: NetworkReachabilityManager? = NetworkReachabilityManager()

    init() {
        startObserveringReachability()
    }

    private func startObserveringReachability() {
        Networking.reachabilityManager?.startListening()
    }
}
