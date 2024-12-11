//
//  CommonStyles.swift
//  AryHoops
//
//  Created by aryan on 12/2/24.
//

// CommonStyles.swift
import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        ZStack(alignment: .leading) {
            configuration
                .padding(12)
                .foregroundColor(.black)  // Ensures text color is black for visibility
        }
        .background(Color.white)  // Ensures the text field background is white
        .cornerRadius(8)
        .shadow(radius: 1)  // Adds subtle shadow for better contrast
    }
}
