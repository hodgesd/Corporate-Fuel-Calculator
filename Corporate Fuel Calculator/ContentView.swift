import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
           FuelConverter()
             .tabItem {
                Image(systemName: "crop.rotate")
                Text("Density Converter")
              }

           UpliftCalculator()
             .tabItem {
                Image(systemName: "gauge.badge.plus")
                Text("Uplift Calculator")
              }
        }
    }
}

struct FuelConverter: View {
    @State private var pounds: Double = 5000
    @State private var computeCost: Bool = false
    @State private var pricePerGal: Double = 3.4
   
    private var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        // allow no currency symbol, extra digits, etc
        f.isLenient = true
        f.numberStyle = .currency
        return f
    }()
    
    
    var body: some View {
        NavigationView {
            Form{
                Section{
                    
                    VStack {
                        HStack{
                            
                            //          Text("Price Per Gallon")
                            //            .font(.body)
                            
                            Toggle (isOn: $computeCost) {
                                Text("Show Cost")
                            }.frame(width: 130.0)
                                .padding(.trailing, 100)
                            Spacer()
                            Spacer()
                            if computeCost == true{
                                HStack{
                                    Text("Price/Gal")
                                    TextField("Price/Gal", value: $pricePerGal,formatter: currencyFormatter)
                                }
                            }
                            
                                
                            }.font(.footnote)
                        }
                        //        Divider()
                    }
         //       Spacer()
                Text("\(Int (pounds)) Pounds")
                Slider(value: $pounds, in: 0...30000, step: 500)
                Text("\(Int(pounds / 6.7)) Gallons")
                if computeCost == true{
                    Text("at $\(pounds*pricePerGal/6.7)")
                }
            }.font(.title)
            .navigationBarTitle("Density Converter")
        }
    }
}

struct UpliftCalculator: View {
    @State private var legFuel: Int = 10000
    @State private var leftTank: Int = 2500
    @State private var rightTank: Int = 2500
    @State private var standardFuelLoad = 0
    @State private var rampFuelPicker = 0
    @State private var tankGuage = 3
    @State private var tankGuage2 = 10
    @State private var useFuelPicker = false
    let standardFuelLoads = [10, 14, 18, 22, 26]
    let tankIndex = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    let rampFuelPickers = ["Manual", "Standard"]
    private var uploadGals: Int {
        var total = 0.0
        if rampFuelPicker == 0 {
            
            total = Double(legFuel - leftTank - rightTank)
        } else {
            
            total = Double(standardFuelLoads[standardFuelLoad]*1000 - leftTank - rightTank)
        }
        
        return Int(total / 6.7)
    }
    private var displayWeight: Int {
        if rampFuelPicker == 0 {
            return legFuel
        } else {
            return standardFuelLoads[standardFuelLoad]*1000
        }
    }
    fileprivate func rampWheel() -> some View {
        return Picker("Ramp Picker", selection: $tankGuage){
            ForEach(0 ..< tankIndex.count) {
                Text("\(self.tankIndex[$0]*1000)lbs")
            }
        }.pickerStyle(WheelPickerStyle())
    }

    fileprivate func rampWheel2() -> some View {
        return Picker("Ramp Picker", selection: $tankGuage2){
            ForEach((6...30), id:\.self) {
                Text("\($0*1000) lbs")
            }
        }.pickerStyle(WheelPickerStyle())
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section (header: Text("Enter or select desired ramp fuel in lbs").font(.footnote))
                {
                    HStack{
                
                    Text("Ramp Fuel")
                    .fontWeight(.semibold)
                    // Fuel Input Picker
                    Picker("Ramp Fuel2", selection: $rampFuelPicker){
                        ForEach(0 ..< rampFuelPickers.count) {
                            Text("\(self.rampFuelPickers[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.leading, 150)
                    //       Spacer()
                    }
                        if rampFuelPicker == 0 {
                        //Manual Entry
                        HStack{
                            Spacer()
                            TextField("Enter Ramp Fuel", value: $legFuel, formatter: NumberFormatter())
                                .padding(.horizontal, 10)
                                .frame( width: 70.0)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            Spacer()
              //             rampWheel2()
 
                            }
                    } else {
                        // Standard
                        Picker("Fuel Load", selection: $standardFuelLoad) {
                            ForEach(0 ..< standardFuelLoads.count) {
                                Text("\(self.standardFuelLoads[$0])K")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
               
                
                
                Section (header: Text("Enter the current fuel load in lbs")){
                    Text("Fuel Onboard")
                        .fontWeight(.semibold)
                    HStack{
                        Spacer()
                        Text("Left:")
                        TextField("Enter Left Tank Fuel", value: $leftTank, formatter: NumberFormatter())
                            .frame(width: 90.0)
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        Text("Right:")
                        TextField("Enter Right Tank Fuel", value: $rightTank, formatter: NumberFormatter())
                            .frame(width: 90.0)
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }//.keyboardType(.numberPad)
                }
            
                Section (header: Text("Calculation results")) {
                    Text("Upload \(uploadGals) gallons for a ramp fuel of \(displayWeight) lbs")
                .font(.title)
                .foregroundColor(Color.green)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20.0)
        
                //        }
                
                .font(.title)
                }
            }.navigationBarTitle("Uplift Calculator")
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
