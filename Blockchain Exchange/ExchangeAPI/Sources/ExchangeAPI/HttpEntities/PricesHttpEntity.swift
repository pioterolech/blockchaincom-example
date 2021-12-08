//
//  PricesHttpEntity.swift
//  ExchangeAPI
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation

public struct PricesHttpEntity: Codable {
    public let prices: [[Double]]
}
