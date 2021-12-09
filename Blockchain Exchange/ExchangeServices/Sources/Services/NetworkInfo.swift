//
//  NetworkInfo.swift
//  ExchangeServices
//
//  Created by Piotr Olechnowicz on 09/12/2021.
//

import Foundation
import Reachability

public protocol NetworkInfoInterface {
    var isReachable: Bool { get }
}

public class NetworkInfo: NetworkInfoInterface {
    private let reachability: Reachability

    public init(reachability: Reachability) {
        self.reachability = reachability

        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
    }

    public var isReachable: Bool {
        reachability.connection != .unavailable
    }
}
