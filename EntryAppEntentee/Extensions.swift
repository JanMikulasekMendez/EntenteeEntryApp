//
//  Extensions.swift
//  EntryAppEntentee
//
//  Created by Jan Mikulášek on 27.12.2021.
//

import Foundation
import UIKit

// Downlaod image into view from URL
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


// Make rounded Image
extension UIImageView {

    func makeRounded(radius: CGFloat = 0.0) {

        var r = 0.0
        if radius == 0 {r = self.frame.height / 2}
        else {r = radius}
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = r
        self.clipsToBounds = true
    }
}


// Autolayout autoanchors
extension UIView {
    
    func anchorList(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?,centerY: NSLayoutYAxisAnchor? = nil, centerX: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraintList = [NSLayoutConstraint]()
        
        if let top = top {
            constraintList.append(topAnchor.constraint(equalTo: top, constant: padding.top))
        }
        
        if let leading = leading {
            constraintList.append(leadingAnchor.constraint(equalTo: leading, constant: padding.left))
        }
        
        if let bottom = bottom {
            constraintList.append(bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom))
        }
        
        if let trailing = trailing {
            constraintList.append(trailingAnchor.constraint(equalTo: trailing, constant: -padding.right))
        }
        
        if let centerY = centerY {
            constraintList.append(centerYAnchor.constraint(equalTo: centerY))
        }
        
        if let centerX = centerX {
            constraintList.append(centerXAnchor.constraint(equalTo: centerX))
        }
        
        if size.width != 0 {
            let w = widthAnchor.constraint(equalToConstant: size.width)
            w.priority = UILayoutPriority.init(rawValue: 800)
            constraintList.append(w)
        }
        
        if size.height != 0 {
            let h = heightAnchor.constraint(equalToConstant: size.height)
            h.priority = UILayoutPriority.init(rawValue: 800)
            constraintList.append(h)
        }
        
        return constraintList
    }
}

// Navigation extension
extension UIViewController {

    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        present(viewControllerToPresent, animated: false)
    }

    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)

        dismiss(animated: false)
    }
}
