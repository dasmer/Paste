//
//  SearchView.swift
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import UIKit

protocol SearchViewDelegate: class {
    func searchView(searchView: SearchView, didChangeText text: String)
    func searchViewWillClearText(searchView: SearchView)
}

final class SearchView: UIView {

    // MARK: - Properties

    weak var delegate: SearchViewDelegate?

    var text: String? {
        get {
            return textField.text
        }

        set {
            textField.text = newValue
        }
    }

    var placeholder: String? {
        get {
            return textField.placeholder
        }

        set {
            textField.placeholder = newValue
        }
    }

    private let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .WhileEditing
        textField.autocapitalizationType = .None
        textField.autocorrectionType = .No
        return textField
    }()


    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textField)
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textField]-|", options: [], metrics: nil, views: ["textField":textField])
            + [NSLayoutConstraint(item: textField, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)]
        NSLayoutConstraint.activateConstraints(constraints)

        textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    @objc private func textFieldDidChange(sender: AnyObject?) {
        delegate?.searchView(self, didChangeText: textField.text ?? "")
    }

}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldClear(textField: UITextField) -> Bool {
        delegate?.searchViewWillClearText(self)
        return true
    }
}


extension SearchView {


    // MARK: - UIResponder

    override func canBecomeFirstResponder() -> Bool {
        return textField.canBecomeFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    override func canResignFirstResponder() -> Bool {
        return textField.canResignFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    override func isFirstResponder() -> Bool {
        return textField.isFirstResponder()
    }
}
