//
//  MainSceneBuilder.swift
//  VideoList
//
//  Created by Kuts, Andrey on 12/24/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import UIKit.UIViewController
import AsyncDisplayKit

struct MainSceneBuilder {

    static func makeMainViewController() -> UIViewController {

        let userListService: UserListNetworking = DependenciesInjector.inject()
        let model = VideoListModel(userApi: userListService)
        let viewModel = VideoListViewModel(model: model)
        let controller = VideoListViewController(viewModel: viewModel)

        return controller
    }

    static func makeMainNodeController() -> ASViewController<ASCollectionNode>  {

        let userListService: UserListNetworking = DependenciesInjector.inject()
        let model = VideoListModel(userApi: userListService)
        let viewModel = VideoListNodeModel(model: model)
        let nodeController = VideoListNodeController(viewModel: viewModel)

        return nodeController
    }
}
