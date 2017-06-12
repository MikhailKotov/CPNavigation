//
//  FirstViewController.swift
//  CPNavigation
//
//  Created by Mikhail Kotov on 6/12/17.
//  Copyright © 2017 Mikhail_Kotov. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

}

// MARK: CPViewGradientBackground
extension FirstViewController: CPViewGradientBackground {
    
    func cpViewBackground(_ cpView: CPView) -> (bottom: UIColor, center: UIColor, top: UIColor) {
        return (bottom:UIColor(red:58.0/255.0,green:131.0/255.0,blue:183.0/255.0,alpha:1),
                center:UIColor(red:11.0/255.0,green:37.0/255.0, blue:70.0/255.0 ,alpha:1),
                top:   UIColor(red:6.0/255.0, green:16.0/255.0, blue:31.0/255.0 ,alpha:1))
    }
    
}
