//
//  ProfilePostEmptyView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct ProfilePostEmptyView: View {
    var body: some View {
        ZStack {
            VStack {
                ForEach(0..<2) { _ in
                    HStack {
                        ForEach(0..<2) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.gray0)
                                .frame(width: UIScreen.main.bounds.width/2 - 16, height: 130)
                        }
                    }
                }
            }

            VStack {
                Text("아무 생각이나 적어보세요.")
                    .font(.mediumBody)
                    .foregroundColor(.gray9)

                NavigationLink {
                    PostComposeView()
                } label: {
                    Image("pencil")
                        .padding()
                        .background(Circle().fill(Color.gray9.opacity(0.8)))
                }
            }
        }
        .padding(.top, 40)
    }
}

struct ProfilePostEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePostEmptyView()
    }
}
