//
//  DetailTransactionsViewController.swift
//  Expenses App
//
//  Created by Nadiia Pavliuk on 09.11.17.
//  Copyright © 2017 Nadiia Pavliuk. All rights reserved.
//

import UIKit
import CoreData
class DetailTransactionsViewController: UIViewController {
    
    var budget: Budget? = nil
    var isDeleted: Bool = false
    var indexPath: IndexPath? = nil
   
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryNameLabel.text = budget?.categoryName
        descriptionNameLabel.text = budget?.descriptionName
        balanceLabel.text = String(describing: budget!.balance)
        dateLabelDescription.text = String(describing: budget!.dateString!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var dateLabelDescription: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var descriptionNameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: "unwindToBudgetList", sender: self)
    }
    
    
    @IBAction func deleteBudget(_ sender: Any) {
        isDeleted = true
        performSegue(withIdentifier: "unwindToBudgetList", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editBudget" {
            guard let viewController = segue.destination as? AddTransactionViewController else { return }
            viewController.budget = budget
            viewController.indexPathForBudget = self.indexPath!
            
        }
    }
    
}


