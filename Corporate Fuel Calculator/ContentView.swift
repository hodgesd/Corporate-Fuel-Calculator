import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            UpliftCalculator()
                .tabItem {
                    Image(systemName: "gauge.badge.plus")
                    Text("Uplift Calculator")
            }
            FuelConverter()
                .tabItem {
                    Image(systemName: "crop.rotate")
                    Text("Fuel Converter")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
