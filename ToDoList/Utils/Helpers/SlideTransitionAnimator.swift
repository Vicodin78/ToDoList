//
//  SlideTransitionAnimator.swift
//  ToDoList
//
//  Created by Vicodin on 21.03.2025.
//

import UIKit

class SlideTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        if isPresenting {
            containerView.addSubview(toViewController.view)
            
            // Начальное положение следующего экрана за экраном
            toViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.bounds.width, dy: 0)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                // Сдвигаем текущий экран влево
                fromViewController.view.frame = fromViewController.view.frame.offsetBy(dx: -containerView.bounds.width, dy: 0)
                // Выдвигаем новый экран на место
                toViewController.view.frame = containerView.bounds
            }) { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }
}


class SlideTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideTransitionAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideTransitionAnimator(isPresenting: false)
    }
}
