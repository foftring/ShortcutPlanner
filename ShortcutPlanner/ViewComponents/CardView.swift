//
//  CardView.swift
//  ShortcutPlanner
//
//  Created by Frank Oftring on 12/3/22.
//

import SwiftUI

struct CardView: View {

    @State var expandView: Bool = false
    @Binding var triggerDate: Date
    @Binding var shouldRepeat: Bool
    @Binding var offset: CGSize
    let shortcut: Shortcut
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: expandView ? 375 : 300, height: expandView ? 600 : 200)
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 20)
                .shadow(color: Color.gray.opacity(0.7), radius: 10, x: 0, y: 5)
            
            VStack {
                if !expandView {
                    Spacer()
                }
                Text(shortcut.title)
                    .font(.title2)
                    .foregroundColor(.black)
                Spacer()
                if expandView {
                    ReminderView(triggerDate: $triggerDate, shouldRepeat: $shouldRepeat, shortcut: shortcut)
                    Spacer()
                }
                Image(systemName: expandView ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        withAnimation {
                            expandView.toggle()
                        }
                    }
                    .frame(alignment: .bottom)
            }
            .padding()
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
        .offset(x: offset.width, y: offset.height)
        .frame(width: expandView ? 375 : 300, height: expandView ? 600 : 200)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            CardView(triggerDate: .constant(Date()), shouldRepeat: .constant(true), offset: .constant(.zero), shortcut: dev.shotcut)
        }
    }
}

