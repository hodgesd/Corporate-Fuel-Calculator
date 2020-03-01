import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            UpliftCalculator()
                .tabItem {
                    Image(systemName: "gauge.badge.plus")
                    Text("Uplift")
            }
            TankerCalculator()
                .tabItem {
                    Image(systemName: "gauge.badge.plus")
                    Text("Tankering")
            }
            FuelConverter()
                .tabItem {
                    Image(systemName: "crop.rotate")
                    Text("Converter")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
