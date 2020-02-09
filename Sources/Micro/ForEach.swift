//
//  ForEach.swift
//  Micro
//
//  Created by khoa on 08/02/2020.
//

import UIKit
import DeepDiff

public func forEach<Model: DiffAware>(
    models: [Model],
    transform: (Model) -> ObserverOwner
) -> State {
    let onReload: Reloader.Reload = { request in
        let reload: () -> Void = {
            let oldModels: [Model] = request.oldState.models.compactMap({ $0 as? Model })

            if oldModels.isEmpty {
                request.dataSource.finalState = request.newState
                request.collectionView.reloadData()
                request.completion(true)
                return
            }

            let changes: [Change<Model>] = diff(old: oldModels, new: models)
            request.collectionView.reload(
                changes: changes,
                section: 0,
                updateData: {
                    request.dataSource.finalState = request.newState
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
