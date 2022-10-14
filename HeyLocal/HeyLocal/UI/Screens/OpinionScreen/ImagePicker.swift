////
////  ContentView.swift
////  ImagePickerPrac
////
////  Created by 최정인 on 2022/10/12.
////
//
//import SwiftUI
//import PhotosUI
//
//struct Tmpp: View {
//    @State var showImagePicker: Bool = false
//    @State var image: Image? = nil
//    @State var generalImages: [UIImage] = [UIImage]()
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Button(action: {
//                    self.showImagePicker.toggle()
//                }) {
//                    Text("Show image picker")
//                }
//                image?
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .cornerRadius(10.0)
//
//                ForEach(generalImages, id:\.self) { img in
//                    Image(uiImage: img)
//                }
//
//            }
//            .sheet(isPresented: $showImagePicker) {
//                ImagePicker(sourceType: .photoLibrary) { image in
//                    self.image = Image(uiImage: image)
//                }
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Tmpp()
//    }
//}
//
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Environment(\.presentationMode)
//    private var presentationMode
//
//    let sourceType: UIImagePickerController.SourceType
//    let onImagePicked: (UIImage) -> Void
//
//    final class Coordinator: NSObject,
//    UINavigationControllerDelegate,
//    UIImagePickerControllerDelegate {
//
//        @Binding
//        private var presentationMode: PresentationMode
//        private let sourceType: UIImagePickerController.SourceType
//        private let onImagePicked: (UIImage) -> Void
//
//        init(presentationMode: Binding<PresentationMode>,
//             sourceType: UIImagePickerController.SourceType,
//             onImagePicked: @escaping (UIImage) -> Void) {
//            _presentationMode = presentationMode
//            self.sourceType = sourceType
//            self.onImagePicked = onImagePicked
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController,
//                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//            onImagePicked(uiImage)
//            presentationMode.dismiss()
//
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            presentationMode.dismiss()
//        }
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(presentationMode: presentationMode,
//                           sourceType: sourceType,
//                           onImagePicked: onImagePicked)
//    }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController,
//                                context: UIViewControllerRepresentableContext<ImagePicker>) {
//
//    }
//
//}


//
//  ContentView.swift
//  PhotoPickerPrac
//
//  Created by 최정인 on 2022/09/07.
//

import SwiftUI
import PhotosUI

struct ImgPrac: View {
    @State var isPresentPicker = false
    @State var images = [UIImage]()
    
    var body: some View {
        VStack {
            content
        }
    }
    
    var content: some View {
        VStack {
            Button("Select Images") {
                isPresentPicker = true
            }
            
            List {
                ForEach(images, id:\.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.size.width)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        
                }
            }
        }
        .sheet(isPresented: $isPresentPicker, content: {
            ImagePicker(isPresent: $isPresentPicker, images: $images)
        })
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresent: Bool
    @Binding var images: [UIImage]
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(picker: self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        // 고를 수 있는 사진의 최대 갯수 0:무제한
        config.selectionLimit = 3
        
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
            
            for img in results {
                if img.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    img.itemProvider.loadObject(ofClass: UIImage.self) { (loadImage, error) in
                        guard let hasImage = loadImage else {
                            print("empty image")
                            return
                        }
                        self.picker.images.append(hasImage as! UIImage)
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImgPrac()
    }
}
