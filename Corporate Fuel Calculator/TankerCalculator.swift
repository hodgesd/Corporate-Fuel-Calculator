//
//  TankerCalculator.swift
//  Corporate Fuel Calculator
//
//  Created by Derrick Hodges on 2/25/20.
//  Copyright © 2020 Derrick Hodges. All rights reserved.
//

import SwiftUI

struct RampFeeSlider: View{
    @Binding var rampFee: Double
    var label: String


    var body: some View {
        HStack{
            Text("\(label)")
            Slider(value: $rampFee, in: 0...1250, step: 5.0)
            Text("$\(Int(rampFee))")
        }
    }
}



struct TankerCalculator: View {
    @State private var departureDollars: Int = 3
    @State private var departureTenths: Int = 3
    @State private var departureHundredths: Int = 3
    @State private var destinationDollars: Int = 5
    @State private var destinationTenths: Int = 5
    @State private var destinationHundredths: Int = 5

    @State private var duration: Double = 4.0
    @State private var rampFee: Double = 500.0
    @State private var waiverGals: Double = 600.0
    @State private var returnFuelPounds: Double = 9400.0
    let pickerFrameWidth:CGFloat = 40

    private var lowestFuelPlanPrice: Int {
        min(legFuelCost, waiverFuelCost, roundTripFuelCost)
    }

    private var lowestFuelPlan: Int {
        if min(legFuelCost, waiverFuelCost, roundTripFuelCost) == legFuelCost {
            return 0
        } else if min(legFuelCost, waiverFuelCost, roundTripFuelCost) == waiverFuelCost {
            return 1
        } else {
            return 2
        }
    }

    let fuelPlans = ["Buy Leg Fuel", "Buy Waiver Fuel", "Buy Roundtrip Fuel"]

    let breakEvenRatios = [1.053, 1.086, 1.123, 1.165, 1.210, 1.260, 1.315, 1.373]

    @State private var rampFeePicker = 0
    let rampFeePickers = ["No Ramp Fee", "Ramp Fee"]

    private var legFuelCost: Int {
        return Int(destinationPPG * returnGals + assessedRampFee)
    }

    private var waiverFuelCost: Int {
        if waiverGals <= returnGals {
            return Int((returnGals - waiverGals) * departurePPG + Double(waiverGalsCost))
        } else {
            return waiverGalsCost
        }
    }

    private var waiverGalsCost: Int {
        return Int(destinationPPG * waiverGals)
    }

    private var roundTripFuelCost: Int {
        if returnGals < waiverGals {
            return (Int(departurePPG * returnGals) + Int(rampFee))
        } else {
            return Int(departurePPG * returnGals)
        }
    }

    private var assessedRampFee: Double {
        if returnGals < waiverGals {
            return rampFee
        } else {
            return 0
        }
    }

    private var departureGals: Double {
        if waiverGals < returnGals {
            return (returnGals - waiverGals)
        } else {
            return returnGals
        }
    }

    private var departurePPG: Double {
        return Double(departureDollars * 100 + departureTenths * 10 + departureHundredths) / 100
    }

    private var destinationPPG: Double {
        return Double(destinationDollars * 100 + destinationTenths * 10 + destinationHundredths) / 100
    }

    private var returnGals: Double {
        return returnFuelPounds / 6.7
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()

                HStack {
                    Text("$")
                    Picker(selection: $departureDollars, label: EmptyView()) {
                        ForEach(0...9, id: \.self) { ix in
                            Text("\(ix)").tag(ix)
                        }
                    }.pickerStyle(WheelPickerStyle())
                        .frame(width: pickerFrameWidth, height: 90)
                        .clipped()
                    Text(".")
                    Picker(selection: $departureTenths, label: EmptyView()) {
                        ForEach(0...9, id: \.self) { ix in
                            Text("\(ix)").tag(ix)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: pickerFrameWidth, height: 90)
                    .clipped()

                    Picker(selection: $departureHundredths, label: EmptyView()) {
                        ForEach(0...9, id: \.self) { ix in
                            Text("\(ix)").tag(ix)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: pickerFrameWidth, height: 90)
                    .clipped()
                }
                Spacer()

                Text("$")
                Picker(selection: $destinationDollars, label: EmptyView()) {
                    ForEach(0...9, id: \.self) { ix in
                        Text("\(ix)").tag(ix)
                    }
                }.pickerStyle(WheelPickerStyle())
                    .frame(width: pickerFrameWidth, height: 90)
                    .clipped()
                Text(".")
                Picker(selection: $destinationTenths, label: EmptyView()) {
                    ForEach(0...9, id: \.self) { ix in
                        Text("\(ix)").tag(ix)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: pickerFrameWidth, height: 90)
                .clipped()

                Picker(selection: $destinationHundredths, label: EmptyView()) {
                    ForEach(0...9, id: \.self) { ix in
                        Text("\(ix)").tag(ix)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: pickerFrameWidth, height: 90)
                .clipped()

                Spacer()
            }.padding(.top, 40)


            Spacer()



            VStack{
                Text("\(fuelPlans[lowestFuelPlan])")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .frame(width:220, height: 100)



                Text("\(lowestFuelPlanPrice)")
                Text("No Tankering: $\(legFuelCost) (\(returnGals, specifier: "%.1f") g + \(assessedRampFee, specifier: "%.1f"))")
                Text("Buy Waiver Fuel: $\(waiverFuelCost) (\(returnGals - waiverGals, specifier: "%.1f") g + \(waiverGals, specifier: "%.1f") g)")
                Text("Tankering Cost: $\(roundTripFuelCost) (\(returnGals, specifier: "%.1f") gals + $\(assessedRampFee, specifier: "%.1f"))")
            }

            Spacer()

            Picker("Ramp Fee", selection: $rampFeePicker) {
                ForEach(0..<rampFeePickers.count) {
                    Text("\(self.rampFeePickers[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 60)


            if rampFeePicker == 0 {
                HStack {

                    Text("Duration")
                    Slider(value: $duration, in: 2...9, step: 0.25)
                    Text("\(duration, specifier: "%.2f") hrs")
                }.padding(.horizontal)
                    .frame(height: 140)


            } else if rampFeePicker == 1 {
                VStack {
                //    Spacer()
                    RampFeeSlider(rampFee: $rampFee, label: "Ramp Fee")

                    HStack {
                        Text("Gals to Waive")
                        Slider(value: $waiverGals, in: 5...1000, step: 5.0)
                        Text("\(Int(waiverGals)) gals")
                    }

                    HStack {
                        Text("Next Leg Fuel")
                        Slider(value: $returnFuelPounds, in: 2000...30000, step: 200.0)
                        Text("\(Int(returnFuelPounds)) lbs")
                    }
                }                    .frame(height: 140)



            }


        }.padding()
    }
}

struct TankerCalculator_Previews: PreviewProvider {
    static var previews: some View {
        TankerCalculator()
    }
}
