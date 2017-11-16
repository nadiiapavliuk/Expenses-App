//
//  TransactionsViewController.swift
//  Expenses App
//
//  Created by Nadiia Pavliuk on 09.11.17.
//  Copyright © 2017 Nadiia Pavliuk. All rights reserved.
//

import UIKit
import CoreData

class TransactionsViewController: UITableViewController {
    var sharedDelegate: AppDelegate!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    var budgets: [Budget] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Data Source
    
    func fetch() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Budget")
        do {
            budgets = try managedObjectContext.fetch(fetchRequest) as! [Budget]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
    }
    
    func save(categoryName: String, descriptionName: String, balance: Double, dateString: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName:"Budget", in: managedObjectContext) else { return }
        let budget = Budget(entity: entity, insertInto: managedObjectContext)
        budget.setValue(categoryName, forKey: "categoryName")
        budget.setValue(descriptionName, forKey: "descriptionName")
        budget.setValue(Double(balance), forKey: "balance")
        budget.setValue(dateString, forKey: "dateString")

        
        do {
            try managedObjectContext.save()
            self.budgets.append(budget)
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
    }
    
    func update(indexPath: IndexPath,categoryName: String, descriptionName:String, balance: Double, dateString: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let budget = budgets[indexPath.row]
        budget.setValue(categoryName, forKey: "categoryName")
        budget.setValue(descriptionName, forKey:"descriptionName")
        budget.setValue(Double(balance), forKey: "balance")
        budget.setValue(dateString, forKey: "dateString")
        //budget.setValue(dateCreated, forKey: "dateCreated")
        
        do {
            try managedObjectContext.save()
            budgets[indexPath.row] = budget
        } catch let error as NSError {
            print("Couldn't update. \(error)")
        }
    }
    
    func delete(_ budget: Budget, at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        managedObjectContext.delete(budget)
        
        let budget = budgets[indexPath.row]
        
        do {
            try managedObjectContext.save()
            budgets[indexPath.row] = budget
            budgets.remove(at: indexPath.row)
        } catch let error as NSError {
            print("Couldn't update. \(error)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sum = 0.0
        
        for item in budgets {
            sum += Double(item.balance)
        }
        
        totalAmountLabel.text = "Total Amount: \(sum)"
        
        return budgets.count
        
    }
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath)
        
        let budget = budgets[indexPath.row]
        cell.textLabel?.text = budget.categoryName! + "\n" + String(describing: budget.dateString!) + "\n" + budget.descriptionName! 

        cell.detailTextLabel?.text = " $ \(String(budget.balance))"
        
    
        return cell
    }
    
   

    
    @IBAction func unwindToBudgetList(segue: UIStoryboardSegue) {
        if let viewController = segue.source as? AddTransactionViewController {
            guard
                let categoryName: String = viewController.categoryTextField.text,
//                let descriptionName: String = viewController.descriptionNameTextField.text,
                 let descriptionName: String = viewController.descriptionTextField.text,
                let balanceString = viewController.balanceTextField.text,
                let balance = Double(balanceString),
                
                let dateString = viewController.dateTextField.text
            
                else { return }
            if descriptionName != "" && categoryName != ""  {
                if let indexPath = viewController.indexPathForBudget {
                    update(indexPath: indexPath, categoryName: categoryName, descriptionName: descriptionName, balance: balance, dateString: dateString)
                } else {
                    save(categoryName: categoryName, descriptionName: descriptionName, balance: balance, dateString: dateString )
                }
            }
            tableView.reloadData()
        } else if let viewController = segue.source as? DetailTransactionsViewController {
            if viewController.isDeleted {
                guard let indexPath: IndexPath = viewController.indexPath else { return }
                let budget = budgets[indexPath.row]
                delete(budget, at: indexPath)
                tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "budgetDetailSegue" {
            guard let navViewController = segue.destination as? UINavigationController else { return }
            guard let viewController = navViewController.topViewController as? DetailTransactionsViewController else { return }
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let budget = budgets[indexPath.row]
            viewController.budget = budget
            viewController.indexPath = indexPath
        }
    }
   
    
    
}
