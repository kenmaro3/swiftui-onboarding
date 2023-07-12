//
//  CustomIndicatorView.swift
//  OnBoarding
//
//  Created by Kentaro Mihara on 2023/07/08.
//

import SwiftUI

struct CustomIndicatorView: View {
    // View Properties
    var totalPage: Int
    var currentPage: Int
    var activeTint: Color = .black
    var inActiveTint: Color = .gray.opacity(0.5)
    
    var body: some View {
        HStack(spacing: 8){
            ForEach(0..<totalPage, id: \.self){
                Circle()
                    .fill(currentPage == $0 ? activeTint : inActiveTint)
                    .frame(width: 4, height: 4)
            }
        }
    }
}

//struct CustomIndicatorView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomIndicatorView()
//    }
//}
