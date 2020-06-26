//
//  Array+Only.swift
//  bbbb
//
//  Created by faith on 2020/6/25.
//  Copyright © 2020 faith. All rights reserved.
//

import Foundation


extension Array {
    var only: Element? {
        count == 1 ? first: nil
    }
}
