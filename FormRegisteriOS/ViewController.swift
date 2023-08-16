//
//  ViewController.swift
//  FormRegisteriOS
//
//  Created by Montserrat Medina on 2023-08-16.
//

import UIKit

class ViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    let locale = Locale(identifier: "es-PY")
    
    let sexList = ["Feminine", "Masculine"]
    let maritalStatusList = ["Single", "Married", "Widowed", "Divorced", "Separated"]
    
    let sexPickerView = UIPickerView()
    let maritalStatusPickerView = UIPickerView()
    
    @IBOutlet weak var birthdateField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    @IBOutlet weak var maritalField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var rucField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createDatePicker()
        bindingPickerView()
        bindingTextField()
    }
    
    func bindingPickerView(){
        sexField.inputView = sexPickerView
        maritalField.inputView = maritalStatusPickerView
        
        sexPickerView.delegate = self
        sexPickerView.dataSource = self
        sexPickerView.tag = 1
        
        maritalStatusPickerView.delegate = self
        maritalStatusPickerView.dataSource = self
        maritalStatusPickerView.tag = 2
    }
    
    func bindingTextField(){
        phoneField.delegate = self
        emailField.delegate = self
        rucField.delegate = self
    }
    
    func createToolbar () -> UIToolbar {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePressed))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    func createDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = self.locale
        datePicker.datePickerMode = .date
        birthdateField.inputView = datePicker
        birthdateField.inputAccessoryView = createToolbar()
    }
    
    @objc func doneDatePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = self.locale
        
        birthdateField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
  
    
    
    
   
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            return sexList.count
        case 2:
            return maritalStatusList.count
        default:
            return 1
        }
    }
    
    //title for row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return sexList[row]
        case 2:
            return maritalStatusList[row]
        default:
            return "Data not found"
        }
    }
    
    //didSelect
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            sexField.text = sexList[row]
            sexField.resignFirstResponder()
        case 2:
            maritalField.text = maritalStatusList[row]
            maritalField.resignFirstResponder()
        default:
            return
        }
    }
    
    
}

extension ViewController: UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case phoneField:
            print("es phone")
            phoneValidation()
            break
        case emailField:
            emailValidation()
            print("es email")
            return true
        case rucField:
            rucValidation()
            print("es ruc")
            return true
        default:
            return false
        }
        
        return false
    }
    
    func phoneValidation(){
        if self.phoneField.text?.prefix(2) != "09" {
            showIncorrectAlert(title: "Provide a valid phone number")
        }else{
            self.phoneField.resignFirstResponder()
            //Colocar siguiente
            self.emailField.becomeFirstResponder()
        }
    }
    
    func emailValidation(){
        let emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+"
        
        if !matchRegex(text: self.emailField.text ?? "", pattern: emailPattern) {
            showIncorrectAlert(title: "Provide a valid email")
        }else{
            self.phoneField.resignFirstResponder()
            //Colocar siguiente
            self.rucField.becomeFirstResponder()
        }
        
    }
    
    func rucValidation(){
        let rucPattern = "[0-9]+-[0-9]"
        
        if !matchRegex(text: self.rucField.text ?? "", pattern: rucPattern) {
            showIncorrectAlert(title: "Provide a valid email")
        }else{
            self.phoneField.resignFirstResponder()
            //Colocar siguiente
            self.rucField.becomeFirstResponder()
        }
    }
    
    func matchRegex(text:String, pattern:String) -> Bool {
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: text.count)
            
            if regex.firstMatch(in: text, options: [], range: range) != nil {
                return true
            }else {
                return false
            }
            
        }catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    func showIncorrectAlert(title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(dismiss)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

