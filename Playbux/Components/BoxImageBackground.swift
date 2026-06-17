import SwiftUI
import Combine
import ImageIO
import UniformTypeIdentifiers
import CryptoKit
import SwiftData

/// Displays the cached box image for a session, or a neutral placeholder when none exists.
/// Image *generation* lives in the session setup flow — see `CreateSessionView`.
struct BoxImageBackground: View {

    @State private var generatedImage: CGImage?
    let session: Session

    var body: some View {
        Group {
            if let generatedImage {
                Image(generatedImage, scale: 1.0, label: Text(session.name))
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(.gray)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .task(id: session.persistentModelID) {
            generatedImage = BoxImageCache.image(for: session)
        }
        .onReceive(NotificationCenter.default.publisher(for: .boxImageDidChange)) { notification in
            // Reload only when the changed image belongs to this session.
            guard notification.object as? PersistentIdentifier == session.persistentModelID else { return }
            generatedImage = BoxImageCache.image(for: session)
        }
    }
}

/// On-disk cache for generated box images so they survive app restarts.
enum BoxImageCache {

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

        // Let any visible views (e.g. the session grid) know to reload this session's image.
        NotificationCenter.default.post(name: .boxImageDidChange, object: session.persistentModelID)
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

extension Notification.Name {
    /// Posted with the session's `PersistentIdentifier` as `object` whenever its box image is generated or replaced.
    static let boxImageDidChange = Notification.Name("BoxImageDidChange")
}
