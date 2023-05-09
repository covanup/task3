/// КОПИПАСТА ОТСЮДА https://github.com/dimshraj/SparrowMarathonTask3 т.к. сейчас нет времени
/// Нормальное решение на UIViewPropertyAnimator сделаю позже 😅

import UIKit

final class ViewController: UIViewController {
    let slider = UISlider()
    
    let gradientView = UIView()
    var originViewSize: CGRect = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        setupLayers()
    }
    
    private func setupViews() {
        view.addSubview(gradientView)
        view.addSubview(slider)
        
        slider.addTarget(self, action: #selector(animate), for: .touchDragInside)
        slider.addTarget(self, action: #selector(animate), for: .touchDragOutside)
        slider.addTarget(self, action: #selector(animateSlider), for: .touchUpInside)
        
        self.view.backgroundColor = .white
    }
       
    @objc func animateSlider() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [self] timer in
            let range =  slider.maximumValue - slider.minimumValue
            let increment = range/100
            let newval = slider.value + increment
            if increment <= slider.maximumValue && slider.value != slider.maximumValue {
                slider.setValue(newval, animated: true)
                animate()
            } else {
                timer.invalidate()
            }
        }
    }

    @objc func animate() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveLinear],
            animations: { [self] in
                let first = CGAffineTransform(rotationAngle: (.pi / 2) * CGFloat(slider.value))
                let second = CGAffineTransform(scaleX: 1 + CGFloat(slider.value / 2), y: 1 + CGFloat(slider.value / 2))
                let third = CGAffineTransform(translationX: originViewSize.minX + (CGFloat(slider.value) * ((view.frame.width - 8) - gradientView.frame.width)), y: originViewSize.minY + CGFloat(CGFloat(slider.value) * ((gradientView.frame.width - originViewSize.width) / 2)))
                gradientView.transform = CGAffineTransformConcat(CGAffineTransformConcat(second, first), third )
            }
        )
    }
    
    private func configureConstraints() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientView.widthAnchor.constraint(equalToConstant: 100),
            gradientView.heightAnchor.constraint(equalToConstant: 100),
            gradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            gradientView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            slider.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 216),
            slider.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func setupLayers() {
        gradientView.clipsToBounds = true
        gradientView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        gradientView.layer.shadowOffset = .init(width: 5, height: 10)
        gradientView.layer.shadowRadius = 12
        gradientView.layer.cornerRadius = 12
        self.originViewSize = gradientView.bounds
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.systemCyan.cgColor, UIColor.systemPink.cgColor]
        gradient.frame = gradientView.layer.bounds
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
}
