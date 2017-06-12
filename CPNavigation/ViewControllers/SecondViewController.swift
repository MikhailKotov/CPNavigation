//
//  SecondViewController.swift
//  CPNavigation
//
//  Created by Mikhail Kotov on 6/12/17.
//  Copyright © 2017 Mikhail_Kotov. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

}

// MARK: CPViewGradientBackground
extension SecondViewController: CPViewGradientBackground {

    func cpViewBackground(_ cpView: CPView) -> (bottom: UIColor, center: UIColor, top: UIColor) {
        return (bottom:UIColor(red:258.0/255.0,green:231.0/255.0,blue:183.0/255.0,alpha:1),
                center:UIColor(red:111.0/255.0,green:137.0/255.0, blue:70.0/255.0 ,alpha:1),
                top:   UIColor(red:106.0/255.0, green:116.0/255.0, blue:31.0/255.0 ,alpha:1))
    }
    
}
