//
//  ZStackView.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/10.
//

import SwiftUI

struct ZStackView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            self.content
        }.border(Color.red,
                 width: 2)
    }
}

struct ZStackView_Previews: PreviewProvider {
    static var previews: some View {
        ZStackView(content: { Text("Hi") })
    }
}

