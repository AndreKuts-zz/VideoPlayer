//
//  LoggerPlugin.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Moya
import Result

struct LoggerPlugin: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
        let urlString = request.request?.url?.absoluteString ?? "?"
        let bodySize = request.request?.httpBody?.count ?? 0
        print("<-- \(target.method.rawValue) \(urlString)  |  Body size: \(bodySize)")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        let succeed = result.error == nil ? "✅" : "❌"
        let urlString = result.value?.request?.url?.absoluteString ?? "?"
        let dataSize = result.value?.data.count ?? 0
        print("--> \(succeed) from \(target.method.rawValue) \(urlString)  |  Response data size: \(dataSize)")
    }
}
