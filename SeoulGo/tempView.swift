//
//  tempView.swift
//  SeoulGo
//
//  Created by kaikim on 1/12/24.
//

import SwiftUI

import SwiftUI

struct tempView: View {
    @AppStorage("cliked") private var count = 0
    
    var body: some View {
        VStack {
            Text("clicked count: \(count)")
            Button("click") {
                count += 1
            }
        }
    }
}
#Preview {
    tempView()
}
