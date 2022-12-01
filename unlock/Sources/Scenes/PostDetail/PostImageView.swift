//
//  PostImageView.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/03.
//

import SwiftUI
import Kingfisher

struct PostImageView: View {
    @EnvironmentObject var appState: AppState
    
    var title: String
    var imageURL: String
    var opacity: Double
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.opacity(opacity)
                .ignoresSafeArea()
                .onTapGesture {
                    appState.showImageView = false
                }
            
            Button {
                appState.showImageView = false
            } label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.gray1)
            }
            .padding(20)

            VStack {
                KFImage(URL(string: imageURL))
                    .placeholder {
                        Image(systemName: "person.fill.questionmark")
                    }
                    .retry(maxCount: 2, interval: .seconds(2))
                    .onFailure({ e in
                        appState.forceErrorMessage("프로필 이미지 로딩에 실패했습니다.")
                    })
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .padding(.bottom, 50)
                
                Text(title)
                    .font(.mediumBody)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        

    }
}

struct PostImageView_Previews: PreviewProvider {
    static var previews: some View {
        PostImageView(title: "제목이에요", imageURL: "https://unlock-user-media.s3.ap-northeast-2.amazonaws.com/profile/480x480/1667445564199-C009A64E-049A-48DE-B3D8-31C440B2FA8E.webp", opacity: 0.8)
    }
}
