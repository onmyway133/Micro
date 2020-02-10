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
    let owners: [ObserverOwner]
    let observers: [Observer]
    let reloader: Reloader
}

extension State {
    public init() {
        self.models = []
        self.owners = []
        self.observers = []
        self.reloader = Reloader(onReload: { _ in })
    }
}

@_functionBuilder
public struct StateBuilder {
    public static func buildBlock(_ forEach: ForEach) -> ForEach {
        forEach
    }
}

extension State {
    public init(@StateBuilder builder: () -> ForEach) {
        let forEach = builder()
        self = forEach.state
    }
}
