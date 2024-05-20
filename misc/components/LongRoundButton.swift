//
//  LongRoundButton.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/16/24.
//

import SwiftUI
import Foundation

struct LongRoundButton: View {
    var action: () -> Void
    var icon: Bool = false
    var label: String
    var icon_name: String = ""
    var system_icon: Bool = false
    var background_color: Color = .black
    var text_color: Color = .white
    var icon_color: Color = .white

    var body: some View {
        Button(action: action) {
            HStack {
                if icon {
                    if system_icon {
                        Image(systemName: icon_name)
                            .padding(.trailing, 5)
                            .foregroundColor(icon_color)
                    } else {
                        Image(icon_name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.trailing, 5)
                    }
                }
                Text(label).bold()
            }
            .padding(.leading, icon ? 30 : 0)
//            .padding(.trailing, 30)
            .shadow(radius: 10)
        }
        .frame(width: 300, height: 50)
        .font(.system(size: 20, design: .rounded))
        .foregroundColor(text_color)
//        .padding()
        .background(background_color)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .gray, radius: 3, x: 0, y: 0)
    }
}

#Preview {
    @State var s = "test"
    return HostView(state: $s)
}
