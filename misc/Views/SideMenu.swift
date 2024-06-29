//
//  SideMenu.swift
//  misc
// https://medium.com/geekculture/side-menu-in-ios-swiftui-9fe1b69fc487
//  Created by Rodrigo Munoz on 6/6/24.
//

import SwiftUI
import FirebaseAuth

struct SideMenu: View {
    @Binding var isShowing: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .transition(edgeTransition)
                    .background(Color.clear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}


enum SideMenuRowType: Int, CaseIterable{
    case signout = 0
    case delete
    
    var title: String{
        switch self {
        case .signout:
            return "Sign Out"
        case .delete:
            return "Delete Account"
        }
    }
    
    var iconName: String{
        switch self {
        case .signout:
            return "person"
        case .delete:
            return "trash"
        }
    }
}
