//
//  UIView+Loading.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import UIKit
import RxSwift
import NVActivityIndicatorView

extension UIView {
    var activityIndicatorTag: Int { return 12345 }
    var activityIndicatorView: UIView? {
        return subviews.filter({$0.tag == activityIndicatorTag}).first
    }

    func startActivityIndicator() {
        let loadingViewHeight: CGFloat = 80
        self.isUserInteractionEnabled = false
        guard self.activityIndicatorView == nil else { return }

        let container: UIView = UIView()
        let loadingView: UIView = UIView()
        let actRect = CGRect(x: 0, y: 0, width: 80, height: 80)
        let actInd = NVActivityIndicatorView(frame: actRect, type: .lineScalePulseOut, color: .blue, padding: .none)

        self.addSubview(container)
        container.addSubview(loadingView)
        loadingView.addSubview(actInd)

        container.backgroundColor = UIColor.label.withAlphaComponent(0.0)
        container.tag = self.activityIndicatorTag

        container.translatesAutoresizingMaskIntoConstraints = false

        let containerConstraints = [container.leftAnchor.constraint(equalTo: self.leftAnchor),
                                    container.widthAnchor.constraint(equalTo: self.widthAnchor),
                                    container.topAnchor.constraint(equalTo: self.topAnchor),
                                    container.heightAnchor.constraint(equalTo: self.heightAnchor)]

        NSLayoutConstraint.activate(containerConstraints)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let loadingConstraints = [
            loadingView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: loadingViewHeight),
            loadingView.widthAnchor.constraint(equalToConstant: loadingViewHeight)]

        NSLayoutConstraint.activate(loadingConstraints)

        actInd.translatesAutoresizingMaskIntoConstraints = false
        let centerConstrains = [actInd.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                                actInd.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)]

        NSLayoutConstraint.activate(centerConstrains)

        actInd.startAnimating()
    }

    func stopActivityIndicator() {
        self.isUserInteractionEnabled = true
        if let activityIndicator = self.subviews.filter({$0.tag == self.activityIndicatorTag}).first {
            activityIndicator.removeFromSuperview()
        }
    }
}

extension Reactive where Base: UIView {
    var showActivityIndicator: Binder<Bool> {
        return Binder(self.base) { view, model in
            if model {
                view.startActivityIndicator()
            } else {
                view.stopActivityIndicator()
            }
        }
    }
}
