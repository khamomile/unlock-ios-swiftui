//
//  NotiItemView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI
import Kingfisher

struct NotiItemView: View {
    var noti: Notification
    
    var body: some View {
        NavigationLink(value: noti) {
            HStack(spacing: 14) {
                KFImage(URL(string: noti.sender.profileImage))
                    .placeholder {
                        Color.gray1
                    }
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 42, height: 42)
                
                VStack(alignment: .leading) {
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text(noti.sender.fullname)
                            .font(.boldCaption1)
                            .foregroundColor(.gray8)
                        Text(noti.type.notiDescription)
                            .font(.regularBody)
                            .foregroundColor(.gray8)
                    }

                    Text(noti.createdAt.format(with: "yyyy/MM/dd"))
                        .font(.regularCaption1)
                        .foregroundColor(.gray5)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
        }
    }
}

struct NotiItemView_Previews: PreviewProvider {
    static var previews: some View {
        NotiItemView(noti: Notification.preview)
    }
}
