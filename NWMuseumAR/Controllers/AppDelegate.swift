//
//  AppDelegate.swift
//  NWMuseumAR
//
//  Created by Harrison Milbradt on 2018-01-31.
//  Copyright © 2018 NWMuseumAR. All rights reserved.
//

import UIKit
import CoreData
import ARKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "NWMuseumAR")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Should be replaced with code to fail gracefully
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
    
        let homeViewController: UIViewController
        
        // iOS 11.3 required, ARWorldTracking capable chip required
        if ARWorldTrackingConfiguration.isSupported, #available(iOS 11.3, *){
            
            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            
            if launchedBefore  {
                // Skip Tutorial
                homeViewController = MainPageViewController()
            } else {
                // Show tutorial, add launchedbefore to storage
                homeViewController = TutorialPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                //UserDefaults.standard.set(true, forKey: "launchedBefore")
            }
            
            // seed database if not already seeded
            let seeded = UserDefaults.standard.bool(forKey: "seeded")
            debugPrint("Seeded? \(seeded)")
            if !seeded {
                debugPrint("Seeding database")
                seedDatabase()
                UserDefaults.standard.set(true, forKey: "seeded")
            }
            
        } else {
            // TODO: - Set this to unsupported device controller
            homeViewController = TutorialPageViewController()
        }

        // Show our starting controller to the user
        window!.rootViewController = homeViewController
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func seedDatabase() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let canoe = Artifact(context: context)
        canoe.title = "Canoe"
        canoe.image = "canoe"
        canoe.completed = false
        
        let fire = Artifact(context: context)
        fire.title = "Fire"
        fire.image = "fire"
        fire.completed = false
        
        let freedom = Artifact(context: context)
        freedom.title = "Freedom"
        freedom.image = "freedom"
        freedom.completed = false
        
        let proclamation = Artifact(context: context)
        proclamation.title = "Proclamation"
        proclamation.image = "proclamation"
        proclamation.completed = false
        
        let train = Artifact(context: context)
        train.title = "Train"
        train.image = "train"
        train.completed = false
        
        let wanted = Artifact(context: context)
        wanted.title = "Wanted"
        wanted.image = "wanted"
        wanted.completed = false
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        debugPrint("database seeded")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
