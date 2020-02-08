//
//  DataSource.swift
//  Micro
//
//  Created by khoa on 08/02/2020.
//

import UIKit

open class DataSource: NSObject {
    private var cellRegister: Set<String> = Set()
    private var finalState: State!
    private var oldState: State!
    private let queue = DispatchQueue(label: "")

    var state: State = .init() {
        didSet {
            reload(oldState: oldValue, newState: state, completion: {})
        }
    }

    open func reload(oldState: State, newState: State, completion: () -> Void) {
//        newState.reloader.onReload(self, collectionView, oldState, newState)
    }

    public func registerIfNeeded<Cell: UICollectionViewCell>(collectionView: UICollectionView, cellType: Cell.Type) {
        if !cellRegister.contains(String(describing: cellIdentifier(cellType))) {
            collectionView.register(cellType: cellType)
            cellRegister.insert( cellIdentifier(cellType))
        }
    }
}

extension DataSource: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return state.models.count
    }

    open func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let observer = state.observers[indexPath.item]
        let context = Context(collectionView: collectionView, indexPath: indexPath)
        return observer.onConfigure(context, self) ?? UICollectionViewCell()
    }
}

extension DataSource: UICollectionViewDelegate {
    open func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let observer = state.observers[indexPath.item]
        let context = Context(collectionView: collectionView, indexPath: indexPath)
        observer.onWillDisplay(context, cell)
    }

    open func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let observer = state.observers[indexPath.item]
        let context = Context(collectionView: collectionView, indexPath: indexPath)
        observer.onDidEndDisplay(context, cell)
    }

    open func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let observer = state.observers[indexPath.item]
        let context = Context(collectionView: collectionView, indexPath: indexPath)
        observer.onSelect(context)
    }

    open func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        let observer = state.observers[indexPath.item]
        let context = Context(collectionView: collectionView, indexPath: indexPath)
        observer.onDeselect(context)
    }

    open func collectionView(
        _ collectionView: UICollectionView,
        shouldHighlightItemAt indexPath: IndexPath
    ) -> Bool {
        let observer = state.observers[indexPath.item]
        let context = Context(collectionView: collectionView, indexPath: indexPath)
        return observer.onShouldHighlight(context)
    }
}

extension DataSource: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .zero
    }
}
