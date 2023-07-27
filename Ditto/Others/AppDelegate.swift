//
//  AppDelegate.swift
//  WorkBench
//
//  Created by Namarta on 24/07/19.
//  Copyright © 2019 Namarta. All rights reserved.
//
import  CoreData
import SystemConfiguration
import UIKit
import Swinject
import CoreBluetooth
import Firebase
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var managerBLE: CBCentralManager?
    var window: UIWindow?
    var isBluetoothOn: Bool = false
    var isWifiOn: Bool = false
    var reloadMyLirary: Bool = false
    var isFromUniversalLinking: Bool = false
    var goToMyLibrary: Bool = false
    var goToPatternDesc: Bool = false
    var tailorNovaDID: String = FormatsString.emptyString
    var tailorNovaMID: String = FormatsString.emptyString
    var tailorNovaOrderID: String = FormatsString.emptyString
    var sideMenuVC  = SlideMenuController()
    let keyWindow = UIApplication.shared.connectedScenes.flatMap {($0 as? UIWindowScene)?.windows ?? []}.first {$0.isKeyWindow}
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CommonConst.versionAlertStatusOnLaunch = true
        FirebaseApp.configure()
        #if PROD
        Proxy.shared.saveEnvValues(url: EnvChanges.dittoBaseUrl, id: EnvChanges.siteId, clientKey: EnvChanges.dittoClientKey, server: EnvChanges.dittoServer, siteUrl: EnvChanges.dittoSiteUrl, tokenUrl: EnvChanges.dittoTokenUrl, trackingId: EnvChanges.dittoTrackingId, isProd: true)
        #elseif DEV
        Proxy.shared.saveEnvValues(url: EnvChanges.devBaseUrl, id: EnvChanges.siteId, clientKey: EnvChanges.devClientKey, server: EnvChanges.devServer, siteUrl: EnvChanges.devSiteUrl, tokenUrl: EnvChanges.devTokenUrl, trackingId: EnvChanges.devTrackingId, isProd: false)
        #elseif QA
        Proxy.shared.saveEnvValues(url: EnvChanges.devBaseUrl, id: EnvChanges.siteId, clientKey: EnvChanges.devClientKey, server: EnvChanges.devServer, siteUrl: EnvChanges.devSiteUrl, tokenUrl: EnvChanges.devTokenUrl, trackingId: EnvChanges.devTrackingId, isProd: false)
        #elseif DEV11
        Proxy.shared.saveEnvValues(url: EnvChanges.dev11BaseUrl, id: EnvChanges.dev11siteId, clientKey: EnvChanges.dev11ClientKey, server: EnvChanges.dev11Server, siteUrl: EnvChanges.dev11SiteUrl, tokenUrl: EnvChanges.dev11TokenUrl, trackingId: EnvChanges.devTrackingId, isProd: false)
        #endif
        if !CommonConst.userDefault.bool(forKey: CommonConst.hasLaunchedOnce) {
            CommonConst.userDefault.set(true, forKey: CommonConst.hasLaunchedOnce)
            CommonConst.showCoachMarkCheck = true
            CommonConst.showCThumbnailAnimationCheck = true
            CommonConst.coackmarkCompleteStatusCheck = true
            CommonConst.animationCompleteStatusCheck = true
            CommonConst.userDefault.synchronize()
        }
        MainContainer.sharedContainer.setupDefaultContainers()
        do {
            try Network.reachability = Reachability()
        } catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?: break
            case let .failedToInitializeWith(_)?: break
            case .failedToSetCallout?: break
            case .failedToSetDispatchQueue?: break
            case .none: break
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusManager), name: .flagsChanged, object: nil)
        let color = UIColor.black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .normal)
        if !CommonConst.isInstructionSavedCheck {
            GetStartedViewController().objGetStartedViewModel.getContentForGetStartedAndTutorials { _ in
                CommonConst.isInstructionSavedCheck = true
            }
        }
        UITextViewWorkaround.executeWorkaround()
        return true
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else { return false }
        self.isFromUniversalLinking = true
        if let userID = self.getQueryStringParameter(url: "\(url)", param: "userId") {
            let savedCustomerID = CommonConst.customerNoText
            if savedCustomerID != FormatsString.emptyString {
                if !CommonConst.guestUserCheck { //  Logged in User
                    if userID == savedCustomerID {
                        if url.path.debugDescription.contains("/myLibrary") || url.path.debugDescription.contains("/myPatternsLibrary") || url.path.debugDescription.contains("/purchased-library") {
                            if !self.goToMyLibrary {
                                self.goToMyLibrary = true
                            }
                            NotificationCenter.default.post(name: NSNotification.Name("goToMyLibrary"), object: nil, userInfo: nil)
                        } else if url.path.debugDescription.contains("/mobile-pattern-details") || url.path.debugDescription.contains("/pattern-details") {
                            if let designID = self.getQueryStringParameter(url: "\(url)", param: "designId") {
                                self.tailorNovaDID = designID
                                if let MID = self.getQueryStringParameter(url: "\(url)", param: "mannequinId") {
                                    self.tailorNovaMID = MID
                                }
                                if let OID = self.getQueryStringParameter(url: "\(url)", param: "orderID") {
                                    self.tailorNovaOrderID = OID
                                }
                                if !self.goToPatternDesc {
                                    self.goToPatternDesc = true
                                }
                                NotificationCenter.default.post(name: NSNotification.Name("goToMyPatternLibrary"), object: nil, userInfo: nil)
                            }
                        }
                    } else {
                        ServiceManagerProxy.shared.displayerrorPopup(url: "\(url)", responseError: AlertMessage.customerMismatch)
                    }
                } else { // Guest User
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let initialViewController = Constants.loginStoryBoard.instantiateViewController(withIdentifier: Constants.LoginViewControllerIdentifier)
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
                }
            } else {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let initialViewController = Constants.loginStoryBoard.instantiateViewController(withIdentifier: Constants.LoginViewControllerIdentifier)
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        self.window?.makeKeyAndVisible()
        return true
    }
    func getQueryStringParameter(url: String?, param: String) -> String? {
        if let url = url, let urlComponents = URLComponents(string: url), let queryItems = (urlComponents.queryItems) {
            return queryItems.filter({ (item) in item.name == param }).first?.value!
        }
        return nil
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        return self.handleOpenUrl(url, sourceApplication: sourceApplication)
    }
    func handleOpenUrl(_ url: URL, sourceApplication: String?) -> Bool {  // other URL handling goes here.
        return false
    }
    func applicationWillResignActive(_ application: UIApplication) {
        if let manager = NetworkReachabilityManager() {
            if manager.isReachable {
                CommonConst.savedNetworkStatusCheck = manager.isReachable
            } else {
                CommonConst.savedNetworkStatusCheck = !manager.isReachable
            }
        }
        self.window?.endEditing(true)
    }
    func applicationWillEnterForeground(_ application: UIApplication) {   // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: NSNotification.Name(FormatsString.unlockLabel), object: nil, userInfo: nil)
        NotificationCenter.default.post(name: NSNotification.Name(FormatsString.forgroundLabel), object: nil, userInfo: nil)
    }
    func applicationDidBecomeActive(_ application: UIApplication) {   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.updateUserInterface()
        self.bluetoothStatus()
        NotificationCenter.default.post(name: NSNotification.Name(FormatsString.bluetoothLabel), object: CommonConst.bleCheckValue, userInfo: nil)
    }
    //rohith
    // removing selected language when user terminate the app
    func applicationWillTerminate(_ application: UIApplication) {  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        CommonConst.userDefault.set(false, forKey: IsInPage.patternDesc.rawValue)
        CommonConst.userDefault.set(false, forKey: IsInPage.myLibrary.rawValue)
        UserDefaults.standard.removeObject(forKey: "language")
        CoreDataStack.saveContext()
        
    
    }
    func bluetoothStatus() {
        let options = [CBCentralManagerOptionShowPowerAlertKey: false]
        self.managerBLE = CBCentralManager(delegate: self, queue: nil, options: options)
    }
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            self.isWifiOn = false
        case .wwan:
            self.isWifiOn = false
        case .wifi:
            self.isWifiOn = true
        }
        var reachablityStatus = Bool()
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            reachablityStatus = true
        } else {
            reachablityStatus = false
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: FormatsString.NetworkStatus), object: reachablityStatus, userInfo: nil)
    }
    @objc func statusManager(_ notification: Notification) {
        self.updateUserInterface()
    }
}
extension AppDelegate: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.isBluetoothOn = true
            CommonConst.bleCheckValue = true
        case .poweredOff:
            self.isBluetoothOn = false
            CommonConst.bleCheckValue = false
        default:
            break
        }
    }
}
