//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Семен Пилюков on 02.04.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    //MARK: Meal Class Tests
    
    // Confirm that the meal initializer returns a Meal object when passed valid paremters
    func testMealInitializationSucceds() {
        
        // Zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Hughrst positive rating
        let positiveRatingMeal = Meal(name: "Max", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    //Confirm that the meal initializer returns nil object when passed no name or negative rating
    func testMealInitializationFails() {
        
        // Rating exceeds maximum
        let largeRatingMeal = Meal(name: "Exeed", photo: nil, rating: 9)
        XCTAssertNil(largeRatingMeal)
        
        // No name
        let noNameMeal = Meal(name: "", photo: nil, rating: 1)
        XCTAssertNil(noNameMeal)
        
        // Negative rating
        let negativeRatingMeal = Meal(name: "Negative", photo: nil, rating: -3)
        XCTAssertNil(negativeRatingMeal)
        
    }
}
