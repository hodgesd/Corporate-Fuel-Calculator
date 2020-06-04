//
//  CapsuleView.swift
//  Corporate Fuel Calculator
//
//  Created by Derrick Hodges on 3/14/20.
//  Copyright © 2020 Derrick Hodges. All rights reserved.
//

import SwiftUI

struct CapsuleView: View {

    var title:String
    var max:CGFloat
    var height:CGFloat

    var body: some View {


        VStack {
            ZStack (alignment: .bottom){
                Capsule().frame(width: 25, height: max)
                    .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                Capsule().frame(width: 25, height: height)
                    .foregroundColor(.white)
            }
            Text ("\(title)").padding(.top, 8).padding(.horizontal, 6)
        }//.padding(.horizontal, 8)
    }
}

struct CapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            CapsuleView(title: "Ramp", max: 220, height: 88)
            CapsuleView(title: "Ramp", max: 200, height: 50)
            CapsuleView(title: "Ramp", max: 200, height: 88)
            CapsuleView(title: "Ramp", max: 200, height: 50)

        }
    }
}
