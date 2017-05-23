//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Семен Пилюков on 04.04.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    //MARK: Properties
    
    private var ratingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    var rating = 0 {
        didSet {
            updateButtonsSelectionState()
        }
    }
    
    
    //MARK: Initialization
    //You typically create a view in one of two ways: by programatically initializing the view, or by allowing the view to be loaded by the storyboard. There’s a corresponding initializer for each approach: init(frame:) for programatically initializing the view and init?(coder:) for loading the view from the storyboard. Recall that an initializer is a method that prepares an instance of a class for use, which involves setting an initial value for each property and performing any other setup.
   // You will need to implement both of these methods in your custom control. While designing the app, Interface Builder programatically instantiates the view when you add it to the canvas. At runtime, your app loads the view from the storyboard.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    // Furthermore, the subclass must mark their initializers as required, indicating that their subclasses must also implement the initializers.
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button actions
    
    func ratingButtonTapped (button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button \(button) is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents current rating, reset rating to 0
            rating = 0
        } else {
            // Otherwise set rating to the selected star
            rating = selectedRating
        }
    }

    //MARK: Private methods
    
    private func setupButtons () {
        
        // Get rid of old buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images. These lines load the star images from the assets catalog. Note that the assets catalog is located in the app’s main bundle.
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // Create and set buttons
        for index in 0..<starCount {
            
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints (disable auto-constraints and set actual size)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(lessThanOrEqualToConstant: starSize.width).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: (starSize.height / starSize.width)).isActive = true
            
            
            
            // Add Accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the Button Action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating array
            ratingButtons.append(button)
        }
        
        updateButtonsSelectionState()
    }
    
    private func updateButtonsSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            
            // If the index of a button is less than the rating, than button should be selected
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            
            if rating == index + 1 {
                hintString = "Tap to reset rating"
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            
            switch rating {
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "1 star set"
            default:
                valueString = "\(rating) stars set"
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
        }
    }

}
