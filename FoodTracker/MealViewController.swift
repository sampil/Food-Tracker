//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Семен Пилюков on 02.04.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Prorerties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
    }
	
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Desable Savebutton while editing
        saveButton.isEnabled = false
    }
    
    //MARK: UIImagePickerControllerDelegate 
    
    //"When a user taps the image view, they should be able to choose a photo from a collection of photos, or take one of their own. Fortunately, the UIImagePickerController class has this behavior built into it. An image picker controller manages the user interface for taking pictures and for choosing saved images to use in your app. And just as you need a text field delegate when you work with a text field, you need an image picker controller delegate to work with an image picker controller. The name of that delegate protocol is UIImagePickerControllerDelegate, and the object that you’ll define as the image picker controller’s delegate is ViewController. Because ViewController will be in charge of presenting the image picker controller, it also needs to adopt the UINavigationControllerDelegate protocol, which simply lets ViewController take on some basic navigation responsibilities.")
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss the picker if the user cancelled
        dismiss(animated: true, completion: nil)
    }
    
    // imagePickerController gets called when a user selects a photo.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        // This code creates a Boolean value that indicates whether the view controller that presented this scene is of type UINavigationController. As the constant name isPresentingInAddMealMode indicates, this means that the meal detail scene is presented by the user tapping the Add button. This is because the meal detail scene is embedded in its own navigation controller when it’s presented in this manner, which means that the navigation controller is what presents it.
        let isPresentedinAddMealMode = presentingViewController is UINavigationController
        
        if isPresentedinAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller")
        }
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller thats lets a user pick media from their photo library.
        let imagePickerConroller = UIImagePickerController()
        
        // Only allows photo to be picked not taken
        imagePickerConroller.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user piks an image
        imagePickerConroller.delegate = self
        
        // The method asks ViewController to present the view controller defined by imagePickerController.
        // After an image picker controller is presented, you interact with it through the delegate methods.
        present(imagePickerConroller, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState () {
        
        // Disable the Save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

