//
//  Cell.swift
//  DeepDiff
//
//  Created by khoa on 08/02/2020.
//

import UIKit

public protocol ObserverOwner {
    var observer: Observer { get }
}

public struct Cell<C: UICollectionViewCell>: ObserverOwner {
    public let observer = Observer()

    public init(_ closure: @escaping (Context, C) -> Void = { _, _ in }) {
        observer.onConfigure = { context, dataSource in
            dataSource.registerIfNeeded(collectionView: context.collectionView, cellType: C.self)
            if let cell: C = context.collectionView.dequeue(for: context.indexPath) {
                closure(context, cell)
                return cell
            } else {
                return nil
            }
        }
    }

    public func onShouldSelect(_ closure: @escaping (Context) -> Bool) -> Self {
        observer.onShouldSelect = closure
        return self
    }

    public func onSelect(_ closure: @escaping (Context) -> Void) -> Self {
        observer.onSelect = closure
        return self
    }

    public func onDeselect(_ closure: @escaping (Context) -> Void) -> Self {
        observer.onDeselect = closure
        return self
    }

    public func onSize(_ closure: @escaping (Context) -> CGSize) -> Self {
        observer.onSize = closure
        return self
    }

    public func onShouldHighlight(_ closure: @escaping (Context) -> Bool) -> Self {
        observer.onShouldHighlight = closure
        return self
    }

    public func onWillDisplay(_ closure: @escaping (Context, C) -> Void) -> Self {
        observer.onWillDisplay = { context, cell in
            if let cell = cell as? C {
                closure(context, cell)
            }
        }
        return self
    }

    public func onDidEndDisplay(_ closure: @escaping (Context, C) -> Void) -> Self {
        observer.onDidEndDisplay = { context, cell in
            if let cell = cell as? C {
                closure(context, cell)
            }
        }
        return self
    }
}

public struct Context {
    public let collectionView: UICollectionView
    public let indexPath: IndexPath
}

public class Observer {
    public var onConfigure: (Context, DataSource) -> UICollectionViewCell? = { _, _ in nil }
    public var onShouldSelect: (Context) -> Bool = { _ in true }
    public var onSelect: (Context) -> Void = { _ in }
    public var onDeselect: (Context) -> Void = { _ in }
    public var onSize: (Context) -> CGSize = { _ in .zero }
    public var onShouldHighlight: (Context) -> Bool = { _ in true }
    public var onWillDisplay: (Context, UICollectionViewCell) -> Void = { _, _ in }
    public var onDidEndDisplay: (Context, UICollectionViewCell) -> Void = { _, _ in }
}
