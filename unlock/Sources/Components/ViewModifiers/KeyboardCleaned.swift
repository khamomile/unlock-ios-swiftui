//
//  KeyboardCleaned.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/29.
//

import SwiftUI

struct KeyboardCleaned: ViewModifier {
    var keyboardType: UIKeyboardType = .default
    @Binding var text: String
    
    var characterSet: CharacterSet?
    var wordCount: Int?
    
    func body(content: Content) -> some View {
        return content
            .keyboardType(keyboardType)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onChange(of: text) {
                var resultText = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if let characterSet = characterSet {
                    resultText = String(resultText.unicodeScalars.filter {
                        characterSet.contains($0)
                    })
                }
                
                if let wordCount = wordCount {
                    resultText = String(resultText.prefix(wordCount))
                }
                
                text = resultText
            }
    }
}

extension View {
    func keyboardCleaned(keyboardType: UIKeyboardType, text: Binding<String>, characterSet: CharacterSet? = nil, wordCount: Int? = nil) -> some View {
        return self.modifier(KeyboardCleaned(keyboardType: keyboardType, text: text, characterSet: characterSet, wordCount: wordCount))
    }
}

struct KeyboardCleaned_Previews: PreviewProvider {
    static var previews: some View {
        TextField("Test textfield", text: .constant(""))
            .keyboardCleaned(keyboardType: .default, text: .constant(""))
    }
}
