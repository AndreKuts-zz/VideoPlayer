//
//  MainAPI.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Moya

enum MainAPI {

    case userList
}

extension MainAPI: TargetType {

    var baseURL: URL {
        return Constants.serverURL
    }

    var path: String {
        return "/online-json-editor/cbf028e7"
    }

    var method: Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return nil
    }
}
