//
//  TextTypes.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/16/23.
//


import SwiftUI

struct TextStyles {
    static func topTitle(title: String) -> Text {
        return Text(title)
                .font(.largeTitle)
                .foregroundColor(.white)
    }

    static func body() -> Text {
        return Text("Body")
            .font(.body)
    }

    static func caption() -> Text {
        return Text("Caption")
            .font(.caption)
            .italic()
    }
}
