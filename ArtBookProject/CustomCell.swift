//
//  CustomCell.swift
//  ArtBookProject
//
//  Created by Şeyda Aydın on 9.06.2023.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    // Kalp ikonunu içerecek bir UIImageView oluşturun
    let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "select") // Kalp ikonunun adını doğru şekilde ayarlayın
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Kalp ikonunu hücreye eklemek için gerekli düzenlemeleri yapın
        contentView.addSubview(heartImageView)
        
        
        NSLayoutConstraint.activate([
            heartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            heartImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heartImageView.widthAnchor.constraint(equalToConstant: 24),
            heartImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
