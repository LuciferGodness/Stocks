import UIKit

enum AppImages: String {
    case favourite
    case unfavourite
    
    var image: UIImage? {
        rawValue.image
    }
}

extension String {
    var image: UIImage? {
        let image = UIImage(named: self)
        
        return image
    }
}
