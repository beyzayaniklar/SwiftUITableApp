import SwiftUI
import MapKit

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let address: String
    let note: String
    let desc: String
    let imageName: String
    let lat: Double
    let long: Double
    let category: String
}

let data = [
    Item(
        name: "Doxa Coffee Roasters",
        location: "Near The Quad",
        address: "700 Moore St, San Marcos, TX",
        note: "Located inside Food Trucks",
        desc: "A quick grab-and-go coffee stop near campus, located in the food truck area by the Quad. Perfect when you want something fast before class without leaving campus.",
        imageName: "doxa",
        lat: 29.8897,
        long: -97.9414,
        category: "Coffee"
    ),
    Item(
        name: "Dunkin'",
        location: "West Campus",
        address: "100 W Woods St, San Marcos, TX",
        note: "Located inside Jones Dining Center",
        desc: "A classic pick for iced coffee and donuts inside Jones Dining Center. Great for a quick treat or an easy caffeine boost on the west side of campus.",
        imageName: "dunkin",
        lat: 29.8892,
        long: -97.9443,
        category: "Chain"
    ),
    Item(
        name: "LBJ Starbucks",
        location: "Student Center",
        address: "301 Student Center Dr, San Marcos, TX",
        note: "Located inside LBJ Student Center",
        desc: "Right in the LBJ Student Center, this Starbucks is an easy stop between meetings, club events, and classes. A reliable place to recharge while you’re in the middle of campus life.",
        imageName: "lbj-starbucks",
        lat: 29.8885,
        long: -97.9440,
        category: "Study Spot"
    ),
    Item(
        name: "Alkek Starbucks",
        location: "Library",
        address: "100 West Woods St, San Marcos, TX",
        note: "Located inside Alkek Library",
        desc: "Inside Alkek Library, this Starbucks is built for study days. Ideal for long reading sessions, group projects, and taking a quick coffee break without losing your seat.",
        imageName: "alkek-starbucks",
        lat: 29.8890,
        long: -97.9435,
        category: "Study Spot"
    ),
    Item(
        name: "McCoy Cafe",
        location: "McCoy College",
        address: "601 University Dr, San Marcos, TX",
        note: "Located inside McCoy College of Business",
        desc: "Located inside McCoy College of Business, this cafe is convenient for business students and anyone nearby. A solid spot to grab a drink before a lecture, presentation, or study session.",
        imageName: "mccoy-cafe",
        lat: 29.8901,
        long: -97.9438,
        category: "Cafe"
    )
]

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.8897, longitude: -97.9438),
        span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
    )
    
    // Filter by location type
    let locations = ["All"] + Array(Set(data.map { $0.location })).sorted()
    @State private var selectedLocation = "All"
    
    var filteredData: [Item] {
        if selectedLocation == "All" {
            return data
        } else {
            return data.filter { $0.location == selectedLocation }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Location", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location).tag(location)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                
                List(filteredData, id: \.name) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        HStack {
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.category)
                                    .font(.subheadline)
                                Text(item.location)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                
                Map(coordinateRegion: $region, annotationItems: filteredData) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                            .overlay(
                                Text(item.name)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .offset(y: 25)
                            )
                    }
                }
                .frame(height: 300)
                .padding(.bottom, -30)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("TXST Coffee Stops")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct DetailView: View {
    @State private var region: MKCoordinateRegion
    let item: Item
    
    init(item: Item) {
        self.item = item
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long),
            span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        ))
    }
    
    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Location: \(item.location)")
                Text("Category: \(item.category)")
                Text("Address: \(item.address)")
                Text("Note: \(item.note)")
            }
            .font(.subheadline)
            .padding(.horizontal)
            .padding(.top, 10)
            
            Text("Description")
                .font(.headline)
                .padding(.top, 10)
                .padding(.horizontal)
            
            Text(item.desc)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Map(coordinateRegion: $region, annotationItems: [item]) { item in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                        .overlay(
                            Text(item.name)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .fixedSize(horizontal: true, vertical: false)
                                .offset(y: 25)
                        )
                }
            }
            .frame(height: 300)
            .padding(.top, 10)
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
