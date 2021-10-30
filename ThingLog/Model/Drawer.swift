//
//  Drawer.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/30.
//

import Foundation

/// `Drawer` 객체가 되기 위해 명시한 프로토콜입니다.
protocol Drawerable {
    /// Drawer의 아이템 이름
    var title: String? { get set }
    
    /// Drawer의 아이템이 되기 위한 조건
    var subTitle: String? { get set }
    
    /// Drawer의 아이템이 되기 위한 상세한 설명
    var information: String? { get set }
    
    /// Drawer의 이미지 데이터
    var imageData: Data? { get }
    
    /// Drawer의 이미지 이름
    var imageName: String? { get set }
    
    /// 이미 달성했는지 여부
    var isAcquired: Bool { get set }
}

struct Drawer: Drawerable {
    var title: String?
    var subTitle: String?
    var information: String?
    var imageData: Data?
    var imageName: String?
    var isAcquired: Bool
}

// TODO: - ⚠️ Drawer이미지 교체
/// `CoreData`에 `Drawer`의 기본정보들을 저장하기 위한 객체입니다. 반드시 이미지 파일의 이름은 변경하지 않아야합니다.
struct DefaultDrawerModel {
    let drawers: [Drawerable] = [
        Drawer(title: "수학의 정석",
               subTitle: "방문 3회 달성",
               information: "집합 부분만 너덜거리는 수학의 정석. 작심 3일 하지 말고 끝까지 기록해 보자는 응원의 선물!",
               imageData: SwiftGenDrawers.sampleDrawer.image.pngData(),
               imageName: SwiftGenDrawers.sampleDrawer.name,
               isAcquired: false),
        Drawer(title: "문구세트",
               subTitle: "방문 30회 달성",
               information: "30일간 꾸준히 기록했네요. 앞으로도 열심히 하라고 문구세트를 드립니다!",
               imageData: SwiftGenDrawers.sampleDrawer.image.pngData(),
               imageName: SwiftGenDrawers.sampleDrawer.name,
               isAcquired: false),
        Drawer(title: "VIP 블랙카드",
               subTitle: "샀어요 물건 기록 총 100만원 이상 달성",
               information: "당신을 띵로그 VIP로 임명하여, 블랙카드를 수여합니다.",
               imageData: SwiftGenDrawers.sampleDrawer.image.pngData(),
               imageName: SwiftGenDrawers.sampleDrawer.name,
               isAcquired: false),
        Drawer(title: "장바구니",
               subTitle: "사고 싶다 게시물 물건 구매 완료하기",
               information: "사고 싶던 물건 첫 구매! 앞으로도 가득 담으라고 예쁜 장바구니 드려요.",
               imageData: SwiftGenDrawers.sampleDrawer.image.pngData(),
               imageName: SwiftGenDrawers.sampleDrawer.name,
               isAcquired: false),
        Drawer(title: "인의예지상",
               subTitle: "포도카드로 선물 감사 인사 전하기",
               information: "위 사람은 선물을 받으면 감사할 줄 아는 도리를 지닌 자로 인의예지상을 수여한다.",
               imageData: SwiftGenDrawers.sampleDrawer.image.pngData(),
               imageName: SwiftGenDrawers.sampleDrawer.name,
               isAcquired: false),
        Drawer(title: "드래곤볼",
               subTitle: "만족도 1-5개 기록 모으기",
               information: "모든 만족도가 모였어요! 소원을 빌어보세요!",
               imageData: SwiftGenDrawers.sampleDrawer.image.pngData(),
               imageName: SwiftGenDrawers.sampleDrawer.name,
               isAcquired: false)
    ]
}
