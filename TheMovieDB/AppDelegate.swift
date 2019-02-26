//
//  AppDelegate.swift
//  TheMovieDB
//
//  Created by Alin Gorgan on 2/24/19.
//  Copyright © 2019 Alin Gorgan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let persistentStore = TMBPersistentStore()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let keyWindow = UIWindow(frame: UIScreen.main.bounds)
        
        let urlFactory = TMBURLFactory()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        keyWindow.rootViewController = navigationController
        
        let configurator = TMBViewConfigurator(persistentStore: persistentStore, urlFactory: urlFactory)
        let router = TMBRouter(configurator: configurator, navigationController: navigationController, storyboard: storyboard)
        configurator.router = router
        
        router.navigateToPopularMoviesViewControler()
        
        keyWindow.makeKeyAndVisible()
        window = keyWindow
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        persistentStore.saveContext()
    }

}

