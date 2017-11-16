//
//  AddTransactionViewController.swift
//  Expenses App
//
//  Created by Nadiia Pavliuk on 09.11.17.
//  Copyright © 2017 Nadiia Pavliuk. All rights reserved.
//

import UIKit
import CoreData

class AddTransactionViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    var titleText = "Add Transaction"
    var budget: Budget? = nil
    var indexPathForBudget: IndexPath? = nil
    var sharedDelegate: AppDelegate!
    var selectedCategory: String?
    let categoriesList = ["Accessories", "Bar", "Books","Credits","Transport", "Clothing",  "Cosmetics", "Events", "Flights", "Furniture", "Family","Fitness", "Gift", "Grocery", "Hairdresser", "Health", "Heritage", "Holiday", "Home", "Investments", "Movie", "Pets","Pension", "Phone", "Rent", "Refunds", "Restaurant", "Shopping", "Sport", "Salary", "Utilities", "Wins", "Other"]
    
    @IBOutlet weak var balanceTextField: UITextField!
   // @IBOutlet weak var descriptionNameTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
 
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentController: UISegmentedControl!

    
    @IBAction func segmentIndexChanged(sender: UISegmentedControl) {
        switch segmentController.selectedSegmentIndex {
        case 0: balanceTextField.text = "-"
        case 1: balanceTextField.text = "+"
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var dateString = dateFormatter.string(from: date as Date)
        dateTextField.text = "\(dateFormatter.string(from: date as Date))"

        createCategoryPicker()
        
        createToolBar()
        
        titleLabel.text = titleText
        scrollView.delegate = self
        func scrollViewDidScroll(_scrollView: UIScrollView) {
            print(scrollView.contentOffset)
        }
        segmentController.selectedSegmentIndex = 0
        balanceTextField.text = "-"
        
        let shDelegate = UIApplication.shared.delegate as! AppDelegate
        sharedDelegate = shDelegate
        
        titleLabel.text = titleText
        if let budget = self.budget {
            descriptionTextField.text = budget.descriptionName
//            descriptionNameTextField.text = budget.descriptionName
            categoryTextField.text = budget.categoryName
            balanceTextField.text = String(budget.balance)
            balanceTextField.textColor = UIColor.red
            dateTextField.text = budget.dateString
            
        }
       

    }
    
    func createCategoryPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.tag = 1
        categoryTextField.inputView = categoryPicker
        categoryPicker.backgroundColor = .black
    }
    

    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        toolBar.barTintColor = .gray
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done",style: .plain, target: self,  action: #selector(AddTransactionViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolBar
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAndClose(_ sender: Any) {
        performSegue(withIdentifier: "unwindToBudgetList", sender: self)
    }
    
    @IBAction func close(_ sender: Any) {
        descriptionTextField.text = nil
//        descriptionNameTextField.text = nil
        balanceTextField.text = nil
        categoryTextField.text = nil
        dateTextField.text = nil
        performSegue(withIdentifier: "unwindToBudgetList", sender: self)
    }

}

extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesList.count

    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesList[row]

        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categoriesList[row]
        categoryTextField.text = selectedCategory

    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel

        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = .white
        label.textAlignment = .center
        label.text = categoriesList[row]
        return label
    }
   
}
extension Date {
    func format(format:String = "dd/MM/yyyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        if let newDate = dateFormatter.date(from: dateString) {
            return newDate
        } else {
            return self
        }
    }
}
