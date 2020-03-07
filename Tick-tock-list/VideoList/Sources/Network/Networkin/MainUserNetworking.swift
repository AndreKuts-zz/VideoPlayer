//
//  UserListNetworking.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Moya
import Alamofire

protocol UserListNetworking {

//    @discardableResult
    func getList(completion: @escaping (Result<UserListModel, Error>) -> Void) /* TMP -> Cancellable */
}

extension Networking: UserListNetworking {

//    @discardableResult
    func getList(completion: @escaping (Result<UserListModel, Error>) -> Void) /* TMP -> Cancellable */ {

        // WARNING: - TMP ----------------
        let bundl = Bundle.main
        let fileName = "json"
        let fileType = "json"

        if let path = bundl.path(forResource: fileName, ofType: fileType),
            let url = URL(fileURLWithPath: path) as? URL,
            let data = try? Data(contentsOf: url),
            let decodedList = try? Networking.decoder.decode(UserListModel.self, from: data) {

            completion(.success(decodedList))
        }
        // WARNING: - TMP ----------------

//        mainUserProvider.request(.userList, completion: completion)
    }
}
