//
//  OpinionRepository.swift
//  HeyLocal
//  답변 레포지터리
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct OpinionRepository {
    private let agent = NetworkAgent()
    private let opinionUrl =  "\(Config.apiURL)/travel-ons"
    
    // 답변 목록조회
    func getOpinions(travelOnId: Int) -> AnyPublisher<[Opinion], Error> {
        let urlString = "\(opinionUrl)/\(travelOnId)/opinions"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        return agent.run(request)
    }
    
    // 답변 삭제
    func deleteOpinion(travelOnId: Int, opinionId: Int) {
        let urlString = "\(opinionUrl)/\(travelOnId)/opinions/\(opinionId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("ERROR: error calling DELETE")
                return
            }
            guard let data = data else {
                print("ERROR: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("ERROR: HTTP request failed")
                return
            }
        }.resume()
    }
    
    // 답변 등록
    func postOpinion(travelOnId: Int, opinionData: Opinion, generalImages: [SelectedImage], foodImages: [SelectedImage], cafeImages: [SelectedImage], photoSpotImages: [SelectedImage]) -> Int {
        // opinionData to JSON Encoding
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(opinionData)
        var jsonStr: String = ""
        
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonStr = jsonString
        }
        
        let urlString = "\(opinionUrl)/\(travelOnId)/opinions/"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        
        var httpResponseStatusCode: Int = 0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print(error?.localizedDescription ?? "No Data")
                return
            }
            httpResponseStatusCode = httpResponse.statusCode
            
            if httpResponseStatusCode == 201 {
                self.getOpinions(travelOnId: travelOnId)
                let resultCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                let resultLen = data
                let resultString = String(data: resultLen, encoding: .utf8) ?? ""
                
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let generalURL = jsonObject!["GENERAL"] as? NSArray
                let foodURL = jsonObject!["RECOMMEND_FOOD"] as? NSArray
                let cafeURL = jsonObject!["RECOMMEND_DRINK_DESSERT"] as? NSArray
                let photoSpotURL = jsonObject!["PHOTO_SPOT"] as? NSArray
                print("")
                print("====================================")
                print("[requestPOST : http post 요청 성공]")
                print("resultCode : ", resultCode)
                print("resultLen : ", resultLen)
                print("resultString : ", resultString)
                
                /// 이미지 업로드 링크 - Presigned URL
                for i in 0..<generalURL!.count {
                    print(generalURL![i])
                    let putUrl = URL(string: generalURL![i] as! String)!
                    var putRequest = URLRequest(url: putUrl)
                    
                    putRequest.httpMethod = "PUT"
                    putRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")
                    
                    putRequest.httpBody = generalImages[i].image.jpegData(compressionQuality: 1)
                    let putTask = URLSession.shared.dataTask(with: putRequest) { data, response, error in
                        guard let data = data else {
                            return
                        }
                    }
                    putTask.resume()
                }
                for i in 0..<foodURL!.count {
                    print(foodURL![i])
                    let putUrl = URL(string: foodURL![i] as! String)!
                    var putRequest = URLRequest(url: putUrl)
                    
                    putRequest.httpMethod = "PUT"
                    putRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")
                    
                    putRequest.httpBody = foodImages[i].image.jpegData(compressionQuality: 1)
                    let putTask = URLSession.shared.dataTask(with: putRequest) { data, response, error in
                        guard let data = data else {
                            return
                        }
                    }
                    putTask.resume()
                }
                for i in 0..<cafeURL!.count {
                    print(cafeURL![i])
                    let putUrl = URL(string: cafeURL![i] as! String)!
                    var putRequest = URLRequest(url: putUrl)
                    
                    putRequest.httpMethod = "PUT"
                    putRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")
                    
                    putRequest.httpBody = cafeImages[i].image.jpegData(compressionQuality: 1)
                    let putTask = URLSession.shared.dataTask(with: putRequest) { data, response, error in
                        guard let data = data else {
                            return
                        }
                    }
                    putTask.resume()
                    
                }
                for i in 0..<photoSpotURL!.count {
                    print(photoSpotURL![i])
                    let putUrl = URL(string: photoSpotURL![i] as! String)!
                    var putRequest = URLRequest(url: putUrl)
                    
                    putRequest.httpMethod = "PUT"
                    putRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")
                    
                    putRequest.httpBody = photoSpotImages[i].image.jpegData(compressionQuality: 1)
                    let putTask = URLSession.shared.dataTask(with: putRequest) { data, response, error in
                        guard let data = data else {
                            return
                        }
                    }
                    putTask.resume()
                }
                
                print("====================================")
                print("")
                
            } else {
                print("\(error?.localizedDescription)")
                
                let dataSTR = String(data: data, encoding: .utf8)!
                print(dataSTR)
                return
            }
        }
        task.resume()
        return httpResponseStatusCode
    }
    

    
    // 답변 수정
    func updateOpinion(travelOnId: Int, opinionId: Int, opinionData: Opinion,
                       generalImages: [SelectedImage], foodImages: [SelectedImage], cafeImages: [SelectedImage], photoSpotImages: [SelectedImage],
                       deleteImages: [String], deleteFoodImages: [String], deleteCafeImages: [String], deletePhotoSpotImages: [String]) {
        
        // opinionData to JSON Encoding
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(opinionData)
        var jsonStr: String = ""
        
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonStr = jsonString
        }
        
        let urlString = "\(opinionUrl)/\(travelOnId)/opinions/\(opinionId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        /// AuthManager.shared.
        request.httpBody = jsonData
        var httpResponseStatusCode: Int = 0
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print(error?.localizedDescription ?? "No Data")
                return
            }
            httpResponseStatusCode = httpResponse.statusCode
            print(httpResponseStatusCode)
            if httpResponseStatusCode == 200 {
                self.getOpinions(travelOnId: travelOnId)
                let resultCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                let resultLen = data
                let resultString = String(data: resultLen, encoding: .utf8) ?? ""
                
                let decoder = JSONDecoder()
                do {
                    let responseURLs = try decoder.decode([imgURL].self, from: data)
                    
                    for i in 0..<responseURLs.count {
                        // MARK: - 공통 사진
                        if responseURLs[i].imgType == "GENERAL" {
                            let generalPUTs = responseURLs[i].putUrls
                            let generalDELETEs = responseURLs[i].deleteUrls
                            
                            // 삭제 진행 후
                            if !deleteImages.isEmpty {
                                var deleteArrays: [Int] = []

                                for i in 0..<deleteImages.count {
                                    let tmp = deleteImages[i].components(separatedBy: "/")
                                    let deleteNum = tmp[tmp.count - 1].components(separatedBy: ".png")[0]

                                    deleteArrays.append(Int(deleteNum)!)
                                }
                                deleteArrays = deleteArrays.sorted().reversed()

                                for i in 0..<deleteArrays.count {
                                    let deleteURL = URL(string: generalDELETEs[deleteArrays[i]])!
                                    var deleteRequest = URLRequest(url: deleteURL)

                                    deleteRequest.httpMethod = "DELETE"
                                    let deleteTask = URLSession.shared.dataTask(with: deleteRequest) { data, response, error in
                                        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                                            print(error?.localizedDescription ?? "NO Data")
                                            return
                                        }
                                    }
                                    deleteTask.resume()
                                }
                            }
                            
                            // reUpload
                            let startNum = generalDELETEs.count - deleteImages.count //
                            for i in 0..<generalImages.count {
                                let putURL = URL(string: generalPUTs[i + startNum])!
                                var putRequest = URLRequest(url: putURL)

                                putRequest.httpMethod = "PUT"
                                putRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")

                                putRequest.httpBody = generalImages[i].image.jpegData(compressionQuality: 1) // error
                                let putTask = URLSession.shared.dataTask(with: putRequest) { data, response, error in
                                    guard let data = data else {
                                        return
                                    }
                                }
                                putTask.resume()
                            }
                        }
                        
                        // MARK: - 음식점
                        else if responseURLs[i].imgType == "RECOMMEND_FOOD" {
                            let foodPUTs = responseURLs[i].putUrls
                            let foodDELETEs = responseURLs[i].deleteUrls
                            
                            // 삭제 진행 후
                            if !deleteFoodImages.isEmpty {
                                var deleteArrays: [Int] = []

                                for i in 0..<deleteFoodImages.count {
                                    let tmp = deleteFoodImages[i].components(separatedBy: "/")
                                    let deleteNum = tmp[tmp.count - 1].components(separatedBy: ".png")[0]

                                    deleteArrays.append(Int(deleteNum)!)
                                }
                                deleteArrays = deleteArrays.sorted().reversed()

                                for i in 0..<deleteArrays.count {
                                    let deleteURL = URL(string: foodDELETEs[deleteArrays[i]])!
                                    var deleteRequest = URLRequest(url: deleteURL)

                                    deleteRequest.httpMethod = "DELETE"
                                    let deleteTask = URLSession.shared.dataTask(with: deleteRequest) { data, response, error in
                                        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                                            print(error?.localizedDescription ?? "NO Data")
                                            return
                                        }
                                    }
                                    deleteTask.resume()
                                }
                            }
                            
                            // reUpload
                            let startNum = foodDELETEs.count - deleteFoodImages.count
                            for i in 0..<foodImages.count {
                                let putURL = URL(string: foodPUTs[i + startNum])!
                                var putRequest = URLRequest(url: putURL)

                                putRequest.httpMethod = "PUT"
                                putRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")

                                putRequest.httpBody = foodImages[i].image.jpegData(compressionQuality: 1) // error
                                let putTask = URLSession.shared.dataTask(with: putRequest) { data, response, error in
                                    guard let data = data else {
                                        return
                                    }
                                }
                                putTask.resume()
                            }
                        }
                        
                        // MARK: - 카페
                        else if responseURLs[i].imgType == "RECOMMEND_DRINK_DESSERT" {
                            let cafePUTs = responseURLs[i].putUrls
                            let cafeDELETEs = responseURLs[i].deleteUrls
//
//                            print("CAFE PUTs", cafePUTs)
//                            print("CAFE DELETEs", cafeDELETEs)
                            
                            // 삭제 진행 후
                            if !deleteCafeImages.isEmpty {
                                var deleteArrays: [Int] = []

                                for i in 0..<deleteCafeImages.count {
                                    let tmp = deleteCafeImages[i].components(separatedBy: "/")
                                    let deleteNum = tmp[tmp.count - 1].components(separatedBy: ".png")[0]

                                    deleteArrays.append(Int(deleteNum)!)
                                }
                                deleteArrays = deleteArrays.sorted().reversed()

                                for i in 0..<deleteArrays.count {
                                    let deleteURL = URL(string: cafeDELETEs[deleteArrays[i]])!
                                    var deleteRequest = URLRequest(url: deleteURL)

                                    deleteRequest.httpMethod = "DELETE"
                                    let deleteTask = URLSession.shared.dataTask(with: deleteRequest) { data, response, error in
                                        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                                            print(error?.localizedDescription ?? "NO Data")
                                            return
                                        }
                                    }
                                    deleteTask.resume()
                                }
                            }
                            
                            // reUpload
                            let startNum = cafeDELETEs.count - deleteCafeImages.count //
                            for i in 0..<cafeImages.count {
                                let putURL = URL(string: cafePUTs[i + startNum])!
                                var putRequest = URLRequest(url: putURL)

                                putRequest.httpMethod = "PUT"
                                putRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")

                                putRequest.httpBody = cafeImages[i].image.jpegData(compressionQuality: 1) // error
                                let putTask = URLSession.shared.dataTask(with: putRequest) { data, response, error in
                                    guard let data = data else {
                                        return
                                    }
                                }
                                putTask.resume()
                            }
                        }
                        
                        // MARK: - 포토스팟
                        else {
                            let photoSpotsPUTs = responseURLs[i].putUrls
                            let photoSpotsDELETEs = responseURLs[i].deleteUrls
                            
                            if !deletePhotoSpotImages.isEmpty {
                                var deleteArrays: [Int] = []

                                for i in 0..<deletePhotoSpotImages.count {
                                    let tmp = deletePhotoSpotImages[i].components(separatedBy: "/")
                                    let deleteNum = tmp[tmp.count - 1].components(separatedBy: ".png")[0]

                                    deleteArrays.append(Int(deleteNum)!)
                                }
                                deleteArrays = deleteArrays.sorted().reversed()

                                for i in 0..<deleteArrays.count {
                                    let deleteURL = URL(string: photoSpotsDELETEs[deleteArrays[i]])!
                                    var deleteRequest = URLRequest(url: deleteURL)

                                    deleteRequest.httpMethod = "DELETE"
                                    let deleteTask = URLSession.shared.dataTask(with: deleteRequest) { data, response, error in
                                        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                                            print(error?.localizedDescription ?? "NO Data")
                                            return
                                        }
                                    }
                                    deleteTask.resume()
                                }
                            }
                            
                            // reUpload
                            let startNum = photoSpotsDELETEs.count - deletePhotoSpotImages.count //
                            for i in 0..<photoSpotImages.count {
                                let putURL = URL(string: photoSpotsPUTs[i + startNum])!
                                var putRequest = URLRequest(url: putURL)

                                putRequest.httpMethod = "PUT"
                                putRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")

                                putRequest.httpBody = photoSpotImages[i].image.jpegData(compressionQuality: 1) // error
                                let putTask = URLSession.shared.dataTask(with: putRequest) { data, response, error in
                                    guard let data = data else {
                                        return
                                    }
                                }
                                putTask.resume()
                            }
                        }
                    }
                } catch {
                    print("?????")
                }
                
                print("")
                print("====================================")
                print("[requestPOST : http post 요청 성공]")
                print("resultCode : ", resultCode)
                print("resultLen : ", resultLen)
                print("resultString : ", resultString)
                
            } else {
                print("\(error!.localizedDescription)")
                
                let dataSTR = String(data: data, encoding: .utf8)!
                print(dataSTR)
                return
            }
        }
        task.resume()
    }
}

struct imgURL: Decodable {
    var imgType: String
    var putUrls: [String]
    var deleteUrls: [String]
}

