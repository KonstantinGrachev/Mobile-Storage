//
//  ViewController.swift
//  TestTaskMobileStorage
//
//  Created by Konstantin Gracheff on 26.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    enum Constants {
        enum Constraints {
            static let heightForCell: CGFloat = 88
            static let heightWidthForButton: CGFloat = 44
            static let sideIndentation: CGFloat = 16
        }
    }
    
    //MARK: properties
    let storageManager = StorageManager()
    
    //MARK: - UI
    
    private let nameAppLabel: UILabel = {
        let label = UILabel()
        label.text = "Mobile Storage"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .specialBackground
        return label
    }()
    
    private lazy var addMobileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(addMobileButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .specialBackground
        return button
    }()
    
    private lazy var findMobileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(findMobileButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .specialBackground
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .cyan
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .specialBackground
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setDelegates()
        registerCell()
        setConstraints()
    }
    
    //MARK: - @IBActions
    
    @IBAction private func addMobileButtonTapped() {
        saveMobile()
    }
    
    @IBAction private func findMobileButtonTapped() {
        findMobile()
    }
    
    //MARK: - setup views
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(tableView)
        view.addSubview(addMobileButton)
        view.addSubview(findMobileButton)
        view.addSubview(nameAppLabel)
    }
    
    //MARK: - set delegates
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - register cell
    
    private func registerCell() {
        tableView.register(MobileTableViewCell.self, forCellReuseIdentifier: MobileTableViewCell.cellID)
    }
    
    //MARK: - regular funcs
    
    private func saveMobile() {
        showSaveAlert(actionHandler:  { imei, model in
            guard let imei = imei,
                  let model = model else { return }
            let mobile = Mobile(imei: imei, model: model)
            if self.storageManager.exists(mobile) {
                self.showAlert(title: "Error", message: "This phone exist in library")
                return
            } else {
                let mobile = try? self.storageManager.save(mobile)
                guard let modelText = mobile?.model else { return }
                self.showAlert(title: "Success", message: "\(modelText) added.")
            }
            self.tableView.reloadData()
        })
        
    }
    
    private func findMobile() {
        showFindAlert(actionHandler:  { text in
            guard let text = text else { return }
            guard let mobile = self.storageManager.findByImei(text) else {
                self.showAlert(title: "Not found", message: "Phone is not available")
                return
            }
            self.showAlert(title: "The phone was found",
                           message: """
Phone model: \(mobile.model)
IMEI: \(mobile.imei)
""")
        })
    }
}

//MARK: - table view delegate and data source

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storageManager.getAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MobileTableViewCell.cellID, for: indexPath) as? MobileTableViewCell else { return UITableViewCell() }
        guard let mobilesArray = storageManager.mobiles else { return UITableViewCell()}
        cell.cellConfigure(mobile: mobilesArray[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Constraints.heightForCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let mobile = storageManager.mobiles[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            try? self.storageManager.delete(mobile)
            tableView.deleteRows(at: [indexPath], with: .none)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


//MARK: - set constraints

extension ViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addMobileButton.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            addMobileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addMobileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Constraints.sideIndentation),
            addMobileButton.heightAnchor.constraint(equalToConstant: Constants.Constraints.heightWidthForButton),
            addMobileButton.widthAnchor.constraint(equalToConstant: Constants.Constraints.heightWidthForButton)
        ])
        
        NSLayoutConstraint.activate([
            findMobileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            findMobileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: Constants.Constraints.sideIndentation),
            findMobileButton.heightAnchor.constraint(equalTo: addMobileButton.heightAnchor),
            findMobileButton.widthAnchor.constraint(equalTo: addMobileButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameAppLabel.centerYAnchor.constraint(equalTo: addMobileButton.centerYAnchor),
            nameAppLabel.leadingAnchor.constraint(equalTo: findMobileButton.trailingAnchor),
            nameAppLabel.trailingAnchor.constraint(equalTo: addMobileButton.leadingAnchor)
        ])
    }
}
