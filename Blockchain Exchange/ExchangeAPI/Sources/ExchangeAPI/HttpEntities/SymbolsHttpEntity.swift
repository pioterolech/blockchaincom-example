//
//  File.swift
//  
//
//  Created by Piotr Olechnowicz on 02/12/2021.
//

import Foundation

public struct SymbolsHttpEntity: Codable {
    let baseCurrency: String
    let baseCurrencyScale: Int
    let counterCurrency: String
    let counterCurrencyScale, minPriceIncrement, minPriceIncrementScale, minOrderSize: Int
    let minOrderSizeScale, maxOrderSize, maxOrderSizeScale, lotSize: Int
    let lotSizeScale: Int
    let status: String
    let identifier: Int
    let auctionPrice: Double
    let auctionSize: Double
    let auctionTime: String
    let imbalance: Double

    enum CodingKeys: String, CodingKey {
        case baseCurrency = "base_currency"
        case baseCurrencyScale = "base_currency_scale"
        case counterCurrency = "counter_currency"
        case counterCurrencyScale = "counter_currency_scale"
        case minPriceIncrement = "min_price_increment"
        case minPriceIncrementScale = "min_price_increment_scale"
        case minOrderSize = "min_order_size"
        case minOrderSizeScale = "min_order_size_scale"
        case maxOrderSize = "max_order_size"
        case maxOrderSizeScale = "max_order_size_scale"
        case lotSize = "lot_size"
        case lotSizeScale = "lot_size_scale"
        case status
        case identifier = "id"
        case auctionPrice = "auction_price"
        case auctionSize = "auction_size"
        case auctionTime = "auction_time"
        case imbalance
    }
}
