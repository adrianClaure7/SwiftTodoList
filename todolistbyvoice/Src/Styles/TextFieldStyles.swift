//
//  TextFieldStyles.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/16/23.
//

import SwiftUI

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray)
            .cornerRadius(5.0)
    }
}
