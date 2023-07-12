//
//  Home.swift
//  OnBoarding
//
//  Created by Kentaro Mihara on 2023/07/08.
//

import SwiftUI

struct Home: View {
    // View Properties
    @State private var activeIntro: PageIntro = pageIntros[0]
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var keyBoardHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            IntroView(intro: $activeIntro, size: size){
                /// User Login/Signup View
                VStack(spacing: 10){
                    CustomTextField(text: $emailID, hint: "Email Address", leadingIcon: Image(systemName: "envelope"))
                    CustomTextField(text: $emailID, hint: "Password", leadingIcon: Image(systemName: "lock"), isPassword: true)
                    
                }
                Spacer(minLength: 10)
                Button{
                    
                }label:{
                    Text("Continue")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background{
                            Capsule()
                                .fill(.black)
                        }
                }
            }
        }
        .padding(15)
        
        /// Manual keyboard push
        .offset(y: -keyBoardHeight)
        /// Disabling native keyboard push
        .ignoresSafeArea(.keyboard, edges: .all)

        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)){ output in
            if let info = output.userInfo, let height = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height{
                keyBoardHeight = height
            }
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)){ output in
            if let info = output.userInfo, let height = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height{
                keyBoardHeight = 0
            }
            
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: keyBoardHeight)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Intro View
struct IntroView<ActionView: View>: View{
    @Binding var intro: PageIntro
    var size: CGSize
    var actionView: ActionView
    
    init(intro: Binding<PageIntro>, size: CGSize, @ViewBuilder actionView: @escaping () -> ActionView){
        self._intro = intro
        self.size = size
        self.actionView = actionView()
    }
    
    /// Animation Properties
    @State private var showView: Bool = false
    @State private var hideWholeView: Bool = false
    
    
    var body: some View{
        VStack{
            // Image View
            GeometryReader{
                let size = $0.size
                
                Image(intro.introAssetImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.width)
            }
            /// Moving Up
            .offset(y: showView ? 0 : -size.height/2)
            .opacity(showView ? 1 : 0)
            
            // Tile & Action
            VStack(alignment: .leading, spacing: 10){
                Spacer(minLength: 0)
                
                Text(intro.title)
                    .font(.system(size: 40))
                    .fontWeight(.black)
                
                Text(intro.subTitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 15)
                
                if !intro.displayAction{
                    Group{
                        Spacer(minLength: 25)
                        
                        /// Custom Indicator View
                        CustomIndicatorView(totalPage: filteredPages.count, currentPage: filteredPages.firstIndex(of: intro) ?? 0)
                            .frame(maxWidth: .infinity)
                        
                        Spacer(minLength: 10)
                        
                        Button{
                           changeIntro()
                        } label:{
                            Text("Next")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: size.width*0.4)
                                .padding(.vertical, 15)
                                .background{
                                    Capsule()
                                        .fill(.black)
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                }else{
                    actionView
                        .offset(y: showView ? 0 : -size.height/2)
                        .opacity(showView ? 1 : 0)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            /// Moving Down
            .offset(y: showView ? 0 : size.height/2)
            .opacity(showView ? 1 : 0)
        }
        .offset(y: hideWholeView ? size.height/2 : 0)
        .opacity(hideWholeView ? 0 : 1)
        
        // Back Button
        .overlay(alignment: .topLeading){
            /// Hiding it for very first page, since thre is no previous page present
            if intro != pageIntros.first{
                Button{
                    changeIntro(true)
                    
                }label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                }
                .padding(10)
                // Animation back button
                // come from top
                .offset(y: showView ? 0 : -200)
                // hide by going back to top when in active
                .offset(y: hideWholeView ? -200 : 0)
                
            }
        }
        .onAppear{
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0).delay(0.1)){
                showView = true
            }
            
        }
    }
    
    //MARK: updating page intro
    func changeIntro(_ isPrevious: Bool = false){
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)){
            hideWholeView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            if let index = pageIntros.firstIndex(of: intro), (isPrevious ? index != 0  : index != pageIntros.count - 1 ){
                intro = isPrevious ? pageIntros[index-1] :  pageIntros[index + 1]
            }else{
                intro = isPrevious ? pageIntros[0] : pageIntros[pageIntros.count - 1]
            }
            
            // Re-Animating as split page
            hideWholeView = false
            showView = false
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)){
                showView = true
            }
        }
    }
    
    var filteredPages: [PageIntro] {
        return pageIntros.filter{!$0.displayAction}
    }
}
