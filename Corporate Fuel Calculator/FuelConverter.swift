//
//  FuelConverter.swift
//  Corporate Fuel Calculator
//
//  Created by Derrick Hodges on 12/14/19.
//  Copyright © 2019 Derrick Hodges. All rights reserved.
//

import SwiftUI

class SliderData {
    var fromUnits: String = "Pounds"
    var toUnits: String = "Gallons"
    var defaultUnits = 10000.0
    var maxRange: Double = 30000.0
    var step: Int = 100
    var gallonMultiplier: Double = 0.149253731
    var literMultiplier: Double = 0.263852243

    func toggle(toggleBool: Bool) {
        if toggleBool == true {
            fromUnits = "Pounds"
            toUnits = "Gallons"
            defaultUnits = 10000.0
            maxRange = 30000.0
            step = 100
            gallonMultiplier = 0.149253731
            literMultiplier = 0.263852243

        } else {
            fromUnits = "Gallons"
            toUnits = "Pounds"
            defaultUnits = 1000.0
            maxRange = 4500.0
            step = 1
            gallonMultiplier = 6.7
            literMultiplier = 3.79
        }
    }
}

struct FuelConverter: View {
    @State private var pounds: Double = 5000
    @State private var computeCost: Bool = false
    @State private var pricePerGal: Double = 3.4
    var wheelPPG: Double = 4.4
    @State var poundsToGals: Bool = true
    @State private var fuelDollars: Int = 3
    @State private var fuelTenths: Int = 4
    @State private var fuelHundredths: Int = 1
    var sliderData = SliderData()
 //   var fuelCost: Double = 1.0

    private var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        // allow no currency symbol, extra digits, etc
        f.isLenient = true
        f.maximumFractionDigits = 3
        f.numberStyle = .currency
        return f
    }()

    private var ppgPrice: Double {
        return Double(fuelDollars * 100 + fuelTenths * 10 + fuelHundredths) / 100
    }

    private var fuelcost: Double {
        if poundsToGals == true{
            return pounds * ppgPrice / 6.7
        } else {
            return pounds * ppgPrice
        }

    }

    var body: some View {
        NavigationView {
            Form {

       //         Button ("%", action: toggleCount = 1)
// Pounds to Gallons
//                if poundsToGals == true {

                Text("\(Int(pounds)) \(sliderData.fromUnits)")
                    .font(.largeTitle)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                Slider (value: $pounds, in: 0...sliderData.maxRange, step: Double (sliderData.step))

                HStack {
                //    Text(self.sliderData.fromUnits)
                    Text("\(Int(pounds * sliderData.gallonMultiplier)) \(sliderData.toUnits)")
                    Spacer()
                    Text("\(Int(pounds * sliderData.literMultiplier)) Liters")
                }



                Section {
                    VStack {
                        HStack {
                            //          Text("Price Per Gallon")
                            //            .font(.body)

                            Toggle(isOn: $computeCost) {
                                Text("Compute Cost")
                            }.frame(width: 150.0)
                                .padding(.trailing, 80)
                            Spacer()
                            if computeCost == true {
                                Text("Price/Gal $\(ppgPrice, specifier: "%.2f")")
                                    .font(.body)
                            }

                        }.font(.footnote)
                        if computeCost == true {
                            HStack {
                                Text("$")
                                Picker(selection: $fuelDollars, label: EmptyView()) {
                                    ForEach(0...9, id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }.pickerStyle(WheelPickerStyle()).frame(width: 20, height: 90)
                                    .clipped()
                                Text(".")
                                Picker(selection: $fuelTenths, label: EmptyView()) {
                                    ForEach(0...9, id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20, height: 90)
                                .clipped()

                                Picker(selection: $fuelHundredths, label: EmptyView()) {
                                    ForEach(0...9, id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20, height: 90)
                                .clipped()
                            }
//                            if (self.poundsToGals == true) {
//                                fuelCost = pounds * ppgPrice / 6.7
//                            } else {
//                                fuelCost = self.pounds * ppgPrice
//                            }
                            Text("$\(fuelcost, specifier: "%.2f")")
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                                .font(.largeTitle)
                        }
                    }
                }

            }
            .font(.title)
            .navigationBarTitle("Fuel Converter")
            .navigationBarItems(trailing:
                HStack {
                    Text("lb")
                    Button(action: {
                        self.poundsToGals.toggle()
                        self.sliderData.toggle(toggleBool: self.poundsToGals)
                        self.pounds = self.sliderData.defaultUnits
                    })
                    {
                        Image(systemName: "arrow.swap")
                    }
                    Text ("gal")
            })
        }
    }
}

struct FuelConverter_Previews: PreviewProvider {
    static var previews: some View {
        FuelConverter()
    }
}
