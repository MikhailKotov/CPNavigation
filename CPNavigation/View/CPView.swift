//
//  CPView.swift
//  CPNavigation
//
//  Created by Mikhail Kotov on 6/12/17.
//  Copyright © 2017 Mikhail_Kotov. All rights reserved.
//

import UIKit

public protocol CPViewGradientBackground: NSObjectProtocol {
    /**
     Storyboard names for every page.
     
     - parameter cpView: the CPView instance
     - returns: colors: .
     */
    func cpViewBackground(_ cpView: CPView) -> (bottom:UIColor,center:UIColor,top:UIColor)
}

public protocol CPViewDataSource: NSObjectProtocol {
    /**
     Storyboard names for every page.
     
     - parameter cpView: the CPView instance
     - returns: Storyboard name list.
     */
    func cpViewPages(_ cpView: CPView) -> [String]
    /**
     Use it to show child view controllers inside it.
     
     - parameter cpView: the CPView instance
     - returns: View Controller which contain CPView.
     */
    func cpViewHandleViewController(_ cpView: CPView) -> UIViewController
}

public protocol CPViewDelegate: NSObjectProtocol {
    /**
     Called when the number of pages is updated.
     
     - parameter cpView: the CPView instance
     - parameter count: the total number of pages.
     */
    func cpView(_ cpView: CPView, didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter cpView: the CPView instance
     - parameter index: the index of the currently visible page.
     */
    func cpView(_ cpView: CPView, didUpdatePageIndex index: Int)
    
}

open class CPView: UIView {
    
    weak open var delegate: CPViewDelegate?
    weak open var dataSource: CPViewDataSource?
    open var selectedIndex: Int = 0
    
    // We should add feature to remove old VC if app call this method again...
    // But current task needs to call it one time... maybe later )
    
    func reloadData() {
        self.viewControllers = self.dataSource?.cpViewPages(self).map({ (name) -> UIViewController in
            let vc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()
            assert(vc != nil, "You should add initial view controller to \(name).storyboard")
            assert(vc! is CPViewGradientBackground, "The initial view controller in \(name).storyboard should implement CPViewGradientBackground protocol")
            vc!.view.backgroundColor = UIColor.clear
            return vc!
        })
        self.setupUI() // we should call it only one time )))
        self.delegate?.cpView(self, didUpdatePageCount: self.viewControllers!.count)
    }
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var bottomGradientLayer = RadialGradientLayer()
    fileprivate var topGradientLayer = RadialGradientLayer()
    fileprivate var viewControllers: [UIViewController]? = nil
    
    override open func layoutSubviews() {
        topGradientLayer.frame = self.bounds
        bottomGradientLayer.frame = self.bounds
        let offsetX = viewControllers![selectedIndex].view.frame.origin.x
        self.scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        updateBackgroundForOffset(offsetX) // after resizing we should update background colors
    }
}

// MARK: Private CPView
private extension CPView {
    func setupUI(){
        self.addScrollView()
        let parent = self.dataSource?.cpViewHandleViewController(self)
        assert(parent != nil, "Please add cpViewHandleViewController(:)")
        assert(self.viewControllers != nil, "Please add cpViewPages(:)")
        self.fillScrollView(self.viewControllers!, parentViewController: parent!)
        self.addBackground()
    }
    
    func addScrollView() {
        self.scrollView = UIScrollView()
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.backgroundColor = .clear
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
        self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    func fillScrollView(_ viewControllers: [UIViewController], parentViewController: UIViewController) {
        let curVC = viewControllers[0]
        parentViewController.addChildViewController(curVC)
        scrollView.addSubview(curVC.view)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        curVC.view.translatesAutoresizingMaskIntoConstraints = false
        curVC.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        curVC.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        curVC.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        
        curVC.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        curVC.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        curVC.didMove(toParentViewController: parentViewController)
        
        for i in 1..<viewControllers.count {
            let curVC = viewControllers[i]
            let prevVC = viewControllers[i-1]
            parentViewController.addChildViewController(curVC)
            scrollView.addSubview(curVC.view)
            curVC.view.translatesAutoresizingMaskIntoConstraints = false
            curVC.view.leftAnchor.constraint(equalTo: prevVC.view.rightAnchor).isActive = true
            curVC.view.widthAnchor.constraint(equalTo: prevVC.view.widthAnchor).isActive = true
            curVC.view.topAnchor.constraint(equalTo: prevVC.view.topAnchor).isActive = true
            curVC.view.bottomAnchor.constraint(equalTo: prevVC.view.bottomAnchor).isActive = true
            curVC.didMove(toParentViewController: parentViewController)
        }
        let lastVC = viewControllers.last!
        lastVC.view.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0).isActive = true
    }
    
    func addBackground() {
        // color gradient background
        self.layer.insertSublayer(topGradientLayer, at: 0)
        topGradientLayer.frame = self.bounds
        topGradientLayer.locations = [0.5, 1]
        topGradientLayer.center = CGPoint(x:0.5, y:1)
        topGradientLayer.colors = [
            UIColor(white: 0, alpha: 0).cgColor,
            UIColor(white: 0, alpha: 0).cgColor]
        
        self.layer.insertSublayer(bottomGradientLayer, at: 0)
        bottomGradientLayer.frame = self.bounds
        bottomGradientLayer.locations = [0, 0.5, 1.0]
        bottomGradientLayer.center = CGPoint(x:0.97, y:0.97)
        
        updateBackgroundForOffset(0.0)
    }
}


private extension UIColor{
    static func mix(color1: UIColor, color2: UIColor, pos: CGFloat) -> UIColor {
        var fRed1 : CGFloat = 0
        var fGreen1 : CGFloat = 0
        var fBlue1 : CGFloat = 0
        var fAlpha1: CGFloat = 0
        var fRed2 : CGFloat = 0
        var fGreen2 : CGFloat = 0
        var fBlue2 : CGFloat = 0
        var fAlpha2: CGFloat = 0
        if color1.getRed(&fRed1, green: &fGreen1, blue: &fBlue1, alpha: &fAlpha1) &&
            color2.getRed(&fRed2, green: &fGreen2, blue: &fBlue2, alpha: &fAlpha2) {
            return UIColor(red:   avgPos(v0:fRed1,  v1:fRed2,  pos:pos),
                           green: avgPos(v0:fGreen1,v1:fGreen2,pos:pos),
                           blue:  avgPos(v0:fBlue1, v1:fBlue2, pos:pos),
                           alpha: avgPos(v0:fAlpha1,v1:fAlpha2,pos:pos))
        }
        else {
            return color1
        }
    }
    
    private static func avgPos(v0: CGFloat, v1: CGFloat, pos: CGFloat) -> CGFloat {
        return v0 + (v1 - v0) * pos
    }
}

// MARK: ScrollViewDelegate
extension CPView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageCount = CGFloat(self.viewControllers!.count)
        let page = scrollView.contentOffset.x * pageCount / scrollView.contentSize.width
        updateBackgroundForOffset(scrollView.contentOffset.x)
        self.selectedIndex = Int(min(pageCount-1,
                                     max(0.0, page + 0.5)))
        self.delegate?.cpView(self, didUpdatePageIndex: self.selectedIndex)
    }
    
    
    func updateBackgroundForOffset(_ offset: CGFloat) {
        let rgbColors = rgbColorForOffset(offset)
        self.bottomGradientLayer.colors = [rgbColors.bottom.cgColor,
                                           rgbColors.center.cgColor,
                                           rgbColors.top.cgColor]
    }
    
    
    func rgbColorForOffset(_ pos : CGFloat) -> (bottom:UIColor, center:UIColor, top:UIColor) {
        var position: CGFloat = 0
        var page = 0
        let pageCount = self.viewControllers!.count
        let offsetX = scrollView.contentOffset.x
        let contentW = scrollView.contentSize.width
        if contentW != 0 {
            let pageF = offsetX * CGFloat(pageCount) / contentW
            position = pageF.truncatingRemainder(dividingBy: 1.0)
            page     = Int(pageF)
        }
        // we should get colors from VC (Page). If selected page is last then next page color
        // we should get from first VC
        let col1 = (self.viewControllers![page] as! CPViewGradientBackground).cpViewBackground(self)
        if page + 1 >= pageCount {
            page = -1
        }
        let col2 = (self.viewControllers![page+1] as! CPViewGradientBackground).cpViewBackground(self)
        
        return (bottom:UIColor.mix(color1: col1.bottom, color2: col2.bottom, pos: position),
                center:UIColor.mix(color1: col1.center, color2: col2.center, pos: position),
                top:   UIColor.mix(color1: col1.top,    color2: col2.top,    pos: position))
    }
}



private class RadialGradientLayer: CALayer {
    
    override init(){
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    
    init(center:CGPoint,radius:CGFloat,colors:[CGColor]){
        self.center = center
        self.radius = radius
        self.colors = colors
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    var center:CGPoint = CGPoint(x:0.5,y:0.5)
    var radius:CGFloat = 20
    var colors:Array<CGColor> = [UIColor.clear.cgColor , UIColor.clear.cgColor] {
        didSet {
            setNeedsDisplay()
        }
    }
    var locations:[CGFloat] = [0.0, 1.0] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    static var w:CGFloat = 0
    static var oldD:(full:CGFloat, halfW:CGFloat,halfH:CGFloat) = (full:0, halfW:0,halfH:0)
    
    func rad() -> (full:CGFloat, halfW:CGFloat,halfH:CGFloat) {
        if RadialGradientLayer.w != frame.size.width {
            RadialGradientLayer.w = frame.size.width
            RadialGradientLayer.oldD.full = CGFloat( sqrt(Double(pow(frame.size.height, 2) + pow(frame.size.width,2))))
            RadialGradientLayer.oldD.halfW = CGFloat( sqrt(Double(pow(frame.size.height, 2) + pow(frame.size.width/2,2))))
            RadialGradientLayer.oldD.halfH = CGFloat( sqrt(Double(pow(frame.size.height/2, 2) + pow(frame.size.width,2))))
        }
        return RadialGradientLayer.oldD
    }
    
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient   = CGGradient(colorsSpace: colorSpace,
                                    colors: self.colors as CFArray,
                                    locations: locations)
        let centerP    = CGPoint(x:center.x*self.bounds.width,
                                 y:center.y*self.bounds.height)
        let center2    = CGPoint(x:self.bounds.width/2,
                                 y:self.bounds.height)
        if center.x<0.51 {
            ctx.drawRadialGradient(gradient!,
                                   startCenter: centerP,
                                   startRadius: 0.0,
                                   endCenter: center2,
                                   endRadius: rad().halfW,
                                   options: CGGradientDrawingOptions(rawValue: 0))
        }
        else {
            ctx.drawRadialGradient(gradient!,
                                   startCenter: centerP,
                                   startRadius: 0.0,
                                   endCenter: center2,
                                   endRadius: rad().full,
                                   options: CGGradientDrawingOptions(rawValue: 0))
        }
    }
}
