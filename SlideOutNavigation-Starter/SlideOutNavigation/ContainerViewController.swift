//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore



enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

let centerPanelExpandedOffset:CGFloat = 60

class ContainerViewController: UIViewController, CenterViewControllerDelegate{
    
    
    
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leftViewController: SidePanelViewController?
    var rightViewController: SidePanelViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.didMoveToParentViewController(self)

    }
  
    // MARK: CenterViewController delegate methods
  
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
  

    func addLeftPanelViewController() {
        if leftViewController == nil
        {
            leftViewController = UIStoryboard.leftViewController()
            leftViewController?.animals = Animal.allCats()
            addChildSidePanelController(leftViewController!)
        }
    }
    
  
    func animateLeftPanel(#shouldExpand: Bool) {
        if shouldExpand {
           currentState = .LeftPanelExpanded
            animateCenterPanelXPosition(targetPosition:CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition:0) { finished in
                self.currentState = .BothCollapsed
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
        
    }
    
//    
//    func addRightPanelViewController() {
//        if (rightViewController == nil) {
//            rightViewController = UIStoryboard.rightViewController()
//            rightViewController!.animals = Animal.allDogs()
//            
//            addChildSidePanelController(rightViewController!)
//        }
//    }
//    
//    func animateRightPanel(#shouldExpand: Bool) {
//        if (shouldExpand) {
//            currentState = .RightPanelExpanded
//            
//            animateCenterPanelXPosition(targetPosition: -CGRectGetWidth(centerNavigationController.view.frame) + centerPanelExpandedOffset)
//        } else {
//            animateCenterPanelXPosition(targetPosition: 0) { _ in
//                self.currentState = .BothCollapsed
//                
//                self.rightViewController!.view.removeFromSuperview()
//                self.rightViewController = nil;
//            }
//        }
//    }
//    
//    
//    func toggleRightPanel() {
//        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
//        
//        if notAlreadyExpanded {
//            addRightPanelViewController()
//        }
//        
//        animateRightPanel(shouldExpand: notAlreadyExpanded)
//    }
    
    
    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addRightPanelViewController() {
        if rightViewController == nil
        {
            rightViewController = UIStoryboard.rightViewController()
            rightViewController?.animals = Animal.allDogs()
            addChildSidePanelController(rightViewController!)
        }
    }
    
    
    func animateRightPanel(#shouldExpand: Bool) {
        if shouldExpand {
            currentState = .RightPanelExpanded
            animateCenterPanelXPosition(targetPosition:-CGRectGetWidth(centerNavigationController.view.frame) + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition:0) { finshed in
                self.currentState = .BothCollapsed
                self.rightViewController!.view.removeFromSuperview()
                self.rightViewController = nil
            }
        }
    }
    
    
    
    func addChildSidePanelController(sidePanelController:SidePanelViewController){
        view.insertSubview(sidePanelController.view, atIndex: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
                self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0
        }
    }
    
    
   
  
    // MARK: Gesture recognizer
  
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
    }
}

private extension UIStoryboard {
  class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
  
  class func leftViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
  }
  
  class func rightViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("RightViewController") as? SidePanelViewController
  }
  
  class func centerViewController() -> CenterViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
  }
}