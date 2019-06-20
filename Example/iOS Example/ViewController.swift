//
//  ViewController.swift
//  AnyFormatKit
//
//  Created by luximetr on 10/31/2017.
//  Copyright (c) 2017 luximetr. All rights reserved.
//

import UIKit
import AnyFormatKit

class ViewController: UIViewController {
  // MARK: - Fields
  let phoneNumberFieldController = TextInputController()
  let cardNumberFieldController = TextInputController()
  let sumInputController = TextInputController()
  let phoneNumberField = UITextField(frame: LayoutConstants.textInputFieldFrame)
  let cardNumberView = UITextView(frame: LayoutConstants.textInputViewFrame)
  let sumInputField = UITextField(frame: LayoutConstants.sumTextInputFieldFrame)
  
  let phoneNumberFormatter = DefaultTextInputFormatter(textPattern: "### (###) ###-##-##")
  let cardNumberFormatter = DefaultTextInputFormatter(textPattern: "XXXX XXXX XXXX XXXX", patternSymbol: "X")
  let sumFormatter = SumTextInputFormatter(textPattern: "#.###,# $")
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initConfigure()
    
    let numberFormatter = NumberFormatter()
    numberFormatter.groupingSize = 4
    let formatter = SumTextInputFormatter(numberFormatter: numberFormatter)
    let result = formatter.formatInput(currentText: "222", range: NSRange(location: 0, length: 0), replacementString: "1")
    print(result)
    print("")
  }
}

extension ViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    print("CALLED")
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    print("REASON")
  }
}

// MARK: - Private
private extension ViewController {
  func initConfigure() {
    configureSelfView()
    configureTitleLabels()
    configureTextFields()
    configureTextView()
    configureFormatters()
    configureTextFieldControllers()
    configureTextViewController()
    setupFirstResponder()
  }
  
  func configureSelfView() {
    view.backgroundColor = UIColor.black
  }
  
  func configureTitleLabels() {
    let phoneNumberTitleLabel = UILabel(frame: LayoutConstants.phoneNumberLabelFrame)
    phoneNumberTitleLabel.textColor = UIColor.white
    phoneNumberTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular )
    phoneNumberTitleLabel.text = "Phone number: "
    
    let cardNumberTitleLabel = UILabel(frame: LayoutConstants.cardNumberLabelFrame)
    cardNumberTitleLabel.textColor = UIColor.white
    cardNumberTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    cardNumberTitleLabel.text = "Card number: "
    
    let sumTitleLabel = UILabel(frame: LayoutConstants.sumLabelFrame)
    sumTitleLabel.textColor = UIColor.white
    sumTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    sumTitleLabel.text = "Enter sum: "
    
    view.addSubview(phoneNumberTitleLabel)
    view.addSubview(cardNumberTitleLabel)
    view.addSubview(sumTitleLabel)
  }
  
  func configureTextFields() {
    configurePhoneNumberField()
    configureSumInputField()
  }
  
  func configurePhoneNumberField() {
    view.addSubview(phoneNumberField)
    phoneNumberField.backgroundColor = UIColor.black
    phoneNumberField.tintColor = ColorConstants.gray
    
    phoneNumberField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary([
      NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
      NSAttributedString.Key.font.rawValue: UIFont.systemFont(ofSize: 22, weight: .regular)])
  }
  
  func configureSumInputField() {
    view.addSubview(sumInputField)
    sumInputField.backgroundColor = UIColor.black
    sumInputField.tintColor = ColorConstants.gray
    
    sumInputField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    sumInputField.defaultTextAttributes = [
      NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
      NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 22, weight: .regular)]
  }

  @objc
  func textDidChange(_ field: UITextField) {
    print("textDidChange \(field)")
  }
  
  func configureTextView() {
    configureCardNumberView()
  }
  
  func configureCardNumberView() {
    view.addSubview(cardNumberView)
    cardNumberView.backgroundColor = UIColor.black
    cardNumberView.tintColor = ColorConstants.gray
  }
  
  func configureFormatters() {
//    phoneNumberFormatter.allowedSymbolsRegex = "[0-9]"
//    cardNumberFormatter.allowedSymbolsRegex = "[0-9]"
//    sumFormatter.allowedSymbolsRegex = "[0-9.,]"
  }
  
  func configureTextFieldControllers() {
    phoneNumberFieldController.setTextInput(phoneNumberField)
    phoneNumberFieldController.formatter = phoneNumberFormatter
    phoneNumberFieldController.observer.addSubscriber(self)
    phoneNumberFieldController.prefix = "+12"
    phoneNumberFieldController.allowedSymbolsRegex = "[0-9]"
    
    sumInputController.setTextInput(sumInputField)
    sumInputController.formatter = sumFormatter
    sumInputField.text = sumFormatter.format(text: "")
  }
  
  func configureTextViewController() {
    cardNumberFieldController.setTextInput(cardNumberView)
    cardNumberFieldController.formatter = cardNumberFormatter
    
    cardNumberFieldController.setAndFormatText("4111012345672390")
    cardNumberView.typingAttributes = [
      NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 22, weight: .regular),
      NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
  }
  
  func configureFormatters() {
    
  }
  
  func configureTextFieldControllers() {
    phoneNumberField.delegate = textInputFieldController
    textInputFieldController.formatter = phoneNumberFormatter
    
    sumInputField.delegate = sumInputController
    sumInputController.formatter = sumFormatter
  }
  
  func configureTextViewController() {
    cardNumberView.delegate = textInputViewController
    textInputViewController.formatter = cardNumberFormatter
  }
  
  func setupFirstResponder() {
    _ = phoneNumberField.becomeFirstResponder()
  }
}

// MARK: - TextInputDelegate
extension ViewController: TextInputDelegate {
  func textInputDidBeginEditing(_ textInput: TextInput) {
    print("textInputDidBeginEditing")
  }
  
  func textInputShouldBeginEditing(_ textInput: TextInput) -> Bool {
    return true
  }
  
  func textInput(_ textInput: TextInput, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    print("shouldChange \((textInput.text ?? ""))")
    return true
  }
}

// MARK: - TextInputControllerObserver
extension ViewController: TextInputControllerObserver {
  func textInputWillBeginEditing(textInput: TextInput, controller: TextInputController) {
    print("textInputWillBeginEditing")
  }
  
  func textInputDidBeginEditing(textInput: TextInput, controller: TextInputController) {
    print("textInputDidBeginEditing")
  }
  
  func textInputWillEndEditing(textInput: TextInput, controller: TextInputController) {
    print("textInputWillEndEditing")
  }
  
  func textInputDidEndEditing(textInput: TextInput, controller: TextInputController) {
    print("textInputDidEndEditing")
  }
  
  func textInputDidChangeText(textInput: TextInput, controller: TextInputController) {
    print("textInputDidChangeText")
  }
}

// MARK: - Constants
private struct LayoutConstants {
  static let textInputFieldFrame = CGRect(x: 20, y: 65, width: UIScreen.main.bounds.width - 40, height: 40)
  static let textInputViewFrame = CGRect(x: 16, y: 165, width: UIScreen.main.bounds.width - 40, height: 40)
  static let sumTextInputFieldFrame = CGRect(x: 20, y: 265, width: UIScreen.main.bounds.width - 40, height: 40)
  static let phoneNumberLabelFrame = CGRect(x: 20, y: 40, width: UIScreen.main.bounds.width - 40, height: 20)
  static let cardNumberLabelFrame = CGRect(x: 20, y: 140, width: UIScreen.main.bounds.width - 40, height: 20)
  static let sumLabelFrame = CGRect(x: 20, y: 240, width: UIScreen.main.bounds.width - 40, height: 20)
}

private struct ColorConstants {
  static let yellow = UIColor(red: 255 / 255, green: 236 / 255, blue: 0 / 255, alpha: 1.0)
  static let gray = UIColor(red: 63 / 255, green: 63 / 255, blue: 63 / 255, alpha: 1.0)
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})

class TextInputController: NSObject, UITextFieldDelegate {
  
  var formatter: TextInputFormatter?
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    print(textField.text ?? "")
    print(range)
    print(string)
    guard let formatter = formatter else { return true }
    let result = formatter.formatInput(currentText: textField.text ?? "", range: range, replacementString: string)
    textField.text = result.formattedText
    textField.setCursorLocation(result.caretBeginOffset)
    
    return false
  }
}


class TextViewInputController: NSObject, UITextViewDelegate {
  
  var formatter: TextInputFormatter?
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let formatter = formatter else { return true }
    let result = formatter.formatInput(currentText: textView.text, range: range, replacementString: text)
    textView.text = result.formattedText
    textView.setCursorLocation(result.caretBeginOffset)
    
    return false
  }
}

private extension UITextField {
  
  func setCursorLocation(_ location: Int) {
    if let cursorLocation = position(from: beginningOfDocument, offset: location) {
      DispatchQueue.main.async { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.selectedTextRange = strongSelf.textRange(from: cursorLocation, to: cursorLocation)
      }
    }
  }
}

private extension UITextView {
  
  func setCursorLocation(_ location: Int) {
    if let cursorLocation = position(from: beginningOfDocument, offset: location) {
      DispatchQueue.main.async { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.selectedTextRange = strongSelf.textRange(from: cursorLocation, to: cursorLocation)
      }
    }
  }
}
