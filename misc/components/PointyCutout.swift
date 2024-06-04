//
//  PointyCutout.swift
//  misc
//
//  Created by Rodrigo Munoz on 6/4/24.
//

import SwiftUI


struct Menu: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX/4, y: rect.maxY/4))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY/4))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY/4))
        path.addLine(to: CGPoint(x: (rect.maxX/4)*3, y: rect.maxY/4))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY/4))
        path.closeSubpath()
//        path.stroke(.black, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
        return path
    }
    
    
}

struct PointyCutout: View {
    var body: some View {
        Menu()
//            .fill(.red)
            .frame(width: 300, height: 300)
    }
}

#Preview {
    PointyCutout()
}
