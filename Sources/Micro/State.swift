//
//  State.swift
//  Micro
//
//  Created by khoa on 08/02/2020.
//

import UIKit
import DeepDiff

public struct State {
    let models: [Any]
    let items: [Any]
    let observers: [Observer]
    let reloader: Reloader
}

extension State {
    public init() {
        self.models = []
        self.items = []
        self.observers = []
        self.reloader = Reloader(onReload: { _ in })
    }
}
