//
//  Budget+CoreDataProperties.swift
//  Expenses App
//
//  Created by Nadiia Pavliuk on 09.11.17.
//  Copyright © 2017 Nadiia Pavliuk. All rights reserved.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    
   
    @NSManaged public var categoryName: String?
    @NSManaged public var balance: Double
    @NSManaged public var barGraphColor: Int
    @NSManaged public var descriptionName: String?
    @NSManaged public var historyArray: [String]
    @NSManaged public var markerLatitude: [Double]
    @NSManaged public var markerLongitude: [Double]
    @NSManaged public var amountSpentOnDate: [String: Double]
    

}
