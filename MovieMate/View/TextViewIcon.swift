//
//  TextViewIcon.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 02/09/25.
//

import SwiftUI

struct TextViewIcon: View {
    var body: some View {
        IconTextView(
                        icon: "circle.fill",   // any SF Symbol
                        title: "Your paragraph them to be mixed with the consistem for better alignment when wrapping to multiple lines."
                    )
    }
}

#Preview {
    TextViewIcon()
}


struct IconTextView: View {
    let icon: String
    let title: String
    
    var attributedString: AttributedString {
        var result = AttributedString()
        
        // Convert UIImage → NSTextAttachment → NSAttributedString → AttributedString
        if let iconImage = UIImage(systemName: icon)?
            .withTintColor(.systemBlue, renderingMode: .alwaysOriginal) {
            
            let attachment = NSTextAttachment()
            attachment.image = iconImage
            attachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
            
            let nsAttr = NSAttributedString(attachment: attachment)
            result += AttributedString(nsAttr)
        }
        
        result += AttributedString(" " + title)
        return result
    }
    
    var body: some View {
        Text(attributedString)
            .font(.body)
            .multilineTextAlignment(.center)   // center wrapped text under icon
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(Color.red)
    }
}
