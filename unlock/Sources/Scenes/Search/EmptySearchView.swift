//
//  EmptySearchView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct EmptySearchView: View {
    var body: some View {
        VStack {
            Text("검색 결과가 없어요.")
                .font(.lightCaption2)
                .foregroundColor(.gray6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptySearchView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchView()
    }
}
