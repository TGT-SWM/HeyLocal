//
//  User.swift
//  HeyLocal
//  사용자 관련 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct Author: Codable, Identifiable {
    var id: Int { userId }
    var userId: Int = 0
    var userRole: String? = ""
    var nickname: String = ""
    var activityRegion: Region? = Region()
    var introduce: String? = ""
    var profileImgDownloadUrl: String? = ""
    var knowHow: Int? = 0
    var ranking: Int? = 0
    var acceptedOpinionCount: Int? = 0
    var totalOpinionCount: Int? = 0
}
struct AuthorUpdate: Codable {
    var activityRegionId: Int? = 0
    var introduce: String = ""
    var nickname: String = ""
}
