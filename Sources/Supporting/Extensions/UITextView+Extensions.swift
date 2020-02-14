//
//  UITextView+Extensions.swift
//  Desk360
//
//  Created by samet on 18.05.2019.
//

import UIKit

extension UITextView {

	/// Creates and returns a new UITextView with setting its properties in one line.
	///
	/// - Parameters:
	///   - font: The font of the text _(default is system font)_.
	///   - textColor: The color of the text _(default is .black)_.
	///   - isEditable: A Boolean value indicating whether the receiver is editable _(default is true)_.
	///   - allowsEditingTextAttributes: A Boolean value indicating whether the text view allows the user to edit style information _(default is false)_.
	///   - textAlignment: The technique to use for aligning the text _(default is .natural)_.
	///   - textContainerInset: The inset of the text container's layout area within the text view's content area _(default is nil)_.
	///   - backgroundColor: The text-view's background color _(default is nil)_.
	///   - tintColor: Text color of the view _(default is nil)_.
	/// - Returns: UITextView.
	static func create(
		font: UIFont? = nil,
		textColor: UIColor? = .black,
		isEditable: Bool = true,
		allowsEditingTextAttributes: Bool = false,
		textAlignment: NSTextAlignment = .natural,
		textContainerInset: UIEdgeInsets? = nil,
		backgroundColor: UIColor? = nil,
		tintColor: UIColor? = nil) -> UITextView {

		let view = UITextView()

		if let aFont = font {
			view.font = aFont
		}

		view.textColor = textColor
		view.isEditable = isEditable
		view.allowsEditingTextAttributes = allowsEditingTextAttributes
		view.textAlignment = textAlignment

		if let inset = textContainerInset {
			view.textContainerInset = inset
		}

		if let color = backgroundColor {
			view.backgroundColor = color
		}

		if let color = tintColor {
			view.tintColor = color
		}

		return view
	}

	/// text field's text trimming whitespaces and new lines.
	var trimmedText: String? {
		let aText = self.text.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !aText.isEmpty else { return nil }
		return aText
	}

	/// Check if text view is empty.
	var isEmpty: Bool {
		return trimmedText == nil
	}

	@IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

	@objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }

}
