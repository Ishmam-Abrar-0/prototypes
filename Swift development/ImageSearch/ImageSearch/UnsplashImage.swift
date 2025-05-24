import Foundation

struct UnsplashImage: Codable, Identifiable {
    let id: String
    let urls: Urls

    struct Urls: Codable {
        let small: String
    }
}

struct UnsplashResponse: Codable {
    let results: [UnsplashImage]
}
