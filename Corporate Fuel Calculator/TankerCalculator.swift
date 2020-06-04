//
//  TankerCalculator.swift
//  Corporate Fuel Calculator
//
//  Created by Derrick Hodges on 2/25/20.
//  Copyright © 2020 Derrick Hodges. All rights reserved.
//

import SwiftUI

struct RampFeeSlider: View {
    @Binding var rampFee: Double
    var label: String
    var body: some View {
        HStack {
            Text("\(label)")
            Slider(value: $rampFee, in: 0...1250, step: 5.0)
            Text("$\(Int(rampFee))")
        }
    }
}

struct DeparturePicker: View {
    @Binding var departureDollars: Int
    @Binding var departureTenths: Int
    @Binding var departureHundredths: Int
    let pickerFrameWidth: CGFloat

    var body: some View {
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
    }
}

struct DestinationPicker: View {
    @Binding var destinationDollars: Int
    @Binding var destinationTenths: Int
    @Binding var destinationHundredths: Int
    let pickerFrameWidth: CGFloat

    var body: some View {
        HStack {
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

    @State private var analysisPickerSelection = 1
    var selectedFuelPrice: Int = 0
    let pickerFrameWidth: CGFloat = 25

    private var resultSubtitleRampFee: String {
        if lowestRampFeeFuelPlan == 0 {

            return "Buy \(Int(returnGals)) gals at departure to save $\(max(waiverFuelCost, roundTripFuelCost) - legFuelCost)"
        } else if lowestRampFeeFuelPlan == 1 {
            return "Buy \(Int(returnGals - waiverGals)) gals on departure and \(Int(waiverGals)) gals at destination to save $\(max(legFuelCost, roundTripFuelCost) - waiverFuelCost)"
        } else {
            return "Buy \(Int(returnGals)) gals at destination to save $\(max(legFuelCost, waiverFuelCost) - roundTripFuelCost)"
        }
    }

    private var capsuleFactor: Double{


     //   print ("scale")
        return (190.0/Double(highestFuelPlanPrice))

    }
    
    private var resultSubtitleNoRampFee: String {
        if lowestNoRampFeeFuelPlan == 0 {
            return "Departure fuel is too expensive to tanker on a \(duration) hr flight"
        } else {
            return "Every gal tankered will save $\(actualRatio / interpolatedBreakevenRatio * departurePPG)"
        }
    }

    private var lowestFuelPlanPrice: Int {
        min(legFuelCost, waiverFuelCost, roundTripFuelCost)
    }

    private var highestFuelPlanPrice: Int {
        max(legFuelCost, waiverFuelCost, roundTripFuelCost)
    }

    private var lowestRampFeeFuelPlan: Int {
        if min(legFuelCost, waiverFuelCost, roundTripFuelCost) == legFuelCost {
            return 0
        } else if min(legFuelCost, waiverFuelCost, roundTripFuelCost) == waiverFuelCost {
            return 1
        } else {
            return 2
        }
    }

    private var lowestNoRampFeeFuelPlan: Int {
        if min(legFuelCost, waiverFuelCost, roundTripFuelCost) == legFuelCost {
            return 0
        } else if min(legFuelCost, waiverFuelCost, roundTripFuelCost) == waiverFuelCost {
            return 1
        } else {
            return 2
        }
    }

    private var fuelTotals:Int {
        if analysisPickerSelection == 0 {
            return legFuelCost
        } else if analysisPickerSelection == 1 {
            return waiverFuelCost
        } else {
            return roundTripFuelCost
        }
    }

    func capsuleHeight(RawHeight:Int) -> Double {
        var newHeight:Double

        newHeight = Double(RawHeight) * capsuleFactor
        return newHeight
    }

    let fuelPlans = ["Buy Leg Fuel", "Buy Waiver Fuel", "Tanker Fuel"]
    let fuelPlanColors = [Color.red, Color.yellow, Color.green]
    lazy var fuelPrices = [legFuelCost, waiverFuelCost, roundTripFuelCost]
    let breakEvenRatios = [1.053, 1.086, 1.123, 1.165, 1.210, 1.260, 1.315, 1.373]



    @State private var rampFeePicker = 1
    let rampFeePickers = ["No Ramp Fee", "Ramp Fee"]

    private var interpolatedBreakevenRatio: Double {
        return breakEvenRatios[Int(trunc(duration)) - 2] + remainderRatio
    }

    private var remainderRatio: Double {
        var base: Int
        var crumbs: Double
        var bigRatio: Double
        var littleRatio: Double

        base = Int(trunc(duration) - 2)
        bigRatio = breakEvenRatios[base + 1]
        littleRatio = breakEvenRatios[base]
        crumbs = (bigRatio - littleRatio) * ((duration - 2.0) - Double(base))

        return crumbs
    }

    private var actualRatio: Double {
        return destinationPPG / departurePPG
    }

    private var noRampFeeFuelPlan: Int {
        if actualRatio > interpolatedBreakevenRatio {
            return 2
        } else {
            return 0
        }
    }

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
        ZStack {
            Color(#colorLiteral(red: 0.5759592553, green: 0.9269064327, blue: 0.9933477044, alpha: 1))
                .edgesIgnoringSafeArea(.all)

            VStack (alignment: .center) {
                HStack {
                    Text("Departure")
                    Spacer()
                    Text("Destination")
                }.padding(.horizontal, 40)

                HStack {
                    DeparturePicker(departureDollars: $departureDollars, departureTenths: $departureTenths, departureHundredths: $departureHundredths, pickerFrameWidth: pickerFrameWidth)
                    Spacer()
                    DestinationPicker(destinationDollars: $destinationDollars, destinationTenths: $destinationTenths, destinationHundredths: $destinationHundredths, pickerFrameWidth: pickerFrameWidth)

                }.padding(.horizontal, 30)

                Spacer()

                VStack {
                    if rampFeePicker == 0 {
                        VStack {
//                        Text("\(fuelPlans[lowestRampFeeFuelPlan])")
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .frame(width: 200, height: 80)
//                        .background(Color .green)
//                        .foregroundColor(.black)

                            ResultBox(result: fuelPlans[noRampFeeFuelPlan], resultBoxColor: fuelPlanColors[noRampFeeFuelPlan], resultSubtitle: resultSubtitleNoRampFee)

                            Text("Lowest: \(lowestFuelPlanPrice), Actual: \(interpolatedBreakevenRatio, specifier: "%.3f"), Base: \(Int(trunc(duration))), RemainderRatio\(remainderRatio, specifier: "%.3f")")
                        }

                    } else if rampFeePicker == 1 {
//                    Text("\(fuelPlans[lowestRampFeeFuelPlan])")
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .frame(width: 200, height: 80)
//                        .background(Color .green)
//                        .foregroundColor(.black)

                        ResultBox(result: fuelPlans[lowestRampFeeFuelPlan], resultBoxColor: fuelPlanColors[lowestRampFeeFuelPlan], resultSubtitle: resultSubtitleRampFee)

                        Text("Lowest: \(lowestFuelPlanPrice), Actual: \(interpolatedBreakevenRatio, specifier: "%.3f"), Base: \(Int(trunc(duration))), RemainderRatio\(remainderRatio, specifier: "%.3f")")
                        Text("CapsuleFactor:\(capsuleFactor))")

                        Text("No Tankering: $\(legFuelCost) (\(returnGals, specifier: "%.1f") g + \(assessedRampFee, specifier: "%.1f"))")
                        Text("Buy Waiver Fuel: $\(waiverFuelCost) (\(returnGals - waiverGals, specifier: "%.1f") g + \(waiverGals, specifier: "%.1f") g)")
                        Text("Tankering Cost: $\(roundTripFuelCost) (\(returnGals, specifier: "%.1f") gals + $\(assessedRampFee, specifier: "%.1f"))")
                    }

                }.foregroundColor(.gray)


                Picker(selection: $analysisPickerSelection, label: Text("")) {
                    Text ("Leg Fuel").tag(0)
                    Text ("Waiver Fuel").tag(1)
                    Text ("Tanker Fuel").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 24)
                Spacer()
                HStack() {
                    Text("$").font(.body)
      //              CapsuleView(title: "Leg", max: capsuleHeight(RawHeight: ),  CGFloat ((capsuleFactor * max(legFuelCost, waiverFuelCost, roundTripFuelCost))), height: CGFloat (Double(lowestFuelPlanPrice) * capsuleFactor))

                    CapsuleView (title: "Total", max: CGFloat(capsuleHeight(RawHeight: highestFuelPlanPrice)), height: CGFloat(capsuleHeight(RawHeight: (fuelTotals))))
                  //  CapsuleView(title: "Total", max: 220, height: 180)
             //       CapsuleView(title: "Waiver")
               //     CapsuleView(title: "Trip")
                    VStack {
                        Text("Total Cost:")
                        Text("$\(fuelTotals)")
                        Text("\(190.0/Double(highestFuelPlanPrice))")
                    }.padding()

                }.padding(.top, 24)
                    .font(.caption)
                Spacer()



                Picker("Ramp Fee", selection: $rampFeePicker) {
                    ForEach(0..<rampFeePickers.count) {
                        Text("\(self.rampFeePickers[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                     .padding(.horizontal, 90)

                if rampFeePicker == 0 {
                    HStack {
                        Text("Duration")
                        Slider(value: $duration, in: 2...8.75, step: 0.25)
                        Text("\(duration, specifier: "%.2f") hrs")
                    }.padding(.horizontal)
                        .frame(height: 140)

                } else if rampFeePicker == 1 {
                    VStack(alignment: .leading) {
                        //    Spacer()
                        RampFeeSlider(rampFee: $rampFee, label: "Ramp Fee")

                        HStack {
                            Text("Waiver Gals")
                            Slider(value: $waiverGals, in: 5...1000, step: 5.0)
                            Text("\(Int(waiverGals)) gals")
                        }

                        HStack {
                            Text("Next Leg Fuel")
                            Slider(value: $returnFuelPounds, in: 2000...30000, step: 200.0)
                            Text("\(Int(returnFuelPounds)) lbs")
                        }
                    }.frame(height: 140)
                }

            }.padding()
        }
    }
}

struct TankerCalculator_Previews: PreviewProvider {
    static var previews: some View {
        TankerCalculator()
    }
}
