//
//  ScheduleEngine.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

// MARK: - 스케줄 생성 엔진에 대한 프로토콜

protocol ScheduleEngine {
	func run() -> [Place]
}


// MARK: - TSPScheduleEngine (ScheduleEngine의 TSP 알고리즘 구현체)

class TSPScheduleEngine: ScheduleEngine {
	// 파라미터
	private(set) var places: [Place]
	private(set) var weights: [[Double]]
	private(set) var startTime: Date
	private(set) var isLastDay: Bool
	
	// 스케줄 생성을 위한 데이터
	private var accomodations: [Place] = [] // 숙소
	private var restaurants: [Place] = [] // 식당
	private var _places: [Place] = [] // 숙소와 식당을 제외한 장소들
	private var _weights: [[Double]] = [] // 숙소와 식당을 제외한 이동 시간 행렬
	private var cache: [[Double]] = [] // 이동 시간에 대한 캐시
	
	init(places: [Place], weights: [[Double]], startTime: Date, isLastDay: Bool) {
		self.places = places
		self.weights = weights
		self.startTime = startTime
		self.isLastDay = isLastDay
	}
	
	/// 스케줄 생성 전, 필요한 데이터들을 만들어 저장합니다.
	private func preprocess() {
		// 데이터들을 초기화합니다.
		accomodations = []
		restaurants = []
		_places = []
		_weights = []
		cache = []
		
		// 카테고리에 따라 장소를 분류하여 저장합니다.
		// _places에는 숙소도 식당도 아닌 장소들만 저장합니다.
		for i in places.indices {
			switch places[i].category {
			case "AD5":
				accomodations.append(places[i])
			case "FD6":
				restaurants.append(places[i])
			default:
				_places.append(places[i])
			}
		}
		
		// 숙소를 _places의 맨 앞에 추가합니다.
		// 숙소가 여러 개 있어도 단 하나만 추가되며, 나머지는 버려집니다.
		if let accm = accomodations.first {
			_places = [accm] + _places
		}
		
		// _places의 원소들이 places 내에서 갖는 위치를 저장합니다.
		var indexMap: [Int] = []
		for place in _places {
			let index = places.firstIndex(of: place)!
			indexMap.append(index)
		}
		
		// 생성된 _places에 따라 weight 정보를 생성합니다.
		for i in _places.indices {
			let from = indexMap[i]
			var tmpArr: [Double] = []
			
			for j in _places.indices {
				let to = indexMap[j]
				tmpArr.append(weights[from][to])
			}
			
			_weights.append(tmpArr)
		}
		
		// 캐시 공간을 할당합니다.
		let n = _places.count
		for _ in 0..<n {
			var tmpArr = [Double]()
			for _ in 0..<(1 << n) {
				tmpArr.append(0)
			}
			cache.append(tmpArr)
		}
	}
	
	/// _places와 _times를 기준으로 여행 전체의 최소 이동 시간을 계산해 반환합니다.
	/// 계산 과정에서 cache 값을 업데이트하며, 이는 여행 경로를 구하기 위해 사용될 수 있습니다.
	private func getTravelTime(cur: Int, visited: Int) -> Double {
		// (기저 조건) 모든 곳을 방문했다면 종료합니다.
		if visited == (1 << _places.count) - 1 {
			if isLastDay {
				cache[cur][visited] = 0 // 숙소로 돌아가지 않고 끝나는 경우
			} else {
				cache[cur][visited] = _weights[cur][0] // 숙소로 돌아가는 경우
			}
			
			return cache[cur][visited]
		}
		
		// 알고 있는 경우 그대로 반환
		if cache[cur][visited] != 0 {
			return cache[cur][visited]
		}
		
		// 최소 시간 구하기
		var mn = Double.infinity
		for next in _places.indices {
			// 이미 방문한 곳은 패스
			if (visited & (1 << next)) != 0 {
				continue
			}
			
			// 현재 위치는 패스
			if _weights[cur][next] == 0 {
				continue
			}
			
			// 최소 시간 계산
			let t = _weights[cur][next] + getTravelTime(cur: next, visited: visited | (1 << next))
			mn = min(mn, t)
		}
		
		// 메모이제이션
		cache[cur][visited] = mn
		
		return mn
	}
	
	/// cache를 기준으로 여행 경로를 구해 반환합니다.
	private func getTravelPath(travelTime: Double) -> [Place] {
		var cur = 0
		var visited = 1
		var curToEnd = travelTime
		var path = [_places[cur]]
		
		for _ in _places.indices {
			for next in _places.indices {
				if (visited & (1 << next)) != 0 {
					continue
				}
				
				let curToNext = _weights[cur][next]
				let nextToEnd = cache[next][visited | (1 << next)]
				
				if curToEnd == curToNext + nextToEnd {
					path.append(_places[next])
					curToEnd = nextToEnd
					cur = next
					visited |= (1 << next)
				}
			}
		}
		
		if !isLastDay {
			path.append(_places[0]) // 숙소를 마지막에 추가
		}
		
		return path
	}
	
	/// 경로 내 각 장소의 도착 시간을 설정하여 반환합니다.
	private func setArrivalTimeOn(path: [Place]) -> [Place] {
		var result = path
		var curTime = startTime
		
		// 첫 번째 장소의 도착 시간 설정
		result[0].arrivalTime = DateFormat.dateToStr(curTime, "HH:mm:ss")
		
		// 두 번째 장소부터 도착 시간 설정
		for i in 1..<result.count {
			let prev = result[i - 1]
			let cur = result[i]
			
			let prevIdx = places.firstIndex(where: { $0.id == prev.id })!
			let curIdx = places.firstIndex(where: { $0.id == cur.id })!
			
			let minutes = weights[prevIdx][curIdx]
			let seconds = TimeInterval(minutes * 60 + 3600) // 각 장소마다 1시간(3600sec) 머무른다고 가정
			
			curTime = curTime.advanced(by: seconds)
			result[i].arrivalTime = DateFormat.dateToStr(curTime, "HH:mm:ss")
		}
		
		return result
	}
	
	func run() -> [Place] {
		// 필요한 데이터들을 생성합니다.
		preprocess()
		
		// 최소 이동 시간의 스케줄을 계산합니다.
		let travelTime = getTravelTime(cur: 0, visited: 1)
		print(travelTime)
		
		// 방문한 경로를 가져옵니다.
		var travelPath = getTravelPath(travelTime: travelTime)
		
		// 식당을 추가합니다.
		// TODO: 어떻게 해야 식당을 적절하게 끼워넣을 수 있을까?
		
		// 도착 시간을 설정합니다.
		travelPath = setArrivalTimeOn(path: travelPath)
		
		return travelPath
	}
}
