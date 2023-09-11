
import UIKit

protocol CommonPageProtocol {
    func scrollingDidEnd(index: Int)
}

class CommonPageView : UIView {

    var pageViewController : UIPageViewController = UIPageViewController()
    
    var transitionComplete: Bool = false
    var animationComplete: Bool = false
    
    private var selectedIndex = 0
    
    var delegate:CommonPageProtocol?
    
    var arrViewController : [UIViewController] = [] {
        didSet{
            pageViewController.delegate = self
            pageViewController.dataSource = self
            
            if let firstVC = arrViewController[exist : selectedIndex] {
                pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
            }else if let firstVC = arrViewController.first {
                pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
            }
           // setViewController(index: selectedIndex)
        }
    }
    
    var selectionChange:  ((Int) -> Void)?

    deinit {
        GFunction.shared.deinitWithClass(className: self)
    }
    
    //------------------------------------------------------
        
        //MARK:- Custom Method
    
    func setViewController(index: Int,isAnimated:Bool = true)  {
        
        if let firstVC = arrViewController[exist : index] {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.pageViewController.setViewControllers([firstVC], direction: index > self.selectedIndex ? .forward : .reverse, animated: isAnimated, completion: nil)
                self.selectedIndex = index
            }
        }
    }
    
    func setUpView() {
        
        // Add Page View With Constraint
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pageViewController.view)
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: self.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        pageViewController.view.backgroundColor = .clear
        
        self.parentViewController?.addChild(pageViewController)
        
        pageViewController.didMove(toParent: self.parentViewController)
        
    }
    
    func setScroll(set: Bool = false) {
        for subview in self.subviews[0].subviews {
            if let scrollview = subview as? UIScrollView {
                scrollview.isScrollEnabled = set
                break
            }
        }
    }
}


//--------------------------------------------------------------------------
//MARK:- Page View Methods

extension CommonPageView : UIPageViewControllerDelegate , UIPageViewControllerDataSource , UIGestureRecognizerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = arrViewController.firstIndex(of: viewController) else {
            return nil
        }
        if viewControllerIndex > 0 {
            selectedIndex = viewControllerIndex
            return self.arrViewController[viewControllerIndex - 1]
        } else{
            selectedIndex = 0
            return nil
        }
        
//        let previousIndex = viewControllerIndex - 1
//
//        guard previousIndex >= 0 else {
//            return nil
//        }
//
//        guard arrViewController.count > previousIndex else {
//            return nil
//        }
//
//        return arrViewController[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = arrViewController.firstIndex(of: viewController) else {
            return nil
        }
        if viewControllerIndex < arrViewController.count - 1 {
            selectedIndex = viewControllerIndex
            return arrViewController[viewControllerIndex + 1]
        } else {
            selectedIndex = arrViewController.count - 1
            return nil
        }
        
//        let nextIndex = viewControllerIndex + 1
//        let orderedViewControllersCount = arrViewController.count
//
//        guard orderedViewControllersCount != nextIndex else {
//            return nil
//        }
//
//        guard orderedViewControllersCount > nextIndex else {
//            return nil
//        }
//
//        return arrViewController[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let index = self.arrViewController.firstIndex(of: currentVC) else { return }
        self.delegate?.scrollingDidEnd(index: index)
        
         /*if completed {
            self.transitionComplete = completed
            print("transition completed \(completed)")
         }
        if finished {
            
            self.delegate?.scrollingDidEnd(index: {
                switch pageViewController.viewControllers?.first {
                case is FavouriteCurrencyVC:
                    return 0
                case is ExchangerVC:
                    return 1
                default:
                    return 2
                }
            }())
            
            
            
            print(index)
            self.animationComplete = finished
        }*/
     }
    
    
}


//--------------------------------------------------------------------------
//MARK:- Helper Extesions

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
