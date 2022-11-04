//
//  HotPlaceComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct HotPlaceComponent: View {
    var place: Place
	
	var body: some View {
		NavigationLink(destination: PlaceDetailScreen(place: place)) {
			label
		}
	}
	
    var label: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                if place.thumbnailUrl != nil {
                    AsyncImage(url: URL(string: place.thumbnailUrl!)) { phash in
                        if let image = phash.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 208, height: 208)
                                .cornerRadius(10)
                        }
                        else {
                            Rectangle()
                                .fill(Color("lightGray"))
                                .frame(width: 208, height: 208)
                                .cornerRadius(10)
                        }
                    }
                }
                else {
                    Rectangle()
                        .fill(Color("lightGray"))
                        .frame(width: 208, height: 208)
                        .cornerRadius(10)
                }
                
                
                
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 208, height: 208)
                    .cornerRadius(10)
                    .opacity(0.2)
                
                //
                VStack(alignment: .leading) {
                    // 지역 이름
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.black)
                            .frame(width: 74, height: 20)
                        
                        HStack {
                            Text("\(regionNameFormatter(region: place.region!))")
                                .foregroundColor(Color.white)
                                .font(.system(size: 12))
                        }
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    // 장소 이름
                    HStack {
                        Spacer()
                            .frame(width: 5)
                        
                        Text("\(place.name)")
                            .foregroundColor(Color.white)
                            .font(.system(size: 14))
                    }
                }
                .padding()
            }
        }
    }
}
