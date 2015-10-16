//
//  backButtonDelegate.swift
//  spotify-sdk-test
//
//  Created by Drake Wempe on 9/17/15.
//  Copyright © 2015 Drake Wempe. All rights reserved.
//

import Foundation

protocol BackButtonDelegate : class {
    func backButtonPressedFrom(controller: UIViewController)
}