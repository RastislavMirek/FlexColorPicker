//
//  UIViewExtension.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 27/5/18.
//  
//	MIT License
//  Copyright (c) 2018 Rastislav Mirek
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

extension UIView {
    func addAutolayoutFillingSubview(_ subview: UIView, edgeInsets: UIEdgeInsets = .zero) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)

        subview.leftAnchor.constraint(equalTo: leftAnchor, constant: edgeInsets.left).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top).isActive = true
        subview.rightAnchor.constraint(equalTo: rightAnchor, constant: -edgeInsets.right).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -edgeInsets.bottom).isActive = true
    }

    func addAutolayoutCentredView(_ subview: UIView, offset: CGSize = .zero) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)

        subview.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset.width).isActive = true
        subview.centerYAnchor.constraint(equalTo: centerYAnchor, constant: offset.height).isActive = true
    }

    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    var borderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @objc
    var cornerRadius_: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
