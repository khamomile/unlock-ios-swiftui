//
//  HelpView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack(alignment: .leading) {
            BasicHeaderView(text: "도움말")

            List {
                Link("이용약관", destination: URL(string: "https://polyester-ghoul-e62.notion.site/Unlock-b6ed1f758c0f41608f7a37ec8c6ce23f")!)
                    .font(.lightBody)
                
                Link("개인정보처리방침", destination: URL(string: "https://www.unlock.im/privacy.html")!)
                    .font(.lightBody)
                
                Link("커뮤니티 이용규칙", destination: URL(string: "https://polyester-ghoul-e62.notion.site/Unlock-23ca9a66c9ec429ca4ccea2fb593a417")!)
                    .font(.lightBody)
                
                Link("문의하기", destination: URL(string: "https://open.kakao.com/o/sBy0VeLe")!)
                    .font(.lightBody)
            }
            .listStyle(.inset)
        }
        .navigationBarHidden(true)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
