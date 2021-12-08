//
//  UIView+Constraints.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 07/12/2021.
//

import Foundation
import UIKit

extension UIView {
    func addSubviewAndFill(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let constraints = [
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            view.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
