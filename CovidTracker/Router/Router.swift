//
//  Router.swift
//  CovidTracker
//
//  Created by Masato Takamura on 2021/07/12.
//

import UIKit

final class Router {
    static let shared = Router()
    private init() {}
    
    var window: UIWindow?
    
    let mainVC = MainViewController()
    let prefectureFilterVC = PrefectureFilterViewController()
    let dateFilterVC = DateFilterViewController()
    
    func showRoot(window: UIWindow) {
        prefectureFilterVC.delegate = mainVC
        dateFilterVC.delegate = mainVC
        let nav = UINavigationController(rootViewController: mainVC)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func showPrefectureFilter(from: UIViewController) {
        let nav = UINavigationController(rootViewController: prefectureFilterVC)
        from.present(nav, animated: true, completion: nil)
    }
    
    func showDateFilter(from: UIViewController) {
        let nav = UINavigationController(rootViewController: dateFilterVC)
        from.present(nav, animated: true, completion: nil)
    }
    
    
}
