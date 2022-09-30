//
//  Interactor.swift
//  CollectionViewLazyLoading
//
//  Created by Márcio Oliveira on 30/09/2022.
//

import Foundation

struct InteractorModel: Hashable {
    let id: Int
    let count: Int
    var name: String { "Row \(id)" }
    var countLabel: String { "Update: \(count)"}
}

class Interactor {
    private let id: Int
    private var counter = 0
    var delay: Int
    var model: InteractorModel?

    init(id: Int, delay: Int = 0) {
        self.id = id
        self.delay = delay
    }

    func fetchData() async {
        try? await Task.sleep(until: .now + .seconds(delay), clock: .continuous)
        model = InteractorModel(id: id, count: counter)
        counter += 1
    }
}
