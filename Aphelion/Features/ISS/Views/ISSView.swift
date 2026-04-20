import MapKit
import SwiftUI

struct ISSView: View {
    @State private var viewModel = ISSViewModel()
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        var issCoordinate: CLLocationCoordinate2D? {
            guard let position = viewModel.issLocation?.issPosition,
                  let lat = Double(position.latitude),
                  let long = Double(position.longitude) else {
                return nil
            }
            
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        ZStack (alignment: .bottom) {
            Map(position: $cameraPosition) {
                if let coordinate = issCoordinate {
                    Annotation("МКС", coordinate: coordinate) {
                        Image("iss_icon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            
                    }
                }
            }
            .onChange(of: viewModel.issLocation) { _, newLocation in
                if let coordinate = issCoordinate {
                    withAnimation {
                        cameraPosition = .region(MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
                        ))
                    }
                }
            }
            
            if let location = viewModel.issLocation {
                VStack(spacing: 8) {
                    Text("Международная космическая станция")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 24) {
                        VStack {
                            Text("Широта")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text(String(format: "%.4f", Double(location.issPosition.latitude) ?? 0))
                                .font(.subheadline)
                                .foregroundStyle(.white)
                        }
                        VStack {
                            Text("Долгота")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text(location.issPosition.longitude)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .padding()
            }
            
        }
        .onAppear {viewModel.startTracking()}
        .onDisappear {viewModel.stopTracking()}
        .preferredColorScheme(.dark)
    }
}
