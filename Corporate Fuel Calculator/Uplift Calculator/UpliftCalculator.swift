//
//  UpliftCalculator.swift
//  Corporate Fuel Calculator
//
//  Created by Derrick Hodges on 12/14/19.
//  Copyright © 2019 Derrick Hodges. All rights reserved.
//

import SwiftUI

struct UpliftCalculator: View {
    @State private var standardFuelLoad = 0
    @State private var rampFuelPicker = 0

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
    let rampFuelPickers = ["Manual", "Standard"]

    private var uploadGals: Int {
        var total = 0.0
        if rampFuelPicker == 0 {
            // Manual
            total = Double(tenThousandsDigit * 10000 + thousandsDigit * 1000 + hundredsDigit * 100) - Double(fuelOnboardWeight)
        } else if rampFuelPicker == 1 {
            // Standard
            total = Double(standardFuelLoads[standardFuelLoad] * 1000 - fuelOnboardWeight)
        } else {
            total = Double(29500 - fuelOnboardWeight)
        }
        return Int(total / 6.7)
    }

    private var displayWeight: Int {
        if rampFuelPicker == 0 {
            return fuelRampWeight
        } else if rampFuelPicker == 1 {
            return standardFuelLoads[standardFuelLoad] * 1000
        } else {
            return 29500
        }
    }

    private var fuelRampWeight: Int {
        return (tenThousandsDigit * 10000 + thousandsDigit * 1000 + hundredsDigit * 100)
    }

    private var fuelOnboardWeight: Int {
        return (tenThousandsDigitOn * 10000 + thousandsDigitOn * 1000 + hundredsDigitOn * 100)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter desired ramp fuel in pounds").font(.footnote)) {
                    HStack {
                        Text("Ramp Fuel")
                            .fontWeight(.semibold)

                        // Fuel Input Picker
                        Picker("Ramp Fuel2", selection: $rampFuelPicker.animation()) {
                            ForEach(0..<rampFuelPickers.count) {
                                Text("\(self.rampFuelPickers[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.leading, 90)
                    }

                    VStack(alignment: .center) {
                        if rampFuelPicker == 0 {
                            HStack {
                                Spacer()
                                Picker(selection: $tenThousandsDigit, label: EmptyView()) {
                                    ForEach(0...3, id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }.pickerStyle(WheelPickerStyle()).frame(width: 20)
                                    .clipped()
                                Picker(selection: $thousandsDigit, label: EmptyView()) {
                                    ForEach(0...9, id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20)
                                .clipped()

                                Picker(selection: $hundredsDigit, label: EmptyView()) {
                                    ForEach(0...9, id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20)
                                .clipped()

                                Picker(selection: $tensDigit, label: EmptyView()) {
                                    ForEach(0...0, id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20)
                                .clipped()

                                Picker(selection: $onesDigit, label: EmptyView()) {
                                    ForEach(0...0, id: \.self) { ix in
                                        Text("\(ix)").tag(ix)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 20)
                                .clipped()
                                Text(" pounds").font(.body)
                                Spacer()
                            }
                            .frame(maxHeight: 90)
                            .clipped()

                        } else if rampFuelPicker == 1 {
                            // Standard
                            Picker("Fuel Load", selection: $standardFuelLoad) {
                                ForEach(0..<standardFuelLoads.count) {
                                    Text("\(self.standardFuelLoads[$0])K")
                                }
                            }.frame(height: 90)
                                .pickerStyle(SegmentedPickerStyle())
                        } else {
                            Text("AFM Limit: 29,500 lbs")
                                .frame(height: 90)
                                .font(.title)
                        }
                    }
                }

                Section(header: Text("Enter the current fuel load in pounds")) {
                    Text("Fuel Onboard")
                        .fontWeight(.semibold)

                    HStack {
                        Spacer()
                        Picker(selection: $tenThousandsDigitOn, label: EmptyView()) {
                            ForEach(0...3, id: \.self) { ix in
                                Text("\(ix)").tag(ix)
                            }
                        }.pickerStyle(WheelPickerStyle()).frame(width: 20)
                            .clipped()
                        Picker(selection: $thousandsDigitOn, label: EmptyView()) {
                            ForEach(0...9, id: \.self) { ix in
                                Text("\(ix)").tag(ix)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 20)
                        .clipped()

                        Picker(selection: $hundredsDigitOn, label: EmptyView()) {
                            ForEach(0...9, id: \.self) { ix in
                                Text("\(ix)").tag(ix)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 20)
                        .clipped()

                        Picker(selection: $tensDigitOn, label: EmptyView()) {
                            ForEach(0...0, id: \.self) { ix in
                                Text("\(ix)").tag(ix)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 20)
                        .clipped()

                        Picker(selection: $onesDigitOn, label: EmptyView()) {
                            ForEach(0...0, id: \.self) { ix in
                                Text("\(ix)").tag(ix)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 20)
                        .clipped()
                        Text(" pounds").font(.body)
                        Spacer()
                    }
                    .frame(maxHeight: 100)
                    .clipped()
                }

                Section(header: Text("Purchase plan to achieve desired ramp fuel")) {
                    Text("Results")
                        .fontWeight(.semibold)
                    HStack {
                        if uploadGals <= 0 {
                            Text("No uplift required. Fuel onboard exceeds ramp fuel.")
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
            }.navigationBarTitle("Uplift Calculator")
        }
    }
}

struct UpliftCalculator_Previews: PreviewProvider {
    static var previews: some View {
        UpliftCalculator()
    }
}
