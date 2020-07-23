//
//  REPLBuffer.swift
//  anime
//
//  Created by faith on 2020/7/23.
//  Copyright © 2020 iamfaith. All rights reserved.
//

import Foundation


struct REPLBuffer {
    private var buffer = Data()

    mutating func append(_ data: Data) -> String? {
        buffer.append(data)
        if let string = String(data: buffer, encoding: .utf8), string.last?.isNewline == true {
            buffer.removeAll()
            return string
        }
        return nil
    }
}
