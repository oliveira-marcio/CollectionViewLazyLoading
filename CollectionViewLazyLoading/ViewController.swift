//
//  ViewController.swift
//  CollectionViewLazyLoading
//
//  Created by Márcio Oliveira on 28/09/2022.
//

import UIKit

class ViewController: UIViewController {
    lazy var rootView: UIView = createRootView()
    lazy var label: UILabel = createLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
    }
}
