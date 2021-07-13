//
//  DateFilterViewController.swift
//  CovidTracker
//
//  Created by Masato Takamura on 2021/07/13.
//

import UIKit

protocol DateFilterViewControllerDelegate: AnyObject {
    func fetchDataFromDate(date: String)
}

///検索する日付を指定する
final class DateFilterViewController: UIViewController {
    
    //MARK: - Properties
    var delegate: DateFilterViewControllerDelegate?
    
    //MARK: - UI parts
    private lazy var textField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "日付を選択してください"
        let leftImage = UIImage(systemName: "calendar")
        let leftImageView = UIImageView(image: leftImage)
        leftImageView.tintColor = .gray
        textField.leftView = leftImageView
        textField.leftViewMode = .always
        textField.inputView = datePicker
        textField.inputAccessoryView = toolBar
        textField.delegate = self
        return textField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        
        return datePicker
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton(_:)))
        toolBar.setItems([spaceItem, doneItem], animated: false)
        
        return toolBar
    }()
    
    @objc
    func didTapDoneButton(_ sender: UIBarButtonItem) {
        textField.text = dateFormat(from: datePicker.date)
        textField.endEditing(true)
    }
    
    private lazy var decideButton: UIButton = {
       let button = UIButton()
        button.setTitle("設定", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapDecideButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc
    func didTapDecideButton(_ sender: UIButton) {
        textField.endEditing(true)
        delegate?.fetchDataFromDate(date: textField.text ?? "")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "日付を指定"
        view.backgroundColor = .systemBackground
        setupViewsLayout()
        setupNavigationController()
    }
}

//MARK: - UITextFieldDelegate
extension DateFilterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.text = dateFormat(from: datePicker.date)
        textField.endEditing(true)
        return true
    }
}

//MARK: - Private extension
private extension DateFilterViewController {
    ///レイアウト
    private func setupViewsLayout() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 48)
            
        ])
        
        view.addSubview(decideButton)
        decideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            decideButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 48),
            decideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            decideButton.widthAnchor.constraint(equalToConstant: 160),
            decideButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        )
    }
    
    ///NavigationControllerの設定
    private func setupNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCancelButton(_:)))
    }
    
    @objc
    private func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    ///DateFormatter
    private func dateFormat(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: datePicker.date)
    }
}
