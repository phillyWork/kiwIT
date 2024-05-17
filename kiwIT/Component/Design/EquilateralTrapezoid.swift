//
//  EquilateralTrapezoid.swift
//  kiwIT
//
//  Created by Heedon on 4/18/24.
//

import SwiftUI

struct EquilateralTrapezoid: Shape {
    
    var ratioForHorizonLength: CGFloat
    
    func path(in rect: CGRect) -> Path {
                
        var path = Path()
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX * ratioForHorizonLength, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX * (1 - ratioForHorizonLength), y: 0))
                
        path.closeSubpath()
        
        return path
    }
    

}

#Preview {
    EquilateralTrapezoid(ratioForHorizonLength: 0.35)
}
