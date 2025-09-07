import SwiftUI

// MARK: - Cache
class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}

// MARK: - Loader
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL?

    init(url: URL?) {
        self.url = url
        load()
    }

    func load() {
        guard let url = url else { return }

        // 1. Check cache
        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
            DispatchQueue.main.async { [weak self] in
                self?.image = cached
            }
            return
        }

        // 2. Download
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let uiImage = UIImage(data: data) else { return }

            // Save to cache
            ImageCache.shared.setObject(uiImage, forKey: url as NSURL)

            DispatchQueue.main.async { [weak self] in
                self?.image = uiImage
            }
        }.resume()
    }
}

// MARK: - CachedImage View
struct CachedImage<Content: View, Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let content: (Image) -> Content
    private let placeholder: Placeholder

    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.content = content
        self.placeholder = placeholder()
    }

    var body: some View {
        Group {
            if let uiImage = loader.image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder
            }
        }
    }
}

