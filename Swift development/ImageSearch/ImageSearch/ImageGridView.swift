import SwiftUI

struct ImageGridView: View {
    let images: [UnsplashImage] // Change to let instead of Binding

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 10) {
            ForEach(images) { image in
                AsyncImage(url: URL(string: image.urls.small)) { phase in
                    switch phase {
                    case .success(let img):
                        img
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .padding()
                            .onTapGesture {
                                // Handle image tap
                                print("Tapped on image: \(image.id)")
                            }
                    case .failure:
                        Color.gray // Placeholder for failed image load
                    case .empty:
                        ProgressView()
                    @unknown default:
                        Color.clear
                    }
                }
            }
        }
    }
}
