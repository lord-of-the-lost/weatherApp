//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Николай Игнатов on 05.03.2023.
//

import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController(rootViewController: WeatherViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.safe()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let conteiner = NSPersistentContainer(name: "WeatherData")
        conteiner.loadPersistentStores { (storeDescription, error)  in
            if let error = error as NSError? {
                fatalError("\(error.userInfo)")
            }
        }
        return conteiner
    }()
    
    func safe() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(nserror.userInfo)")
            }
        }
    }
}
