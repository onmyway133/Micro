//
//  ForEach.swift
//  Micro
//
//  Created by khoa on 08/02/2020.
//

import UIKit
import DeepDiff

public struct ForEach {
    public let state: State

    public init<Model: DiffAware>(
        _ models: [Model],
        transform: (Model) -> ObserverOwner
    ) {
        self.state = forEach(models, transform: transform)
    }
}

public func forEach<Model: DiffAware>(
    _ models: [Model],
    transform: (Model) -> ObserverOwner
) -> State {
    let onReload: Reloader.Reload = { request in
        let reload: () -> Void = {
            let oldModels: [Model] = request.dataSource.trueState.models.compactMap({ $0 as? Model })

            if oldModels.isEmpty {
                request.dataSource.trueState = request.newState
                request.collectionView.reloadData()
                request.completion(true)
                return
            }

            let changes: [Change<Model>] = diff(old: oldModels, new: models)
            request.collectionView.reload(
                changes: changes,
                section: 0,
                updateData: {
                    request.dataSource.trueState = request.newState
                },
                completion: request.completion
            )
        }

        if request.isAnimated {
            reload()
        } else {
            UIView.performWithoutAnimation {
                reload()
            }
        }
    }

    let owners: [ObserverOwner] = models.map(transform)
    let observers: [Observer] = owners.map({ $0.observer })

    return State(
        models: models,
        owners: owners,
        observers: observers,
        reloader: Reloader(onReload: onReload)
    )
}
