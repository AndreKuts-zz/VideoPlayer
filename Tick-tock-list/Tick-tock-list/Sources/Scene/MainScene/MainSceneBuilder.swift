//
//  MainSceneBuilder.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/24/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import UIKit.UIViewController

struct MainSceneBuilder {

    static func makeMainViewController() -> UIViewController {

        let viewModel = MainSceneViewModel()
        let controller = MainViewController()
        controller.viewModel = viewModel

        return controller
    }
}
