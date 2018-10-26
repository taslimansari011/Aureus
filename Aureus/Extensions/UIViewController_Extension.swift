

import UIKit

// MARK: - UIViewController
extension UIViewController {
    //Storyboard Identifier
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    //Get ViewController Instance
    class func instanceFromStoryboard<T: UIViewController>(storyBoardName: String = Storyboard.main.rawValue, type: T.Type) -> T {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: self.storyboardIdentifier) as! T
        return controller
    }
    
}

