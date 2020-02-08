//
//  ForEach.swift
//  Micro
//
//  Created by khoa on 08/02/2020.
//

import UIKit
import DeepDiff

public func forEach<Model: DiffAware, Cell: UICollectionViewCell>(
    models: [Model], transform: (Model) -> Item<Cell>
) -> State {
    let onReload: (DataSource, UICollectionView, State, State) -> Void = { dataSource, collectionView, oldState, newState in
        let oldModels = oldState.models.compactMap({ $0 as? Model })
        let changes = diff(old: oldModels, new: models)
        collectionView.reload(
            changes: changes,
            section: 0,
            updateData: {
//                dataSource.finalState = newState
            },
            completion: nil
        )
    }

    let items = models.map(transform)
    let observers = items.map({ $0.observer })

    return State(
        models: models,
        items: items,
        observers: observers,
        reloader: Reloader(onReload: onReload)
    )
}
