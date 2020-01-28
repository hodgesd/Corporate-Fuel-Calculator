//
//  FuelConverter.swift
//  Corporate Fuel Calculator
//
//  Created by Derrick Hodges on 12/14/19.
//  Copyright © 2019 Derrick Hodges. All rights reserved.
//

import SwiftUI

struct FuelConverter: View {
    @State private var pounds: Double = 5000
    @State private var computeCost: Bool = false
    @State private var pricePerGal: Double = 3.4
    var wheelPPG: Double = 4.4

    @State private var fuelDollars: Int = 3
    @State private var fuelTenths: Int = 4
    @State private var fuelHundredths: Int = 1

    private var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        // allow no currency symbol, extra digits, etc
        f.isLenient = true
        f.maximumFractionDigits = 3
        f.numberStyle = .currency
        return f
    }()

    private var ppgPrice: Double {
        return Double (fuelDollars*100 + fuelTenths*10 + fuelHundredths)/100
    }

    var body: some View {

        NavigationView {
            Form{
         //       Spacer()
                Text("\(Int (pounds)) Pounds")
                    .font(.largeTitle)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)

                Slider(value: $pounds, in: 0...30000, step: 100)
                HStack{
                    Text("\(Int(pounds / 6.7)) Gallons")
                    Spacer()
                    Text("\(Int(pounds / 3.79)) Liters")
                }

                Section{

                    VStack {
                        HStack{

                            //          Text("Price Per Gallon")
                            //            .font(.body)

                            Toggle (isOn: $computeCost) {
                                Text("Compute Cost")
                            }.frame(width: 150.0)
                                .padding(.trailing, 80)
                            Spacer()
                            if computeCost == true {
                            Text("Price/Gal $\(ppgPrice, specifier: "%.2f")")
                                .font(.body)
                            }


                        }.font(.footnote)
                        if computeCost == true{
//                            HStack{
//                                Text("Price/Gal $\(ppgPrice, specifier: "%.2f")")
//                                    .font(.body)


//                            }

                            HStack {
                                Text ("$")
                                Picker(selection: $fuelDollars, label: EmptyView()) {
                                    ForEach((0...9), id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }.pickerStyle(WheelPickerStyle()).frame(width: 20, height: 90)
                                    .clipped()
                                Text(".")
                                Picker(selection: $fuelTenths, label: EmptyView()) {
                                    ForEach((0...9), id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20, height: 90)
                                .clipped()

                                Picker(selection: $fuelHundredths, label: EmptyView()) {
                                    ForEach((0...9), id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20, height: 90)
                                .clipped()

//                                Picker(selection: $hundredsDigit, label: EmptyView()) {
//                                    ForEach((0...9), id: \.self) { ix in
//                                        Text("\(ix)").tag(ix)
//                                    }
//                                }
//                                .pickerStyle(WheelPickerStyle())
//                                .frame(width: 20, height: 90)
//                                .clipped()
//
//                                Picker(selection: $tensDigit, label: EmptyView()) {
//                                    ForEach((0...0), id: \.self) { ix in
//                                        Text("\(ix)").tag(ix)
//                                    }
//                                }
//                                .pickerStyle(WheelPickerStyle())
//                                .frame(width: 20, height: 90)
//                                .clipped()
//
//                                Picker(selection: $onesDigit, label: EmptyView()) {
//                                    ForEach((0...0), id: \.self) { ix in
//                                        Text("\(ix)").tag(ix)
//                                    }
//                                }
//                                .pickerStyle(WheelPickerStyle())
//                                .frame(width: 20, height: 90)
//                                .clipped()
//                                Text (" pounds").font(.body)
                            }

                            Text("$\(pounds*ppgPrice/6.7, specifier: "%.2f")")
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                                .font(.largeTitle)
                           //     .foregroundColor(.red)



                        }

                    }
                    //        Divider()
                }

            }.font(.title)
            .navigationBarTitle("Fuel Calculator")
        }
    }
}

struct FuelConverter_Previews: PreviewProvider {
    static var previews: some View {
        FuelConverter()
    }
}
