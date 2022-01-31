//
//  Created by Brian Coyner on 11/9/17.
//  Copyright © 2017 Brian Coyner. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()
}

extension AppDelegate {

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Needed for iOS 15 navigation bars to render correctly.
        let crossCuttingAppearance = UINavigationBar.appearance()
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        crossCuttingAppearance.standardAppearance = navigationBarAppearance
        crossCuttingAppearance.scrollEdgeAppearance = navigationBarAppearance

        let mainViewController = MapViewController()
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)
        window?.makeKeyAndVisible()
        return true
    }
}
