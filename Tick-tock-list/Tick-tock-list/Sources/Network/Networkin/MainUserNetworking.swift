//
//  MainUserNetworking.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import Moya
import Alamofire

protocol MainUserNetworking {

    @discardableResult
    func getList(completion: @escaping (Result<UserListModel>) -> Void) -> Cancellable
}

extension Networking: MainUserNetworking {

    @discardableResult
    func getList(completion: @escaping (Result<UserListModel>) -> Void) -> Cancellable {
        return mainUserProvider.request(.userList, completion: completion)
    }
}

protocol Test {
    @discardableResult
    func getLists(completion: @escaping (Result<UserListModel>) -> Void) -> Cancellable
}

extension Networking: Test {
    func getLists(completion: @escaping (Result<UserListModel>) -> Void) -> Cancellable {
        return test.request(.userList, completion: completion)
    }
}
