//
//  UIView+Extension.swift
//  Popovers
//
//  Copyright © 2021 PSPDFKit GmbH. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIView {
  public func closestVC() -> UIViewController? {
    var responder: UIResponder? = self
    while responder != nil {
        if let vc = responder as? UIViewController {
            return vc
        }
        responder = responder?.next
    }
    return nil
  }
}
#endif
