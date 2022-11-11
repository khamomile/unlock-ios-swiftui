import SwiftUI

// Credit: https://medium.com/nerd-for-tech/6f4792c1ba19

struct TextEditorApproachView: View {
    
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    var placeholder: String
    var editorBackgroundColor: Color
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack(alignment: .topLeading) {
                    editorBackgroundColor
                        .opacity(0.3)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    if text.count == 0 {
                        Text(placeholder)
                            .font(.regularBody)
                            .foregroundColor(.gray2)
                            .padding()
                            .opacity(1)
                    }

                    if #available(iOS 16.0, *) {
                        TextEditor(text: Binding($text, replacingNilWith: ""))
                            .focused($isFocused)
                            .frame(minHeight: 30, alignment: .leading)
                            .cornerRadius(6.0)
                            .multilineTextAlignment(.leading)
                            .font(.regularBody)
                            .foregroundColor(.gray6)
                            .padding(9)
                            .scrollContentBackground(.hidden)
                    } else {
                        // Fallback on earlier versions
                        TextEditor(text: Binding($text, replacingNilWith: ""))
                            .focused($isFocused)
                            .frame(minHeight: 30, alignment: .leading)
                            .cornerRadius(6.0)
                            .multilineTextAlignment(.leading)
                            .font(.regularBody)
                            .foregroundColor(.gray6)
                            .padding(9)
                    }
                }
            }
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
}

struct TextEditorApproachView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorApproachView(text: .constant(""), placeholder: "신고 내용을 입력해주세요.", editorBackgroundColor: .gray1)
    }
}

public extension Binding where Value: Equatable {
    
    init(_ source: Binding<Value>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue },
            set: { newValue in
                if newValue == nilProxy {
                    source.wrappedValue = "" as! Value
                } else {
                    source.wrappedValue = newValue
                }
            }
        )
    }
}
