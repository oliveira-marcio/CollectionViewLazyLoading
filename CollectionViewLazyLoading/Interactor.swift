//
//  Interactor.swift
//  CollectionViewLazyLoading
//
//  Created by Márcio Oliveira on 30/09/2022.
//

import Foundation

class Interactor {
    private let id: Int
    private var counter = 0
    var delay: Int
    var model: RowModel?

    init(id: Int, delay: Int = 0) {
        self.id = id
        self.delay = delay
    }

    func fetchData() async {
        try? await Task.sleep(until: .now + .seconds(delay), clock: .continuous)
        model = RowModel(id: id, count: counter)
        counter += 1
    }
}
