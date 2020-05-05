import Foundation
import UIKit

class MapViewController: UIViewController, UINavigationControllerDelegate {
    
    enum CardState {
        case collapsed
        case expanded
    }

    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    @IBOutlet weak var mapView: UIWebView!
    
    
    var cardViewController:CardViewController!
    var visualEffectView:UIVisualEffectView!
    
    var cardHeight:CGFloat = 600
    var cardHandleAreaHeight:CGFloat = 75
    
    var cardVisible = false

    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCard()
        animateTransitionIfNeeded(state: nextState, duration: 0.9)
        
        let defaults = UserDefaults.standard
        let isCustomerView = defaults.bool(forKey: "isCustomerView")
        let orderLat = defaults.string(forKey: "CurrentLat")!
        let orderLng = defaults.string(forKey: "CurrentLng")!
        var id = "0"
        if isCustomerView == true{
            id = defaults.string(forKey: "userInfoID")!
        }
        else{
            id = defaults.string(forKey: "UID")!
        }
        
        if Reachability.isConnectedToNetwork() == true {
            let url = URL (string: "https://map.fix-up.org/about?lat=" + orderLat + "&lng=" + orderLng + "&id=" + id)
            print(url)
            let requestObj = URLRequest(url: url!)
            self.mapView.loadRequest(requestObj)
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        self.mapView.scrollView.isScrollEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func setupCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
//        self.view.addSubview(visualEffectView)

        cardViewController = CardViewController(nibName:"CardViewController", bundle:nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MapViewController.handleCardPan(recognizer:)))

        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
    }

    // Handle tap gesture recognizer
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
            // Animate card when tap finishes
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }

    // Handle pan gesture recognizer
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Start animation if pan begins
            startInteractiveTransition(state: nextState, duration: 0.9)

        case .changed:
            // Update the translation according to the percentage completed
            let translation = recognizer.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            // End animation when pan ends
            continueInteractiveTransition()
        default:
            break
        }
    }

    // Animate transistion function
     func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
         // Check if frame animator is empty
         if runningAnimations.isEmpty {
             // Create a UIViewPropertyAnimator depending on the state of the popover view
             let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                 switch state {
                 case .expanded:
                     // If expanding set popover y to the ending height and blur background
                     self.cardViewController.view.frame.origin.y = self.view.frame.height -  self.cardHeight
                     self.visualEffectView.effect = UIBlurEffect(style: .dark)

                 case .collapsed:
                     // If collapsed set popover y to the starting height and remove background blur
                     self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight

                     self.visualEffectView.effect = nil
                     

                 }
             }

             // Complete animation frame
             frameAnimator.addCompletion { _ in
                 self.cardVisible = !self.cardVisible
                 self.runningAnimations.removeAll()
             }

             // Start animation
             frameAnimator.startAnimation()

             // Append animation to running animations
             runningAnimations.append(frameAnimator)

             // Create UIViewPropertyAnimator to round the popover view corners depending on the state of the popover
             let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                 switch state {
                 case .expanded:
                     // If the view is expanded set the corner radius to 30
                     self.cardViewController.view.layer.cornerRadius = 30

                 case .collapsed:
                     // If the view is collapsed set the corner radius to 0
                     self.cardViewController.view.layer.cornerRadius = 0
                 }
             }

             // Start the corner radius animation
             cornerRadiusAnimator.startAnimation()

             // Append animation to running animations
             runningAnimations.append(cornerRadiusAnimator)

         }
     }

     // Function to start interactive animations when view is dragged
     func startInteractiveTransition(state:CardState, duration:TimeInterval) {

         // If animation is empty start new animation
         if runningAnimations.isEmpty {
             animateTransitionIfNeeded(state: state, duration: duration)
         }

         // For each animation in runningAnimations
         for animator in runningAnimations {
             // Pause animation and update the progress to the fraction complete percentage
             animator.pauseAnimation()
             animationProgressWhenInterrupted = animator.fractionComplete
         }
     }

     // Funtion to update transition when view is dragged
     func updateInteractiveTransition(fractionCompleted:CGFloat) {
         // For each animation in runningAnimations
         for animator in runningAnimations {
             // Update the fraction complete value to the current progress
             animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
         }
     }

     // Function to continue an interactive transisiton
     func continueInteractiveTransition (){
         // For each animation in runningAnimations
         for animator in runningAnimations {
             // Continue the animation forwards or backwards
             animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
         }
     }
    
}
