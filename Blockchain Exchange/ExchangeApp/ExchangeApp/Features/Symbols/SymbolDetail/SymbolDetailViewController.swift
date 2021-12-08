//
//  SymbolDetail.swift
//  ExchangeApp
//
//  Created by Piotr Olechnowicz on 08/12/2021.
//

import Foundation
import RxSwift
import UIKit

final class SymbolsDetailViewController: UIViewController {
    private let disposeBag: DisposeBag = .init()
    private var presenter: SymbolDetailViewPresenterInterface
    private var symbol: String

    init(presenter: SymbolDetailViewPresenterInterface, symbol: String) {
        self.presenter = presenter
        self.symbol = symbol
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        title = symbol
    }
}
