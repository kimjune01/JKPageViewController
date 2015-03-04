JKPageViewController
=================

The quickest way to use page view controllers with customization and callbacks. (Swift 1.2)

![demo](http://i.imgur.com/29s1wgj.gif)

### Code
``` swift

func addPageVC() { // in viewDidLoad in a UIViewController subclass
pageViewController = PageVC(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: .Horizontal, options: nil)
pageViewController.pages = [FirstOnboardingVC(), SecondOnboardingVC(), ThirdOnboardingVC()]

addChildViewController(self.pageViewController)
view.addSubview(self.pageViewController.view)
pageViewController.didMoveToParentViewController(self)

pageViewController.setInitialPage()
}

```

### Pod
``` 
pod 'JKPageViewController'
```

### Customize
To enable page indicators that show white dots at the bottom:
``` swift
pageViewController.pageControlEnabled = true
```

To enable logging for customization:
``` swift
pageViewController.debugging = true
```

To get callbacks for the child view controllers to know when it appears on screen:
``` swift
extension MyPagedViewController: Appearable {
func didAppearOnScreen() {
// called when the view finish decelerating onto the screen.
}

func didDisappearFromScreen(){
// called when the view finish decelerating off the screen.
}

func willAppearOnScreen(){
// called when the view begin decelerating onto the screen.
}

func willDisappearFromScreen(){
// called when the view begin decelerating off the screen.
}
}
```


### Areas for Improvements / involvement
* Adding customization options.
* Adding callbacks to the scroll position for the child view controller to be fully aware of its position in relation to scrollView.contentoffset for dynamic animations

### Author

June Kim, kimjune01@gmail.com

### License

JKPageViewController is available under the MIT license. See the LICENSE file for more info.

