//
//  CustomImagePicker.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import Photos

struct CustomImagePicker: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.displayTabBar) var displayTabBar
    
    @Binding var selectedImages: [SelectedImage]
    @Binding var showingPicker: Bool
    
    @State var grid: [[Images]] = []
    @State var disabled = false
    @State var nowImages: Int = 0
    
    var body: some View {
        VStack {
            if !self.grid.isEmpty {
                /// 사진 grid
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(self.grid, id:\.self) { i in
                            HStack {
                                ForEach(i, id:\.self) { j in
                                    Card(data: j, selectedImages: self.$selectedImages, limit: self.nowImages)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                /// 사진 선택 버튼
                Button(action: {
                    self.showingPicker.toggle()
                    dismiss()
                }) {
                    Text("사진 선택완료")
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                        .frame(width: UIScreen.main.bounds.width / 2)
                }
                .background(Color("orange").opacity((self.selectedImages.count != 0) ? 1 : 0.5))
                .clipShape(Capsule())
                .padding(.bottom)
                .disabled((self.selectedImages.count != 0) ? false : true)
            } // if
             
            else {
                if self.disabled {
                    Text("Enable Storage Access In Settings")
                }
                if self.grid.count == 0 {
                    Indicator()
                }
            } // else
        } // vstack
        .onAppear {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized{
                    self.getAllImages()
                    self.disabled = false
                }
                else{
                    print("not authorized")
                    self.disabled = true
                }
            }
        }
        .navigationTitle("사진선택")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    } // body
    
    
    /// 이미지 전체 불러오기
    func getAllImages() {
        let opt = PHFetchOptions()
        opt.includeHiddenAssets = false
        
        let req = PHAsset.fetchAssets(with: .image, options: .none)
        DispatchQueue.global(qos: .background).async {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            for i in stride(from: 0, to: req.count, by: 3) {
                var iteration: [Images] = []
                
                for j in i..<i+3 {
                    if j < req.count {
                        PHCachingImageManager.default().requestImage(for: req[j], targetSize: CGSize(width: 150, height: 150), contentMode: .default, options: options) { (image, _) in
                            
                            let data1 = Images(selected: false, asset: req[j], image: image!)
                            
                            iteration.append(data1)
                        }
                    }
                }
                self.grid.append(iteration)
            }
        }
    }
}

struct Card: View {
    @State var data: Images
    @Binding var selectedImages: [SelectedImage]
    @State var limit: Int
    
    var body: some View {
        ZStack {
            Image(uiImage: self.data.image)
                .resizable()
            
            if self.data.selected {
                ZStack {
                    Color.black.opacity(0.5)
                    
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
            
        }
        .frame(width: (UIScreen.main.bounds.width - 80) / 3, height: 90)
        .onTapGesture{
            if !self.data.selected {
                /// 전체 사진 갯수가 3개 미만일 시
                if (limit + self.selectedImages.count) < 3{
                    self.data.selected = true
                    DispatchQueue.global(qos: .background).async {
                        let options = PHImageRequestOptions()
                        options.isSynchronous = true
                        
                        PHCachingImageManager.default().requestImage(for: self.data.asset, targetSize: .init(), contentMode: .default, options: options) { (image, _) in

                            self.selectedImages.append(SelectedImage(asset: self.data.asset, image: image!))
                        }
                    }
                }
            }
            else {
                for i in 0..<self.selectedImages.count {
                    if self.selectedImages[i].asset == self.data.asset {
                        self.selectedImages.remove(at: i)
                        self.data.selected = false
                        return
                    }
                }
            }
        }
    }
}


struct Images: Hashable {
    var selected: Bool
    var asset: PHAsset
    var image: UIImage
}

struct SelectedImage: Hashable {
    var asset: PHAsset
    var image: UIImage
}

struct Indicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) { }
}
