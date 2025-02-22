import UIKit
import SnapKit

open class SnapScrollViewController: UIViewController {
  // MARK: - Properties
  private let scrollView = UIScrollView().apply {
    $0.isPagingEnabled = true
    $0.showsVerticalScrollIndicator = false
    $0.bounces = true
    $0.contentInsetAdjustmentBehavior = .never
  }
  
  private let viewControllers: [UIViewController]
  private var currentIndex: Int = 0
  
  // MARK: - Initialization
  public init(viewControllers: [UIViewController]) {
    self.viewControllers = viewControllers
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  open override func viewDidLoad() {
    super.viewDidLoad()
    setupScrollView()
  }
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateScrollViewLayout()
  }
  
  // MARK: - Setup
  private func setupScrollView() {
    automaticallyAdjustsScrollViewInsets = false
    
    view.addSubview(scrollView)
    scrollView.delegate = self
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.left.right.bottom.equalToSuperview()
    }
    
    setupChildViewControllers()
  }
  
  private func setupChildViewControllers() {
    var previousView: UIView?
    
    for (index, childVC) in viewControllers.enumerated() {
      addChild(childVC)
      scrollView.addSubview(childVC.view)
      
      childVC.view.snp.makeConstraints {
        $0.width.height.equalTo(scrollView)
        $0.left.right.equalTo(scrollView)
        
        if let previousView = previousView {
          $0.top.equalTo(previousView.snp.bottom)
        } else {
          $0.top.equalTo(scrollView)
        }
        
        if index == viewControllers.count - 1 {
          $0.bottom.equalTo(scrollView)
        }
      }
      
      previousView = childVC.view
      childVC.didMove(toParent: self)
    }
  }
  
  private func updateScrollViewLayout() {
    scrollView.contentInset = .zero
    scrollView.scrollIndicatorInsets = .zero
    scrollView.contentSize = CGSize(
      width: scrollView.bounds.width,
      height: scrollView.bounds.height * CGFloat(viewControllers.count)
    )
  }
  
  // MARK: - Public Methods
  public func scrollToPage(_ index: Int, animated: Bool = true) {
    guard index >= 0 && index < viewControllers.count else { return }
    let yOffset = CGFloat(index) * scrollView.bounds.height
    scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
    currentIndex = index
  }
  
  // MARK: - Private Methods
  private func getCurrentViewController() -> UIViewController? {
    let page = Int(scrollView.contentOffset.y / scrollView.bounds.height)
    guard page >= 0 && page < viewControllers.count else { return nil }
    return viewControllers[page]
  }
}

// MARK: - UIScrollViewDelegate
extension SnapScrollViewController: UIScrollViewDelegate {
  open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let page = Int(scrollView.contentOffset.y / scrollView.bounds.height)
    if currentIndex != page {
      currentIndex = page
    }
  }
  
  open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let pageHeight = scrollView.bounds.height
    let targetPage = Int(targetContentOffset.pointee.y / pageHeight)
    
    // Handle bounds
    if targetPage < 0 {
      targetContentOffset.pointee.y = 0
    } else if targetPage >= viewControllers.count {
      targetContentOffset.pointee.y = pageHeight * CGFloat(viewControllers.count - 1)
    }
  }
  
  open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    // Default empty implementation for subclasses to override
  }
  
  open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    // Default empty implementation for subclasses to override
  }
}
