//
//  RxTestCase.swift
//  ExchangeAPITests
//
//  Created by Piotr Olechnowicz on 04/12/2021.
//

import XCTest
import RxTest
import RxSwift

class RxTestCase: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
}
