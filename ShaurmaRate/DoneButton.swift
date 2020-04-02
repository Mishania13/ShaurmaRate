//
//  DoneButton.swift
//  ShaurmaRate
//
//  Created by Mr. Bear on 29.03.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit
extension UITextField{

       @IBInspectable var doneAccessory: Bool{
        get{ return self.doneAccessory}
        set (hasDone) { if hasDone {addDoneButtonOnKeyboard()} }
    }

    func addDoneButtonOnKeyboard()

    { let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))

        doneToolbar.barStyle = .default
 
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {self.resignFirstResponder()}
}
