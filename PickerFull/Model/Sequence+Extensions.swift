//
//  Sequence+Extensions.swift
//  PickerFull
//
//  Created by dani on 1/21/23.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

// https://stackoverflow.com/a/25739498

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
