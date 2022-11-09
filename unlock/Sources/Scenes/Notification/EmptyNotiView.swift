//
//  EmptyNotiView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct EmptyNotiView: View {
    var body: some View {
        VStack {
            Text("아직 알림이 없어요.")
                .font(.lightCaption2)
                .foregroundColor(.gray6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyNotiView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyNotiView()
    }
}
