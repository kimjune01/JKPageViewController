//
//  PageViewController.swift
//  Animase
//
//  Created by Camvy Films on 2015-02-28.
//  Copyright (c) 2015 June. All rights reserved.
//

import UIKit

@objc protocol Appearable {
  /// called when the view finish decelerating onto the screen.
  func didAppearOnScreen()
  /// called when the view finish decelerating off the screen.
  func didDisappearFromScreen()
  /// called when the view begin decelerating onto the screen.
  func willAppearOnScreen()
  /// called when the view begin decelerating off the screen.
  func willDisappearFromScreen()
}

/** A pre-configured wrapper class for UIPageViewController with a simple implementation that:
 
 - encapsulates common delegate methods
 - keeps track of indexes
 - turns page control on/off with the pageControlEnabled boolean
 - comes with an Appearable hook for child view controllers
 
 */
@objc class JKPageViewController: UIPageViewController {
  /// for inspecting view hierarchy and current index.
  var debugging:Bool = false {
    didSet {
      print("JKPageViewController debugging: \(debugging)")
    }
  }
  /// allows for removal of dead space at the bottom when configured before viewDidLoad
  var pageControlEnabled:Bool = false
  /// the child view controllers.
  var pages:[UIViewController] = [UIViewController](){
    didSet{
      setInitialPage()
    }
  }
  var currentVC:UIViewController!
  var nextVC:UIViewController!
  var previousIndex:Int! = 0
  var currentIndex:Int! = 0
  var nextIndex:Int! = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.clipsToBounds = false
    delegate = self
    dataSource = self
  }
  
  /// dead space at the bottom gets removed and makes UIPageControl's background appear transparent
  override func viewDidLayoutSubviews() {
    recursivelyIterateSubviews(view)
    
  }
  
  /// should call to conform to Apple's guidelines for adding child view controllers
  override func didMoveToParentViewController(parent: UIViewController?) {
    super.didMoveToParentViewController(parent)
    parent!.view.gestureRecognizers = gestureRecognizers
    
  }
  
  /// should call manually.
  func setInitialPage() {
    if pages.count > 0 {
      setViewControllers([pages[0]], direction: .Forward, animated: false, completion: { (finished:Bool) -> Void in
        //
      })
    } else if debugging {
      print("JKPageViewController does not have any pages!")
    }
  }
  
  func recursivelyIterateSubviews(view: UIView) {
    if debugging {
      print("\(String.fromCString(object_getClassName(view))) :: frame: \(view.frame)")
    }
    for eachSubview in view.subviews {
      if let scrollView = eachSubview as? UIScrollView {
        scrollView.delegate = self
        scrollView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
      }
      recursivelyIterateSubviews(eachSubview)
    }
  }
  
}

extension JKPageViewController: UIPageViewControllerDelegate {
  func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if !completed { return }
    previousIndex = currentIndex
    currentIndex = nextIndex
    
  }
  func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
    nextVC = pendingViewControllers.first
    nextIndex = pages.indexOf(nextVC)!
  }
  
  
  func viewControllerAtIndex(index: Int) -> UIViewController?{
    if pages.count == 0 || index >= pages.count {
      return nil
    }
    return pages[index]
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    if pageControlEnabled {
      return pages.count
    }
    return 0
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    if pageControlEnabled {
      return currentIndex
    }
    return 0
  }
  
  func scrollToVC(pageIndex:Int!, direction:UIPageViewControllerNavigationDirection) {
    if (pageIndex < 0 || pageIndex >= pages.count) {return}
    setViewControllers([pages[pageIndex]], direction: direction, animated: true) { (completed:Bool) -> Void in
      (self.pages[self.currentIndex] as? Appearable)?.didDisappearFromScreen()
      (self.pages[pageIndex] as? Appearable)?.didAppearOnScreen()
      self.currentIndex = pageIndex
    }
  }
  
}

extension JKPageViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    (pages[previousIndex] as? Appearable)?.didDisappearFromScreen()
    (pages[currentIndex] as? Appearable)?.didAppearOnScreen()
    if debugging {
      print("previousIndex: \(previousIndex) viewController: \(pages[previousIndex])")
      print("currentIndex: \(currentIndex) viewController: \(pages[currentIndex])")
    }
  }
  
  func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
    if debugging {
      print("nextIndex: \(nextIndex) viewController: \(pages[nextIndex])")
    }
    (pages[currentIndex] as? Appearable)?.willDisappearFromScreen()
    (pages[nextIndex] as? Appearable)?.willAppearOnScreen()
    
  }
  
}

extension JKPageViewController: UIPageViewControllerDataSource {
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    if currentIndex == 0 {
      return nil
    }
    return viewControllerAtIndex(currentIndex-1)
  }
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    if (currentIndex == pages.count - 1) {
      return nil
    }
    return viewControllerAtIndex(currentIndex + 1)
  }
  
}

/* Implementation:
 
 func makeViewControllers() {
 let loginMockVC = MockupVC()
 loginMockVC.mockupImage = UIImage(named: "login.png")
 let exploreMockVC = MockupVC()
 exploreMockVC.mockupImage = UIImage(named: "explore.png")
 let trendingMockVC = MockupVC()
 trendingMockVC.mockupImage = UIImage(named: "trending.png")
 let specificMockVC = MockupVC()
 specificMockVC.mockupImage = UIImage(named: "specific.png")
 
 viewControllers = [loginMockVC, exploreMockVC, trendingMockVC, specificMockVC]
 }
 
 func addPageVC() {
 pageViewController = PageVC(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: .Horizontal, options: nil)
 
 pageViewController.pageControlEnabled = true
 pageViewController.debugging = true
 pageViewController.pages = viewControllers
 addChildViewController(self.pageViewController)
 view.addSubview(self.pageViewController.view)
 pageViewController.didMoveToParentViewController(self)
 
 pageViewController.setInitialPage()
 }
 
 */
