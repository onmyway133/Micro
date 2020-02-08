//
//  Item.swift
//  DeepDiff
//
//  Created by khoa on 08/02/2020.
//

import UIKit

public struct Item<Cell: UICollectionViewCell> {
    public let observer = Observer()

    public init(configure: @escaping (Cell) -> Void) {
        observer.onConfigure = { context, dataSource in
            dataSource.registerIfNeeded(collectionView: context.collectionView, cellType: Cell.self)
            let cell: Cell? = context.collectionView.dequeue(for: context.indexPath)
            return cell
        }
    }

    func onSelect(_ closure: @escaping (Context) -> Void) -> Self {
        observer.onSelect = closure
        return self
    }

    func onDeselect(_ closure: @escaping (Context) -> Void) -> Self {
        observer.onDeselect = closure
        return self
    }

    func onSize(_ closure: @escaping (Context) -> CGSize) -> Self {
        observer.onSize = closure
        return self
    }

    func onShouldHighlight(_ closure: @escaping (Context) -> Bool) -> Self {
        observer.onShouldHighlight = closure
        return self
    }

    func onWillDisplay(_ closure: @escaping (Context, Cell) -> Void) -> Self {
        observer.onWillDisplay = { context, cell in
            if let cell = cell as? Cell {
                closure(context, cell)
            }
        }
        return self
    }

    func onDidEndDisplay(_ closure: @escaping (Context, Cell) -> Void) -> Self {
        observer.onDidEndDisplay = { context, cell in
            if let cell = cell as? Cell {
                closure(context, cell)
            }
        }
        return self
    }
}

public struct Context {
    let collectionView: UICollectionView
    let indexPath: IndexPath
}

public class Observer {
    var onConfigure: (Context, DataSource) -> UICollectionViewCell? = { _, _ in nil }
    var onSelect: (Context) -> Void = { _ in }
    var onDeselect: (Context) -> Void = { _ in }
    var onSize: (Context) -> CGSize = { _ in .zero }
    var onShouldHighlight: (Context) -> Bool = { _ in true }
    var onWillDisplay: (Context, UICollectionViewCell) -> Void = { _, _ in }
    var onDidEndDisplay: (Context, UICollectionViewCell) -> Void = { _, _ in }
}
