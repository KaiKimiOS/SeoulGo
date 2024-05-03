//
//  ToastAlert.swift
//  SeoulGo
//
//  Created by kaikim on 3/4/24.
//

import SwiftUI

extension View {
    func toastAlert(
        isPresented:Binding<Bool>,
        title:String) -> some View {
            return modifier(ToastAlertModifier(isPresented: isPresented, title: title))
        }
}

struct ToastAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let title:  String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(.black.opacity(0.3))
                        .blur(radius: isPresented ? 2 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            self.isPresented =  false
                        }
                    ToastAlert(isPresented: self.$isPresented, title: self.title)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(isPresented ? .spring(response : 0.3) : .none, value: isPresented)
            
        }
    }
}

struct ToastAlert: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var isPresented:Bool
    let title: String
    var body: some View {
        
        VStack {
            Image("SeoulGoImage")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            Divider()
            Text(title)
                .font(.callout)
                .bold()
                .foregroundStyle(.black)
                .lineLimit(1)
                
            
        }
        .padding(.horizontal,20)
        .padding(.vertical, 30)
        .frame(width:240)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.blue.opacity(0.5))
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white)
                )
        )
    }
}

//#Preview {
//
//    Text("ggg")
//        .modifier(ToastAlert(isPresented: .constant(true), title: "저장되었습니다")) as! any View
//}
