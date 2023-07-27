//
//  Ditto
//
//  Created by Gaurav Rajan on 21/03/21.
//

import UIKit
import Alamofire

extension UIViewController {
    func configureNavTitle() {
        if UIDevice.isPad {
            let attrs = [
                NSAttributedString.Key.font: CustomFont.avenirLtProMedium(size: 28)!
            ]
            self.navigationController!.navigationBar.titleTextAttributes = attrs
        } else {
            let attrs = [
                NSAttributedString.Key.font: CustomFont.avenirLtProMedium(size: 21)!
            ]
            self.navigationController!.navigationBar.titleTextAttributes = attrs
        }
    }
    func root(selectedStoryboard: StoryBoardType, identifier: String ) {
        DispatchQueue.main.async {
            self.navigationController?.viewControllers.removeAll()
            let controller =  selectedStoryboard.storyboard.instantiateViewController(withIdentifier: identifier )
            self.view.window?.rootViewController = controller
        }
    }
    func rootWithDrawer(mainVCStoryboard: StoryBoardType, mainVCIdentifier: String, sideVCStoryboard: StoryBoardType, sideVCIdentifier: String) {
        DispatchQueue.main.async {
            let mainVC = mainVCStoryboard.storyboard.instantiateViewController(withIdentifier: mainVCIdentifier)
            let sideVC = sideVCStoryboard.storyboard.instantiateViewController(withIdentifier: sideVCIdentifier)
            let slideMenuController = SlideMenuController.init(mainViewController: mainVC, rightMenuViewController: sideVC)
            slideMenuController.automaticallyAdjustsScrollViewInsets = true
            slideMenuController.delegate = mainVC as? SlideMenuControllerDelegate
            KAppDelegate.sideMenuVC = slideMenuController
            self.view.window?.rootViewController = slideMenuController
            self.view.window?.makeKeyAndVisible()
        }
    }
    func pushToNext(storyBoard: StoryBoardType, identifier: String, animated: Bool = true, titleStr: String = FormatsString.emptyString) {
        DispatchQueue.main.async {
            let controller = storyBoard.storyboard.instantiateViewController(withIdentifier: identifier)
            controller.title = titleStr
            self.navigationController?.pushViewController(controller, animated: animated)
        }
    }
    func pop() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    func popToRoot() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    func dismissController() {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return (navigation.visibleViewController?.topMostViewController())!
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
    func savePdf(urlString: String, fileName: String, completion: @escaping(_ status: Bool) -> Void) {  // code to download the pdf to local and show on view
        Proxy.shared.showLottie()
        var fileURL: URL!
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            fileURL = documentsURL.appendingPathComponent(fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(urlString, headers: nil, to: destination).response { response in
            Proxy.shared.dismissLottie()
            if response.fileURL != nil {
                if response.fileURL != nil {
                    if let statuscode = response.response?.statusCode {
                        completion(statuscode == 200 ? (response.error == nil) : false)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
}
extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let viewc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(viewc, animated: animated)
        }
    }
    func removeViewController(_ controller: UIViewController.Type) {
            if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
                viewController.removeFromParent()
            }
        }
}
extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return Proxy.shared.keyWindow?.rootViewController?.topMostViewController()
    }
}
