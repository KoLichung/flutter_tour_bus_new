import Foundation
import UIKit

class AppCoordinator{
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "PayView", bundle: nil)
        if let container = storyboard.instantiateViewController(withIdentifier: "PayViewController") as? PayViewController {
            navigationController?.pushViewController(container, animated: false)
        }
    }
}
