//
//  User.swift
//  HeyLocal
//  사용자 관련 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct Author: Decodable {
    var userId: Int = 0
    var nickname: String = ""
    var activityRegion: Region = Region()
    var introduce: String = ""
    var profileImgDownloadUrl: String = ""
    var knowHow: Int? = 0
    var ranking: Int? = 0
    var acceptedOpinionCount: Int? = 0
}
