//
//  ResultBox.swift
//  Corporate Fuel Calculator
//
//  Created by Derrick Hodges on 3/8/20.
//  Copyright © 2020 Derrick Hodges. All rights reserved.
//

import SwiftUI

struct ResultBox: View {
    var result: String
    var resultBoxColor: Color
    var resultSubtitle: String

    var body: some View {
        VStack{
            Text(result)
                .font(.headline)
                .fontWeight(.heavy)
                .frame(width: 200, height: 80)
                .background(resultBoxColor)
                .foregroundColor(.black)

            Text(resultSubtitle).font(.body)
        }
    }
}

struct ResultBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ResultBox(result: "Tanker", resultBoxColor: .green, resultSubtitle: "Buy 343 gallons at departure to save $2324.")
            ResultBox(result: "Do Not Tanker", resultBoxColor: .red, resultSubtitle: "Buy 223 gallons at destination to save $3454.")
        }


    }
}
