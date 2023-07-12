//
//  PageIntro.swift
//  OnBoarding
//
//  Created by Kentaro Mihara on 2023/07/08.
//

import SwiftUI

// MARK: Page Intro Model
struct PageIntro: Identifiable, Hashable{
    var id: UUID = .init()
    var introAssetImage: String
    var title: String
    var subTitle: String
    var displayAction: Bool = false
}

var pageIntros: [PageIntro] = [
    .init(introAssetImage: "page1", title: "Connect With Creators\n Easily", subTitle: "Thank you for choosing us, we can save your lovely time"),
    .init(introAssetImage: "page2", title: "Get Inspiration\n From Creators", subTitle: "Find your favorite creator and get inspired by them"),
    .init(introAssetImage: "page3", title: "Let's Get Started", subTitle: "To register for an account, kindly enter your detail", displayAction: true),
]


