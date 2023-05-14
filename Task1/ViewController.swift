import UIKit

final class ViewController: UIViewController {
    let scale: CGFloat = 2
    let side: CGFloat = 50
    lazy var square: UIView = {
        let square = UIView()
        square.backgroundColor = view.tintColor
        square.layer.cornerRadius = 8.0
        square.layer.cornerCurve = .continuous
        return square
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(handleSliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(handleSliderTouchUp), for: [.touchUpInside, .touchUpOutside])
        return slider
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(square)
        view.addSubview(slider)
        
        square.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        leadingConstraint = square.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        trailingConstraint = square.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: side * (1 - scale))
        NSLayoutConstraint.activate([
            square.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50),
            leadingConstraint,
            square.widthAnchor.constraint(equalToConstant: side),
            square.heightAnchor.constraint(equalToConstant: side),
            slider.topAnchor.constraint(equalTo: margins.topAnchor, constant: 200),
            slider.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
    }
    
    lazy var animator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator.init(duration: 0, curve: .linear) { [scale] in
            self.square.transform = .identity.scaledBy(x: scale, y: scale).rotated(by: .pi / 2)
            self.leadingConstraint.isActive = false
            self.trailingConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
        
        animator.pausesOnCompletion = true
        return animator
    }()
    
    @objc func handleSliderValueChanged() {
        animator.fractionComplete = CGFloat(slider.value)
    }
    
    @objc func handleSliderTouchUp() {
        slider.setValue(1.0, animated: true)
        animator.continueAnimation(withTimingParameters: nil, durationFactor: 1)
    }
}
