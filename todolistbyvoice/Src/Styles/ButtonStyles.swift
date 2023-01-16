//
//  ButtonStyles.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/16/23.
//

import SwiftUI

struct BasicButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 3)
            .foregroundColor(.white)
//            .background(configuration.isPressed ? Color.gray : Color.blue)
            .background(Color.gray)
            .cornerRadius(10)
    }
}

struct GreenButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .shadow(radius: 8)
    }
}

struct RedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            .shadow(radius: 8)
    }
}
