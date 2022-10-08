//
//  RegionPicker.swift
//  HeyLocal
//  지역 선택 컴포넌트
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct RegionComponent: View {
    var region: Region
    var body: some View {
        Button(action: {}) {
            HStack {
                // TODO: 지역 이미지로 변경
                Circle()
                    .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                    .frame(width: 56, height: 56)
                
                Spacer()
                    .frame(width: 20)
                
                Text("\(regionNameFormatter(region: region))")
                    .font(.system(size: 16))
                    .foregroundColor(Color.black)
            }
        }
    }
}

// MARK: - 지역이름 Format
func regionNameFormatter(region: Region) -> String {
    var resultName: String = region.state
    
    // city 값이 null이 아닌 경우
    if ((region.city) != nil) {
        if region.state == "경기도" || region.state == "강원도" {
            resultName.append(contentsOf: " ")
            resultName.append(contentsOf: region.city!)
        }
        else {
            resultName = region.state.substring(from: 0, to: 0)
            resultName.append(region.state.substring(from: 2, to: 2))
            resultName.append(contentsOf: " ")
            resultName.append(contentsOf: region.city!)
        }
        
        return resultName
    }
    // city 값이 null인 경우
    else {
        if region.state == "제주특별자치도" {
            resultName = "제주도"
        }
        else if region.state == "세종특별자치시" {
            resultName = "세종특별시"
        }
        else {
            resultName = region.state
        }
        return resultName
    }
}

// MARK: - string 쪼개주는 substring 함수 구현
extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)
        
        return String(self[startIndex ..< endIndex])
    }
}
