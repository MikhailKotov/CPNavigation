//
//  MainViewController.swift
//  Calmind
//
//  Created by Mikhail Kotov on 5/8/17.
//  Copyright © 2017 Mikhail_Kotov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cpView: CPView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cpView.delegate = self
        cpView.dataSource = self
        cpView.reloadData()
    }
}

extension MainViewController: CPViewDelegate {
    
    func cpView(_ cpView: CPView,
                didUpdatePageCount count: Int) {
        pageControl.numberOfPages = Int(count)
    }
    
    func cpView(_ cpView: CPView,
                didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}

extension MainViewController: CPViewDataSource {
    
    func cpViewPages(_ cpView: CPView) -> [String] {
        return ["First", "Second", "Third"]
    }
    
    func cpViewHandleViewController(_ cpView: CPView) -> UIViewController {
        return self
    }
}
