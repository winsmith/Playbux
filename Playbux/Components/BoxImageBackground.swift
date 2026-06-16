import SwiftUI
import ImageIO
import ImagePlayground
import UniformTypeIdentifiers
import CryptoKit
import SwiftData

struct BoxImageBackground: View {

    @State var generatedImage: CGImage?
    @State private var isPresentingPlayground = false
    let session: Session

    var prompt: String {
        "'\(session.name)' Board game" // . No Text. The game has these resources: \(session.resourceTypes.map { $0.name + ", " } )"
    }


    var body: some View {
        VStack {
            if let image = generatedImage {
                Image(image, scale: 1.0, label: Text(session.name))
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray)
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Button {
                        isPresentingPlayground = true
                    } label: {
                        Label("Create Image", systemImage: "sparkles")
                    }
                }
            }
        }
        .task(id: session.persistentModelID) {
            generatedImage = BoxImageCache.image(for: session)
        }
        .imagePlaygroundSheet(isPresented: $isPresentingPlayground, concept: prompt) { url in
            guard let image = loadCGImage(from: url) else { return }
            generatedImage = image
            BoxImageCache.store(image, for: session)
        }
    }

    private func loadCGImage(from url: URL) -> CGImage? {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(source, 0, nil)
    }
}

/// On-disk cache for generated box images so they survive app restarts.
private enum BoxImageCache {

    static func image(for session: Session) -> CGImage? {
        let url = fileURL(for: session)
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(source, 0, nil)
    }

    static func store(_ image: CGImage, for session: Session) {
        let url = fileURL(for: session)
        try? FileManager.default.removeItem(at: url)
        guard let destination = CGImageDestinationCreateWithURL(
            url as CFURL,
            UTType.png.identifier as CFString,
            1,
            nil
        ) else { return }
        CGImageDestinationAddImage(destination, image, nil)
        CGImageDestinationFinalize(destination)
    }

    /// A stable, restart-safe filename derived from the session's immutable creation date,
    /// so the image keeps loading across launches even if the session is renamed.
    private static func fileURL(for session: Session) -> URL {
        let identity = String(session.createdAt.timeIntervalSinceReferenceDate)
        let digest = SHA256.hash(data: Data(identity.utf8))
        let filename = digest.map { String(format: "%02x", $0) }.joined()
        return directory.appendingPathComponent(filename).appendingPathExtension("png")
    }

    private static var directory: URL {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let directory = caches.appendingPathComponent("BoxImages", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }
}
