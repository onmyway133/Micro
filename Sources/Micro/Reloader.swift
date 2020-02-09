//
//  Reloader.swift
//  Micro
//
//  Created by khoa on 09/02/2020.
//

import UIKit

public struct Reloader {
    public struct Request {
        public let dataSource: DataSource
        public let collectionView: UICollectionView
        public let oldState: State
        public let newState: State
        public let isAnimated: Bool
        public let completion: Completion
    }

    public typealias Completion = (Bool) -> Void
    public typealias Reload = (Request) -> Void
    public let onReload: Reload
}
