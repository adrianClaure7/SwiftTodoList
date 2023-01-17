//
//  ContentView.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/13/23.
//

import SwiftUI

struct ContentView: View {
    @State var isMenuOpen: Bool = false
    @State var transcription: String = ""
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Sidebar")
                    .font(.headline)
                    .padding()
                List {
                    Button(action: {
                        
                    }) {
                        Text("Task List")
                    }
                    .buttonStyle(BasicButtonStyle())
                    .padding()
                }
            }
            .frame(width: 150)
            .background(Color.gray)
            
            Spacer()
            
            VStack {
                ListTaskView()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}