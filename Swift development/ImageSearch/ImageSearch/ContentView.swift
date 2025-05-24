import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var images: [UnsplashImage] = []
    @State private var isLoading = false
    @State private var page = 1
    @State private var isLastPage = false

    var body: some View {
        NavigationView {
            VStack {
                headerView
                SearchBar(text: $searchText, onSearch: fetchImages)
                    .padding(.horizontal)

                ScrollView {
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
                    .padding(.horizontal)

                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                            .padding()
                    }
                }
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        if !isLoading && !isLastPage && (geometry.frame(in: .global).maxY < UIScreen.main.bounds.height) {
                            fetchImages()
                        }
                    }
                })
            }
            .navigationBarHidden(true)
        }
    }

    private var headerView: some View {
        HStack {
            Text("Image Finder")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(15)
        .shadow(radius: 5)
    }

    func fetchImages() {
        guard !searchText.isEmpty, !isLoading else { return }
        isLoading = true

        let urlString = "https://api.unsplash.com/search/photos?query=\(searchText)&page=\(page)&client_id=\(ImageService.accessKey)"
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(UnsplashResponse.self, from: data) {
                    DispatchQueue.main.async {
                        if decodedResponse.results.isEmpty {
                            isLastPage = true
                        } else {
                            images.append(contentsOf: decodedResponse.results)
                            page += 1
                        }
                        isLoading = false;
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                isLoading = false;
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
