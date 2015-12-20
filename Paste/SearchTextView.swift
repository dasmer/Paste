//
//  SearchTextView.swift
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import UIKit

class SearchTextView: UIView {

    // MARK: - Properties

    private let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Emoji name"
        textField.clearButtonMode = .WhileEditing
        return textField
    }()


    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textField)
        let constraints = [
            NSLayoutConstraint(item: textField, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: textField, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: textField, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        ]
        NSLayoutConstraint.activateConstraints(constraints)

        textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    @objc private func textFieldDidChange(sender: AnyObject?) {
        
    }

}



extension SearchTextView {


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
