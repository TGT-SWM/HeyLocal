//
//  SerialQueue.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

/// ODsay API 연동 간,
/// PlanDetailScreen을 만들때마다 새 큐를 만들어 실행하니, 여러 큐가 같이 생성되어 동시에 실행됨.
/// 시간 당 요청 수가 많아져 Too many request 에러가 반환되었음.
/// 이에 큐를 따로 만들어 실행하지 않고, Global하게 하나의 큐를 만들어 놓고 ODsay API 호출 시마다 사용하도록 함.
///
/// 큐에 너무 많은 Task가 쌓이는 문제가 있음. Task는 화면을 나온다고 사라지지 않기 때문에,
/// 백그라운드에서 API 요청이 계속 실행됨.
/// 지금 생각하기에 더 나은 방법은, 큐는 각 PlanDetailScreen마다 생성하고,
/// PlanDetailScreen을 벗어날 경우 큐 안의 모든 Task들을 cancel하도록 구현하는 것.
let serialQueue = DispatchQueue(label: "serialQueue")
