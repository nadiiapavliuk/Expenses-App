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
    var myCurrency: [String] = []
    var myValues: [Double] = []
    var activeCurrency: Double = 0
    
    
    var titleText = "Add Transaction"
    var budget: Budget? = nil
    var indexPathForBudget: IndexPath? = nil
    var sharedDelegate: AppDelegate!
    var selectedCategory: String?
    let categoriesList = ["Accessories", "Bar", "Books","Credits","Transport", "Clothing",  "Cosmetics", "Events", "Flights", "Furniture", "Family","Fitness", "Gift", "Grocery", "Hairdresser", "Health", "Heritage", "Holiday", "Home", "Investments", "Movie", "Pets","Pension", "Phone", "Rent", "Refunds", "Restaurant", "Shopping", "Sport", "Salary", "Utilities", "Wins", "Other"]
    
    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var descriptionNameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var currencyTextField: UITextField!
    
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var output: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
   
    
//    @IBAction func converter(_ sender: UIButton) {
//        performSegue(withIdentifier: "converter", sender: self)
//    }
//
    
    @IBAction func segmentIndexChanged(sender: UISegmentedControl) {
        switch segmentController.selectedSegmentIndex {
        case 0: balanceTextField.text = "-"
        case 1: balanceTextField.text = "+"
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCurrencyPicker()
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
            descriptionNameTextField.text = budget.descriptionName
            categoryTextField.text = budget.categoryName
            balanceTextField.text = String(budget.balance)
            balanceTextField.textColor = UIColor.red
            
        }
        //=======
//        let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=93a6c3571d924f8b84b06e5dd613c237")
                let url = URL(string: "http://www.floatrates.com/daily/usd.json")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let rates = myJson["rates"] as? NSDictionary
                        {
                            for (key, value) in rates
                            {
                                self.myCurrency.append((key as? String)!)
                                self.myValues.append((value as? Double)!)
                                DispatchQueue.main.async {
                                    self.reloadInputViews()
                                    //pickerView.reloadAllComponents()
                                }
                            }
                        }
                    }
                    catch
                    {
                        
                    }
                }
            }
            
        }
        task.resume()
        //==========
    }
    
    func createCategoryPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.tag = 1
        categoryTextField.inputView = categoryPicker
        categoryPicker.backgroundColor = .black
    }
    
    func createCurrencyPicker() {
        let currencyPicker = UIPickerView()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.tag = 2
        currencyTextField.inputView = currencyPicker
        currencyPicker.backgroundColor = .black
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
        currencyTextField.inputAccessoryView = toolBar
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
        descriptionNameTextField.text = nil
        balanceTextField.text = nil
        categoryTextField.text = nil
        performSegue(withIdentifier: "unwindToBudgetList", sender: self)
    }
    @IBAction func convertCurrency(_ sender: UIButton) {
        if (input.text != "") {
            output.text = String(Double(input.text!)! / activeCurrency)
        }
    }
}

extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return categoriesList.count
        if pickerView.tag == 1 {
            return categoriesList.count
            
        } else if pickerView.tag == 2{
            return myCurrency.count
        }
    
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return categoriesList[row]
        if pickerView.tag == 1 {
            return categoriesList[row]
        } else if pickerView.tag == 2 {
            return myCurrency[row]
        }
        return ""
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedCategory = categoriesList[row]
//        categoryTextField.text = selectedCategory
        if pickerView.tag == 1 {
            categoryTextField.text = categoriesList[row]
//            self.view.endEditing(false)
        } else if pickerView.tag == 2 {
            currencyTextField.text = myCurrency[row]
//            self.view.endEditing(false)
        }
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
