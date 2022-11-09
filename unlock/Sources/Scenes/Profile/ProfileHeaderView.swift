//
//  ProfileHeaderView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.boldHeadline)
            Spacer()
            NavigationLink {
                SearchView()
            } label: {
                Image("search")
            }
            NavigationLink {
                SettingView()
            } label: {
                Image("settings")
                    .offset(CGSize(width: 5.0, height: 0.0))
            }
        }
        .background(Color.white)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(title: "Profile")
    }
}
