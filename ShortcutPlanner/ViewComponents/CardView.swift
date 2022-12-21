//
//  CardView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/3/22.
//

import SwiftUI

struct CardView: View {
    
    @Binding var offset: CGSize
    let shortcut: Shortcut
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 300, height: 200)
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 20)
                .shadow(color: Color.gray.opacity(0.7), radius: 10, x: 0, y: 5)
            
            Text(shortcut.title)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
        .offset(x: offset.width, y: offset.height)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(offset: .constant(.zero), shortcut: Shortcut(title: "Card 5"))
    }
}
