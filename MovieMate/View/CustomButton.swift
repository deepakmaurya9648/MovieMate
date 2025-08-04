//
//  CustomButton.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 04/08/25.
//

import SwiftUI

struct CustomButton: View {
    // Parameters
    var title: String? = nil
    var icon: Image? = nil
    var backgroundColor: Color = .blue
    var foregroundColor: Color = .white
    var borderColor: Color = .clear
    var cornerRadius: CGFloat = 8
    var height: CGFloat = 50
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                
                if let title = title {
                    Text(title)
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity,minHeight: height,maxHeight: height)
            .padding()
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
//    CustomButton(title: <#T##String?#>, icon: <#T##Image?#>, backgroundColor: <#T##Color#>, foregroundColor: <#T##Color#>, borderColor: <#T##Color#>, cornerRadius: <#T##CGFloat#>) {
//        <#code#>
//    }
}
