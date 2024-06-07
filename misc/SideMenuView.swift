//
//  SideMenuView.swift
//  misc
//https://medium.com/geekculture/side-menu-in-ios-swiftui-9fe1b69fc487
//  Created by Rodrigo Munoz on 6/6/24.
//

import SwiftUI
import FirebaseAuth

struct SideMenuView: View {
    
    @Binding var presentSideMenu: Bool
    @Binding var state: String
    var body: some View {
        HStack {
            
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                    .shadow(color: .purple.opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    RowView(  title: "Sign Out") {
                        AuthenticationModel.shared.signout()
                        presentSideMenu.toggle()
                    }
                    RowView(  title: "Delete Account") {
                        guard let user = Auth.auth().currentUser else { return }

                        user.delete { error in
                          if let error = error {
                              print("\(error)")
                          } else {
                              print("Account deleted.")
                              state = "Spotify"
                              AuthenticationModel.shared.authenticated = .loggedout
                          }
                        }
                        presentSideMenu.toggle()
                    }
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 100, leading: 20, bottom: 0, trailing: 0))
                .frame(width: 270)
                .background(Color.white)
            }
            
            
            Spacer()
        }
        .background(.clear)
    }
    
    func RowView(  title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 20){
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .padding()
                        .foregroundColor(.black)
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        
    }
    
}

#Preview {
    @State var s = true
    @State var d = "Spotify"
    return SideMenuView( presentSideMenu: $s, state: $d)
}
