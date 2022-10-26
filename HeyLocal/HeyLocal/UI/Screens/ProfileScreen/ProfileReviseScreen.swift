//
//  ProfileReviseScreen.swift
//  HeyLocal
//  사용자 프로필 수정 화면 (프로필·닉네임·주 활동지·소개 수정)
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileReviseScreen: View {
    @StateObject var viewModel = ProfileScreen.ViewModel()
    @StateObject var regionViewModel = RegionPickerScreen.ViewModel()
    
    @Environment(\.displayTabBar) var displayTabBar
    @Environment(\.dismiss) private var dismiss
    
    @State var showingSheet: Bool = false
    @State var showPhotoPicker:Bool = false
    @State var isDeleted: Bool = false
    @State var userImage: [UIImage] = []
    @State var regionId: Int? = nil
    @State var updateData: AuthorUpdate = AuthorUpdate(activityRegionId: 0,
                                                       introduce: "",
                                                       nickname: "")
    var body: some View {
        VStack {
            profile
            
            Spacer()
                .frame(height: 20)
            
            information
            
            Spacer()
                .frame(height: 40)
            
            // MARK: - 편집 완료 버튼
            Button(action: {
                updateData.nickname = viewModel.authorUpdate.nickname
                if regionId == nil {
                    updateData.activityRegionId = viewModel.authorUpdate.activityRegionId!
                } else {
                    updateData.activityRegionId = regionId!
                }
                updateData.introduce = viewModel.authorUpdate.introduce
                
                
                if userImage.count > 0 {
                    isDeleted = false
                }
                
                viewModel.updateUserProfile(userId: 2, userData: updateData, profileImage: userImage, isDeleted: isDeleted)
                dismiss()
            }) {
                ZStack {
                    Rectangle()
                        .fill(Color("orange"))
                        .frame(width: 350, height: 44)
                        .cornerRadius(22)
                    
                    
                    Text("프로필 편집완료")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white)
                }
            }
        }
        .onAppear {
            viewModel.getUserProfile(userId: 2)
            displayTabBar(false)
        }
        .navigationTitle("프로필 편집")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton { displayTabBar(true) })
    }
    
    // MARK: - 프로필 사진
    var profile: some View {
        HStack {
            Spacer()
            
            VStack {
                if userImage.count == 0 {
                    if isDeleted {
                        ZStack {
                            Circle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .frame(width: 96, height: 96)
                                .shadow(color: Color("gray"), radius: 3)
                            
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("gray"))
                        }
                    }
                    else {
                        if viewModel.author.profileImgDownloadUrl == nil {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                    .frame(width: 96, height: 96)
                                    .shadow(color: Color("gray"), radius: 3)
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color("gray"))
                            }
                        }
                        else {
                            AsyncImage(url: URL(string: viewModel.author.profileImgDownloadUrl!)) { phash in
                                if let image = phash.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 96, height: 96)
                                        .shadow(color: Color("gray"), radius: 3)
                                }
                                else if phash.error != nil {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                            .frame(width: 96, height: 96)
                                            .shadow(color: Color("gray"), radius: 3)
                                        
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(Color("gray"))
                                    }
                                }
                                else {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                            .frame(width: 96, height: 96)
                                            .shadow(color: Color("gray"), radius: 3)
                                        
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(Color("gray"))
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    Image(uiImage: userImage[0])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 96, height: 96)
                        .shadow(color: Color("gray"), radius: 3)
                }
                
                
                Spacer()
                    .frame(height: 13)
                
                
                Button(action: {
                    showingSheet.toggle()
                    
//                    if userImage.count == 1 {
//                        userImage.removeAll()
//                    }
                }) {
                    Text("프로필 사진 바꾸기")
                        .font(.system(size: 12))
                        .underline()
                        .foregroundColor(Color("orange"))
                }
                .sheet(isPresented: $showPhotoPicker, content: {
                    ImagePicker(isPresent: $showPhotoPicker, images: $userImage, limit: 1)
                    
                })
            }
            .confirmationDialog("", isPresented: $showingSheet, titleVisibility: .hidden) {
                Button("앨범에서 선택") {
                    showPhotoPicker.toggle()
                }
                Button("프로필 사진 삭제", role: .destructive) {
                    isDeleted = true
                }
                Button("취소", role: .cancel) {
                }
            }
            
            
            Spacer()
        }
    }
    
    // MARK: - 닉네임 · 주 활동지 · 소개
    var information: some View {
        VStack {
            // nickname
            Group {
                VStack(alignment: .leading) {
                    Text("닉네임")
                        .font(.system(size: 14))
                    
                    Spacer()
                        .frame(height: 3)
                    
                    TextField(" 2-10자 이내로 입력해주세요", text: $viewModel.authorUpdate.nickname)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 44)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                }
            }
            
            Spacer()
                .frame(height: 10)
            
            // activityRegion
            Group {
                VStack(alignment: .leading) {
                    Text("주 활동지")
                        .font(.system(size: 14))
                    
                    Spacer()
                        .frame(height: 3)
                    
                    NavigationLink(destination: RegionPickerScreen(regionID: $regionId, forSort: false)) {
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                                .frame(width: 350, height: 44)
                                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                                .cornerRadius(10)
                            
                            HStack {
                                Text("\(regionViewModel.regionName)")
                                
                                Spacer()
                                                                
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color(red: 110 / 255, green: 108 / 255, blue: 106 / 255))
                                    .padding()
                            }
                            .font(.system(size: 12))
                            .onAppear {
                                if regionId == nil {
                                    regionViewModel.getRegion(regionId: viewModel.authorUpdate.activityRegionId!)
                                }
                                else {
                                    regionViewModel.getRegion(regionId: regionId!)
                                }
                            }
                        }
                        .foregroundColor(Color("gray"))
                        .frame(width: 350)
                    }
                }
            }
            
            
            Spacer()
                .frame(height: 10)
            
            // introduce
            Group {
                VStack(alignment: .leading) {
                    Text("소개")
                        .font(.system(size: 14))
                    
                    Spacer()
                        .frame(height: 3)
                    
                    TextField(" 2-10자 이내로 입력해주세요", text: $viewModel.authorUpdate.introduce)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 44)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct ProfileReviseScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileReviseScreen()
    }
}
