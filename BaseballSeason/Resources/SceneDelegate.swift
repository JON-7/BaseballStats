//
//  SceneDelegate.swift
//  BaseballSeason
//
//  Created by Jon E on 3/30/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabbar()
        window?.makeKeyAndVisible()
    }
    
    func createNav() -> UINavigationController {
        let vc = TeamStandingsVC()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    func createTabbar() -> UITabBarController {
        let standingsVC = UINavigationController(rootViewController: TeamStandingsVC())
        let leadersVC = UINavigationController(rootViewController: LeagueLeadersVC())
        let favoritesVC = FavoritesVC()
        let tabbar = UITabBarController()
        
        tabbar.setViewControllers([standingsVC, leadersVC, favoritesVC], animated: true)
        tabbar.tabBar.backgroundColor = .clear
        
        let images = ["pencil", "pencil", "star.circle.fill"]
        let titles = ["Standings", "Leaders", "Favorites"]
        if let items = tabbar.tabBar.items {
            for n in 0..<items.count {
                items[n].image = UIImage(systemName: images[n])
                items[n].title = titles[n]
            }
        }
        
        let tabbarItem1 = tabbar.tabBar.items![0]
        tabbarItem1.image = UIImage(systemName: "pencil")
        
        return tabbar
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

