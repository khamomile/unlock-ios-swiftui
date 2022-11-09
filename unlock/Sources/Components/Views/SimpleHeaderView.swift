//
//  SimpleHeaderView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

struct SimpleHeaderView: View {
    @State private var showSearch = false
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.boldHeadline)
            
            Spacer()
            
            NavigationLink(value: NavButton.searchUser) {
                Image("search")
            }
        }
        .background(Color.white)
        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
    }
}

struct SimpleHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleHeaderView(title: "Unlock")
    }
}
