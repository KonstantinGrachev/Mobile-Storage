//
//  MobileTableViewCell.swift
//  TestTaskMobileStorage
//
//  Created by Konstantin Gracheff on 26.09.2022.
//

import UIKit

class MobileTableViewCell: UITableViewCell {
    
    enum Constants {
        enum Constants {
            static let sideIndentation: CGFloat = 16
        }
    }
    
    static let cellID = "MobileTableViewCellID"
    
    //MARK: - UI
    
    private let modelLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imeiLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(modelLabel)
        contentView.addSubview(imeiLabel)
        selectionStyle = .none
        backgroundColor = .specialBackground
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set constraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            modelLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Constants.sideIndentation),
            modelLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Constants.sideIndentation),
            modelLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Constants.sideIndentation)
        ])
        
        NSLayoutConstraint.activate([
            imeiLabel.leadingAnchor.constraint(equalTo: modelLabel.leadingAnchor),
            imeiLabel.trailingAnchor.constraint(equalTo: modelLabel.trailingAnchor),
            imeiLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor),
            imeiLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Constants.sideIndentation)
        ])
    }
    
    //MARK: - cell configure
    func cellConfigure(mobile: Mobile) {
        modelLabel.text = mobile.model
        imeiLabel.text = mobile.imei
    }
}
