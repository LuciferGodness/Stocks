import UIKit
import Combine

protocol ImageServiceProtocol {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

class ImageService: ImageServiceProtocol {
    private let cache = NSCache<NSURL, UIImage>()
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return Just(cachedImage).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in
                return UIImage(data: data)
            }
            .catch { error in
                return Just(nil)
            }
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image = image else { return }
                self?.cache.setObject(image, forKey: url as NSURL)
            })
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
