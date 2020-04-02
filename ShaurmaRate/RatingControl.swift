//
//  RatingControl.swift
//  ShaurmaRate
//
//  Created by Mr. Bear on 01.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: - properties
  
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }

    private var buttons = [UIButton]()
    
    @IBInspectable var starSize:CGSize = CGSize(width: 44, height: 44) {
        didSet {
            setupButton()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButton()
        }
    }
    
    //MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    //MARK: - button actions
    @objc func buttonTapped (button: UIButton) {
        guard let index = buttons.firstIndex(of: button) else {return}
        
        //calculate rating
        let selectRating = index + 1
        if selectRating == rating {
            rating = 1
        } else {
            rating = selectRating
        }
    }
    //MARK: - private metods
    private func setupButton () {
        for button in buttons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        buttons.removeAll()
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        
        let highLitedStar = UIImage(named: "highLitedStar",
                                    in: bundle,
                                    compatibleWith:
            self.traitCollection)
        
        
        for _ in 1...starCount {
            let button = UIButton()
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highLitedStar, for: .highlighted)
            button.setImage(highLitedStar, for: [.focused, .highlighted])
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //actions
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            buttons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates () {
        for(index, button) in buttons.enumerated(){
            button.isSelected = index < rating
        }
    }
    
}
