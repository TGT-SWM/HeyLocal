//
//  ImagePicker.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import PhotosUI
import UIKit

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresent: Bool
    @Binding var images: [UIImage]
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(picker: self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        // 고를 수 있는 사진의 최대 갯수 3개 (기존 포함)
        config.selectionLimit = 3 - self.images.count
        
        // filter 무엇을 가져올 것인지 (이미지만, 비디오만 등등)
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    
    class Coordinator: PHPickerViewControllerDelegate {
        var picker: ImagePicker
        
        init(picker: ImagePicker) {
            self.picker = picker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            self.picker.isPresent = false
//             가져올때마다 초기화 하고 다시 가져온다
//            self.picker.images.removeAll()
//            if self.picker.images.count == 3 {
//                
//            }
            for img in results {
                
                if img.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    img.itemProvider.loadObject(ofClass: UIImage.self) { (loadImage, error) in
                        guard let hasImage = loadImage else {
                            print("\(type(of: loadImage))")
                            print("empty image")
                            print(img.itemProvider.suggestedName!)
                            print(error.debugDescription)
                            return
                        }
                        self.picker.images.append(hasImage as! UIImage)
//                        do {
//                            if loadImage != nil {
//                                self.picker.images.append(loadImage as! UIImage)
//                            } else {
//                                print("ERROR ===================== \(error!.localizedDescription)")
//                            }
//                        }
//                        catch {
//                            print("ERROR ===================== \(error.localizedDescription)")
//                        }
                        
                    }
                } else {
                    print("fail to load")
                }
            }
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}


struct TopicsExperienceCards: View {
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false /// set Binding back to false
                }) {
                    Image(systemName: "xmark")
                        .padding()
                }
            }
            
            Spacer()
        }
    }
}
