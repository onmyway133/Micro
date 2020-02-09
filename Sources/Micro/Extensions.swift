//
//  Extensions.swift
//  Micro
//
//  Created by khoa on 08/02/2020.
//

import UIKit

func cellIdentifier<Cell: UICollectionViewCell>(_ cellType: Cell.Type) -> String {
    return String(describing: Cell.self)
}

public extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        register(T.self, forCellWithReuseIdentifier: cellIdentifier(cellType))
    }

    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(
            withReuseIdentifier:cellIdentifier(T.self),
            for: indexPath
        ) as? T
    }
}

extension Collection {
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
