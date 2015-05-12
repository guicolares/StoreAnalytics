//
//  UserDefaultsManager.swift
//  StoreAnalytics
//
//  Created by Matheus Frozzi Alberton on 12/05/15.
//  Copyright (c) 2015 Guilherme Leite Colares. All rights reserved.
//

import UIKit

private let ads = "adverts"

class UserDefaultsManager: NSObject {
    
    // Properties Stored in User Defaults
    class var removeAdwords: Int? {
        get {
            return NSUserDefaults.standardUserDefaults().valueForKey(ads) as? Int
        }
        set(newMyProperty) {
            NSUserDefaults.standardUserDefaults().setValue(newMyProperty, forKey: ads)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
