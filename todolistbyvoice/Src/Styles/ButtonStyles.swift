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
            .padding(.all, 5)
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.gray : Color.blue)
            .cornerRadius(10)
    }
}

struct GreenButtonStyle: ButtonStyle {
    var isEnabled: Bool
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(configuration.isPressed ? Color.gray : (isEnabled ? Color.green : Color.gray))
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

struct SidebarButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.white)
            .padding(.horizontal)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(5)
    }
}
