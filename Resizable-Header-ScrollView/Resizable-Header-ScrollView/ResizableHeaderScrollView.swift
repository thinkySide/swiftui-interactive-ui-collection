//
//  ResizableHeaderScrollView.swift
//  Resizable-Header-ScrollView
//
//  Created by 김민준 on 7/26/25.
//

import SwiftUI

struct ResizableHeaderScrollView<Header: View, Content: View>: View {
    
    var mininmumHeight: CGFloat
    var maximumHeight: CGFloat
    var ignoreSafeAreaTop: Bool = false
    var isSticky: Bool = false
    
    /// CGFloat: Resize Progress
    /// EdgeInsets: Safe Area Values
    @ViewBuilder var header: (CGFloat, EdgeInsets) -> Header
    @ViewBuilder var content: Content
    
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let safeArea = ignoreSafeAreaTop ? proxy.safeAreaInsets : .init()
            
            ScrollView(.vertical) {
                /// Section의 Header를 화면 위에 고정
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        content
                    } header: {
                        GeometryReader { _ in
                            /// Header가 Resize되는 Progress를 계산하는 코드
                            /// offsetY를 사용하여 현재 스크롤 위치를 계산하고,
                            /// minimumHeight - maximumHeignt는 Header가 줄어들 수 있는 최대 높이.
                            /// min, max를 이용해 값을 0~1 사이로 제한.
                            let progress: CGFloat = min(max((offsetY / (maximumHeight - mininmumHeight)), 0), 1)
                            let resizedHeight = (maximumHeight + safeArea.top) - (maximumHeight - mininmumHeight) * progress
                            
                            header(progress, safeArea)
                                .frame(height: resizedHeight, alignment: .bottom)
                                /// offsetY를 이용해 Sticky Header를 구현
                                .offset(y: isSticky ? (offsetY < 0 ? offsetY : 0) : 0)
                        }
                        .frame(height: maximumHeight + safeArea.top)
                    }
                }
            }
            /// Safe Area를 무시하는 코드
            /// ignoreSafeAreaTop이 true일 때, top safe area를 무시하고,
            /// false라면 기본 safe area를 적용합니다.
            .ignoresSafeArea(.container, edges: ignoreSafeAreaTop ? [.top] : [])
            /// ScrollView의 offset을 감지하는 코드(iOS 18부터 지원)
            /// 이 코드는 ScrollView의 contentOffset을 감지하여 offsetY 상태 변수를 업데이트합니다.
            .onScrollGeometryChange(for: CGFloat.self) {
                $0.contentOffset.y + $0.contentInsets.top
            } action: { oldValue, newValue in
                offsetY = newValue
            }
        }
    }
}

