//
//  AuthView.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/25/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct AuthView: View {
    var model: AuthenticationModel
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Image("PParty").resizable().scaledToFit().frame(width: 200, height: 200).clipShape(RoundedRectangle(cornerRadius: 25.0))
            }
            
            Spacer()
            Spacer()
            Spacer()
            
            SignInWithAppleButton(onRequest: { request in
                //
                model.handleSignInWithAppleRequest(request)
            }, onCompletion: { result in
                //
                model.handleSignInWithAppleCompletion(result)
            })
            .frame(width: 250, height: 50)
            
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    @State var auth = AuthenticationModel()
    return AuthView(model: auth)
}
