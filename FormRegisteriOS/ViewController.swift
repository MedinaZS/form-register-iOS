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
    @IBOutlet weak var registerButton: UIButton!
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
        birthdateField.inputAccessoryView = createToolbar(#selector(doneDatePressed))
        
        sexField.inputAccessoryView = createToolbar(#selector(doneSexPressed))
        maritalField.inputAccessoryView = createToolbar(#selector(doneMaritalPressed))
        
        sexPickerView.delegate = self
        sexPickerView.dataSource = self
        sexPickerView.tag = 1
        
        maritalStatusPickerView.delegate = self
        maritalStatusPickerView.dataSource = self
        maritalStatusPickerView.tag = 2
    }
    
    func bindingTextField(){
        phoneField.delegate = self
        phoneField.inputAccessoryView = createToolbar(#selector(phoneValidation))
        
        emailField.delegate = self
        
        rucField.delegate = self
        rucField.inputAccessoryView = createToolbar(#selector(rucValidation))
    }
    
    func createToolbar (_ myAction : Selector) -> UIToolbar {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: myAction)
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    
    
    func createDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = self.locale
        datePicker.datePickerMode = .date
        birthdateField.inputView = datePicker
        birthdateField.inputAccessoryView = createToolbar(#selector(doneDatePressed))
    }
    
    @objc func doneDatePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = self.locale
        
        birthdateField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        //Focus en el siguiente
        sexField.becomeFirstResponder()
        
    }
    
    @objc func doneSexPressed(){
        let row = self.sexPickerView.selectedRow(inComponent: 0)
        sexField.text = sexList[row]
        //Focus siguiente
        maritalField.becomeFirstResponder()
    }
    
    @objc func doneMaritalPressed(){
        let row = self.maritalStatusPickerView.selectedRow(inComponent: 0)
        maritalField.text = maritalStatusList[row]
        //Focus siguiente
        phoneField.becomeFirstResponder()
    }

    
    @IBAction func sendData(_ sender: Any) {
        //Validate fields
        
        if !validateFields() {
            showIncorrectAlert(title: "Completa todos los campos")
        }else {
            print("Cumple \(birthdateField.text!)")
            print("Sexo \(sexField.text!)")
            print("Marital " + maritalField.text!)
            print("Phone \(phoneField.text!) ")
            print("Email \(emailField.text!) ")
            print("Ruc \(rucField.text!) ")
        }
        
    }
    
    func validateFields() -> Bool {
        if birthdateField.text == "" {
            return false
        }else if sexField.text == "" {
            return false
        }else if maritalField.text == "" {
            return false
        }else if phoneField.text == "" {
            return false
        }else if emailField.text == "" {
            return false
        }else if rucField.text == "" {
            return false
        }
        return true
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
    
    
}

extension ViewController: UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailField:
            emailValidation()
        default:
            return false
        }
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneField && string.count > 1{
            //User did copy & paste
            //Dejar solo numeros
            let result = string.filter("0123456789".contains)
            phoneField.text = result
            return false
        }
        
        return true
    }
    
    @objc func phoneValidation(){
        let text = self.phoneField.text!.trimmingCharacters(in: [" "])
        print("Es un numero \(String(describing: Int(text)))")
        
        
        if text.prefix(2) != "09" || Int(text) == nil {
            showIncorrectAlert(title: "Provide a valid phone number")
        }else{
            print("entra")
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
    
    @objc func rucValidation(){
        let rucPattern = "[0-9]+-[0-9]"
        if !matchRegex(text: self.rucField.text ?? "", pattern: rucPattern) {
            showIncorrectAlert(title: "Provide a valid ruc number")
        }else{
            self.rucField.resignFirstResponder()
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



