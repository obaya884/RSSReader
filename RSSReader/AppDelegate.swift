//
//  AppDelegate.swift
//  RSSReader
//
//  Created by 大林拓実 on 2020/11/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        let model = Model()
        let presenter = Presenter(view: view, model: model)
        view.inject(presenter: presenter)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = view
        window?.makeKeyAndVisible()

        return true
    }
    
}

