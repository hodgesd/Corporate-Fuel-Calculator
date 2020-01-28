//
//  UpliftCalculator.swift
//  Corporate Fuel Calculator
//
//  Created by Derrick Hodges on 12/14/19.
//  Copyright © 2019 Derrick Hodges. All rights reserved.
//

import SwiftUI

struct UpliftCalculator: View {
    @State private var legFuel: Int = 10000
    @State private var leftTank: Int = 2500
    @State private var rightTank: Int = 2500
    @State private var standardFuelLoad = 0
    @State private var rampFuelPicker = 0
    @State private var tankGuage = 3
    @State private var tankGuage2 = 10
    @State private var useFuelPicker = false

    @State private var onesDigit: Int = 0
    @State private var tensDigit: Int = 0
    @State private var hundredsDigit: Int = 0
    @State private var thousandsDigit: Int = 3
    @State private var tenThousandsDigit: Int = 1

    @State private var onesDigitOn: Int = 0
    @State private var tensDigitOn: Int = 0
    @State private var hundredsDigitOn: Int = 0
    @State private var thousandsDigitOn: Int = 5
    @State private var tenThousandsDigitOn: Int = 0
    
    let standardFuelLoads = [10, 14, 18, 22, 26]
    let tankIndex = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    let rampFuelPickers = ["Manual", "Standard"]
    private var uploadGals: Int {
        var total = 0.0
        if rampFuelPicker == 0 {
            // Manual
            total = Double(tenThousandsDigit*10000 + thousandsDigit*1000 + hundredsDigit*100) - Double (fuelOnboardWeight)
        } else if rampFuelPicker == 1 {
            // Standard
            total = Double(standardFuelLoads[standardFuelLoad]*1000 - fuelOnboardWeight)
        } else {
            total = Double (29500 - fuelOnboardWeight)
        }
        return Int(total / 6.7)
    }
    private var displayWeight: Int {
        if rampFuelPicker == 0 {
            return (tenThousandsDigit*10000 + thousandsDigit*1000 + hundredsDigit*100)
        } else if rampFuelPicker == 1 {
            return standardFuelLoads[standardFuelLoad]*1000
        } else {
            return 29500
        }
    }


    private var fuelOnboardWeight: Int {
        return (tenThousandsDigitOn*10000 + thousandsDigitOn*1000 + hundredsDigitOn*100)
    }
/*
    struct FuelPickerView: View {

        @State private var onesDigit: Int = 0
        @State private var tensDigit: Int = 0
        @State private var hundredsDigit: Int = 0
        @State private var thousandsDigit: Int = 3
        @State private var tenThousandsDigit: Int = 1

        var body: some View {
            let pickerWidth = CGFloat(20)
            let totalFuel: Int = tenThousandsDigit*10000 + thousandsDigit*1000 + hundredsDigit*100

            return VStack{
                //       Spacer()

                HStack {

                    Picker(selection: $tenThousandsDigit, label: EmptyView()) {
                        ForEach((0...3), id: \.self) { ix in
                            Text("\(ix)").tag(ix)
                        }
                    }.frame(width: pickerWidth)
                        .clipped()

                    Picker(selection: $thousandsDigit, label: EmptyView()) {
                        ForEach((0...9), id: \.self) { ix in
                            Text("\(ix)").tag(ix)
                        }
                    }.frame(width: pickerWidth)
                        .clipped()

                    Picker(selection: $hundredsDigit, label: EmptyView()) {
                        ForEach((0...9), id: \.self) { ix in
                            Text("\(ix)").tag(ix)
                        }
                    }.frame(width: pickerWidth)
                        .clipped()

                    Picker(selection: $tensDigit, label: EmptyView()) {
                        ForEach((0...0), id: \.self) { ix in
                            Text("\(ix)").tag(ix)
                        }
                    }.frame(width: pickerWidth)
                        .clipped()

                    Picker(selection: $onesDigit, label: EmptyView()) {
                        ForEach((0...0), id: \.self) { ix in
                            Text("\(ix)").tag(ix)
                        }
                    }.frame(width: pickerWidth)
                        .clipped()

                    //                Text("Pounds")


                    //            Picker(selection: $tenCentsDigit, label: EmptyView()) {
                    //                ForEach((0...9), id: \.self) { ix in
                    //                    Text("\(ix)").tag(ix)
                    //                }
                    //            }.frame(width: pickerWidth)
                    //            .clipped()
                    //
                    //            Picker(selection: $centsDigit, label: EmptyView()) {
                    //                ForEach((0...9), id: \.self) { ix in
                    //                    Text("\(ix)").tag(ix)
                    //                }
                    //            }.frame(width: pickerWidth)
                    //            .clipped()
                }
                Spacer()
                Text("\(totalFuel) lbs").font(.title)
                Text("\(Int(Double (totalFuel)/6.7)) gals")
                Text("\(Int(Double (totalFuel)/3.79)) liters")
            }.padding(.bottom)
        }
    }
*/


    fileprivate func rampWheel2() -> some View {
        return Picker("Ramp Picker", selection: $tankGuage2){
            ForEach((6...30), id:\.self) {
                Text("\($0*1000) lbs")
            }
        }.pickerStyle(WheelPickerStyle())
    }

    var body: some View {
        NavigationView{
            Form {
                Section (header: Text("Enter or select desired ramp fuel in lbs").font(.footnote)) {

                    HStack{

                        Text("Ramp Fuel")
                            .fontWeight(.semibold)

                        // Fuel Input Picker
                        Picker("Ramp Fuel2", selection: $rampFuelPicker){
                            ForEach(0 ..< rampFuelPickers.count) {
                                Text("\(self.rampFuelPickers[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.leading, 90)
                        //       Spacer()
                    }

                    VStack (alignment: .center){
                        if rampFuelPicker == 0 {
                            //Manual Entry
//                            HStack{
//                                Spacer()
//                                // Keyboard Ramp Fuel Entry
//                                //                        TextField("Enter Ramp Fuel", value: $legFuel, formatter: NumberFormatter())
//                                //                            .padding(.horizontal, 10)
//                                //                            .frame( width: 70.0)
//                                //                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
//
////                                Text ("\(tenThousandsDigit*10000 + thousandsDigit*1000 + hundredsDigit*100)")
////                                    //                        .padding(.horizontal, 10)
////                                    .frame( width: 70.0)
////                                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
////                                // Wheel picker fuel entry
//                                //                        .frame(width: 20)
//                                //                                         .clipped()
//
//                                Spacer()
//                                //  rampWheel2()
//
//                            }
                            HStack {
                                Spacer()
                                Picker(selection: $tenThousandsDigit, label: EmptyView()) {
                                    ForEach((0...3), id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }.pickerStyle(WheelPickerStyle()).frame(width: 20)
                                    .clipped()
                                Picker(selection: $thousandsDigit, label: EmptyView()) {
                                    ForEach((0...9), id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20)
                                .clipped()

                                Picker(selection: $hundredsDigit, label: EmptyView()) {
                                    ForEach((0...9), id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20)
                                .clipped()

                                Picker(selection: $tensDigit, label: EmptyView()) {
                                    ForEach((0...0), id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20)
                                .clipped()

                                Picker(selection: $onesDigit, label: EmptyView()) {
                                    ForEach((0...0), id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20)
                                .clipped()
                                Text (" pounds").font(.body)
                                Spacer()
                            }
                            .frame(maxHeight: 90)
                            .clipped()

                        } else if rampFuelPicker == 1{
                            // Standard
                            Picker("Fuel Load", selection: $standardFuelLoad) {
                                ForEach(0 ..< standardFuelLoads.count) {
                                    Text("\(self.standardFuelLoads[$0])K")
                                }
                            }                        .frame(height: 90)
                            .pickerStyle(SegmentedPickerStyle())

                        }
                        else {
                            Text("AFM Limit: 29,500 lbs")
                                .frame(height: 90)
                                .font(.title)
                        }
                    }
                }

                Section (header: Text("Enter the current fuel load in lbs")){
                    Text("Fuel Onboard")
                        .fontWeight(.semibold)

                    HStack {
                        Spacer()
                        Picker(selection: $tenThousandsDigitOn, label: EmptyView()) {
                            ForEach((0...3), id: \.self) { ix in
                                Text("\(ix)").tag(ix)
                            }
                        }.pickerStyle(WheelPickerStyle()).frame(width: 20)
                            .clipped()
                        Picker(selection: $thousandsDigitOn, label: EmptyView()) {
                            ForEach((0...9), id: \.self) { ix in
                                Text("\(ix)").tag(ix)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 20)
                        .clipped()

                        Picker(selection: $hundredsDigitOn, label: EmptyView()) {
                            ForEach((0...9), id: \.self) { ix in
                                Text("\(ix)").tag(ix)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 20)
                        .clipped()

                        Picker(selection: $tensDigitOn, label: EmptyView()) {
                            ForEach((0...0), id: \.self) { ix in
                                Text("\(ix)").tag(ix)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 20)
                        .clipped()

                        Picker(selection: $onesDigitOn, label: EmptyView()) {
                            ForEach((0...0), id: \.self) { ix in
                                Text("\(ix)").tag(ix)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 20)
                        .clipped()
                        Text (" pounds").font(.body)
                        Spacer()
                    }
                    .frame(maxHeight: 100)
                    .clipped()
                }

                    Section (header: Text("Calculation results")     .fontWeight(.semibold)) {
                        HStack{
                            if uploadGals <= 0 {
                                Text ("No uplift required. Fuel onboard exceeds ramp fuel.")
                                    .font(.title)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20.0)
                            } else {


                                Text("Upload \(uploadGals) gallons for a ramp fuel of \(displayWeight) lbs.")
                                    .font(.title)
                                    .foregroundColor(Color.green)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20.0)
                            }
                        }
                    }
                }
            }.navigationBarTitle("Uplift Calculator")
        }
    }


struct UpliftCalculator_Previews: PreviewProvider {
    static var previews: some View {
        UpliftCalculator()
    }
}
