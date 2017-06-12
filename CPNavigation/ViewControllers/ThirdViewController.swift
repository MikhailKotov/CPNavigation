//
//  ThirdViewController.swift
//  CPNavigation
//
//  Created by Mikhail Kotov on 6/12/17.
//  Copyright © 2017 Mikhail_Kotov. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

}

// MARK: CPViewGradientBackground
extension ThirdViewController: CPViewGradientBackground {

    func cpViewBackground(_ cpView: CPView) -> (bottom: UIColor, center: UIColor, top: UIColor) {
        return (bottom:UIColor(red:108.0/255.0,green:201.0/255.0,blue:183.0/255.0,alpha:1),
                center:UIColor(red:61.0/255.0,green:107.0/255.0, blue:70.0/255.0 ,alpha:1),
                top:   UIColor(red:56.0/255.0, green:86.0/255.0, blue:31.0/255.0 ,alpha:1))
    }
    
}
