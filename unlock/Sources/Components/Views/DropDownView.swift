//
//  DropDownView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/25.
//

import SwiftUI

struct DropDownView: View {
    @State var showStoreDropDown: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text("Test")
            Spacer()
            Image("dots-horizontal")
        }.overlay (
            VStack {
                if showStoreDropDown {
                    Spacer(minLength: 20)
                    SampleDropDown(buttonInfo: [CustomButtonInfo(title: "숨기기", btnColor: .red, action: { print("Hi") })])
                    .offset(CGSize(width: -11.0, height: 5.0))
                }
            }, alignment: .topTrailing
        )
        .onTapGesture {
            showStoreDropDown.toggle()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct SampleDropDown: View {
    let buttonInfo: [CustomButtonInfo]
    
    // let action : (String?) -> Void
    
    var body: some View {
        VStack(alignment: .leading){
            //            ForEach(0...3, id: \.self){ valueStore in
            //
            //                Divider().background(.gray1)
            //            }
            
            ForEach(buttonInfo, id: \.self) { info in
                Button {
                    info.action()
                } label: {
                    HStack {
                        Text(info.title)
                            .font(.lightCaption1)
                            .foregroundColor(info.btnColor)
                    }
                    .frame(width: 128)
                }
                .padding(6)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.white).shadow(radius: 1)
        )

        .frame(width: 128)
    }
}

struct DropDownView_Previews: PreviewProvider {
    static var previews: some View {
        DropDownView()
    }
}
