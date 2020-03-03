//
//  UIView+Constraint.swift
//  Tick-tock-list
//
//  Created by Kuts, Andrey on 12/26/19.
//  Copyright © 2019 Kuts, Andrey. All rights reserved.
//

import UIKit

extension UIView {

    func pinEdges(to view: UIView) {
        topAnchor.constraint(equalTo: view.topAnchor, constant: -UIApplication.shared.statusBarFrame.height).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
