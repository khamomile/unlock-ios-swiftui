//
//  ImagePicker.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/28.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        @MainActor
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { newImage, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            UnlockService.shared.errorMessage = "이미지 업로드에 실패하였습니다.\n 다른 이미지를 선택해주세요."
                        }
                        print(error.localizedDescription)
                    } else {
                        self.parent.image = newImage as? UIImage
                    }
                }
            }
        }
    }
}
