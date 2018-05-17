//
//  TabBarViewController.swift
//  KOA1
//
//  Created by Basila Nathan on 5/6/18.
//  Copyright © 2018 Basila. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item0 = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let item1 = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        guard let vc0 = storyboard?.instantiateViewController(withIdentifier: "SearchNavigation") else {
            return
        }
        guard let vc1 = storyboard?.instantiateViewController(withIdentifier: "SearchNavigation") else {
            return
        }
        vc1.tabBarItem = item1
        vc0.tabBarItem = item0
        
        setViewControllers([vc0, vc1], animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
