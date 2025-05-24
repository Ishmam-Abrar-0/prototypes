//
//  ContentView.swift
//  Thunder Storm
//
//  Created by Ishmam Abrar on 3/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var trigger = 0
    @State var isActive = false
    
    var body: some View {
        
        HStack {
            
            
            VStack  {
                Image(systemName: "wifi")
                    .scaleEffect(4)
                    .symbolEffect(.variableColor, isActive: isActive)
                
                Button (isActive ? "Active" : "Inactive") {
                    isActive.toggle()
                }
                .padding(.top, 50)
            }
        }
    }
}

#Preview {
    ContentView()
}
