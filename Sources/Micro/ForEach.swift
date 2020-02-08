//
//  ForEach.swift
//  Micro
//
//  Created by khoa on 08/02/2020.
//

import UIKit
import DeepDiff

public func forEach<Model: DiffAware, Cell: UICollectionViewCell>(
    models: [Model],
    transform: (Model) -> Item<Cell>
) -> State {
    let onReload: Reloader.Reload = { dataSource, collectionView, oldState, newState, completion in
        let oldModels: [Model] = oldState.models.compactMap({ $0 as? Model })
        let changes: [Change<Model>] = diff(old: oldModels, new: models)
        collectionView.reload(
            changes: changes,
            section: 0,
            updateData: {
                dataSource.state = newState
            },
            completion: completion
        )
    }

    let items: [Item<Cell>] = models.map(transform)
    let observers: [Observer] = items.map({ $0.observer })

    return State(
        models: models,
        items: items,
        observers: observers,
        reloader: Reloader(onReload: onReload)
    )
}
