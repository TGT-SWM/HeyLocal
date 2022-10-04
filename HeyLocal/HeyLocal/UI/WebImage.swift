//
//  WebImage.swift
//  HeyLocal
//	웹에서 이미지를 로드해 출력하는 뷰
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

/// 웹에서 이미지를 가져와 디스플레이
/// iOS 15 미만에서 지원되지 않는 AsyncImage를 대체합니다.
struct WebImage: View {
    var url: String
    @ObservedObject var imageLoader = ImageLoader()
    @State var image = UIImage()
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .onReceive(imageLoader.$data) { data in
                guard let data = data else { return }
                self.image = UIImage(data: data) ?? UIImage()
            }
            .onAppear {
                self.imageLoader.loadData(from: url)
            }
    }
}

/// 웹에서 이미지를 가져와 WebImage에 전달하는 Publisher
class ImageLoader: ObservableObject {
    @Published var data: Data?
    
    func loadData(from: String) {
        guard let url = URL(string: from) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        WebImage(url: "https://www.apple.com/ac/structured-data/images/knowledge_graph_logo.png")
    }
}
