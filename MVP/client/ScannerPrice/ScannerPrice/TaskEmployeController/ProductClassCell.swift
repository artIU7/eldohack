//
//  ProductClassCell.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 22.06.2021.
//

import UIKit
import SnapKit

class ProductClassCell: UITableViewCell {
    
    var product:Product? {
        didSet {
            guard let productItem = product else {return}
            if let nameTitle = productItem.name {
                nameLabel.text = nameTitle
            }
            if let priceTitle = productItem.price {
                priceLabel.text = " \(priceTitle) "
            }
            
            if let dataTile = productItem.data {
                dataLabel.text = " \(dataTile) "
            }
            
            /*if let image = productItem.data {
                countryImageView.image = UIImage(named: image)
            }*/
        }
    }
    
    let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2088217232, green: 0.8087635632, blue: 0.364161254, alpha: 1)
        view.layer.cornerRadius = 4.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    /*let profileImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        return img
    }()*/
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor =  .white
        label.backgroundColor = #colorLiteral(red: 0.9995597005, green: 0, blue: 0, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dataLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor =  .white
        label.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /*let countryImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // without this your image will shrink and looks ugly
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 13
        img.clipsToBounds = true
        return img
    }()*/

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints{ (marker) in
            marker.left.right.equalToSuperview().inset(5)
            marker.top.bottom.equalToSuperview().inset(2.5)
        }
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {(marker) in
            marker.left.equalToSuperview().inset(10)
            marker.top.equalToSuperview().inset(20)
        }
        containerView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints {(marker) in
            marker.left.equalToSuperview().inset(10)
            marker.top.equalTo(nameLabel).inset(40)
        }
        containerView.addSubview(dataLabel)
        dataLabel.snp.makeConstraints {(marker) in
            marker.left.equalTo(nameLabel).inset(priceLabel.frame.width + 120)
            marker.top.equalTo(nameLabel).inset(40)
        }
       //self.contentView.addSubview(profileImageView)
       // profileImageView.snp.makeConstraints { (marker) in
       //     marker.top.bottom.equalToSuperview().inset(5)
       //     marker.left.equalToSuperview().inset(5)
       // }
       // containerView.addSubview(nameLabel)
       // nameLabel.snp.makeConstraints { (marker) in
       //     marker.top.bottom.equalToSuperview().inset(5)
       //     marker.left.equalTo(profileImageView).inset(5)
       // }
       // containerView.addSubview(priceLabel)
       // jobTitleDetailedLabel.snp.makeConstraints { (marker) in
       //     marker.top.equalTo(nameLabel).inset(5)
       //     marker.left.equalTo(profileImageView).inset(5)
       // }
        //containerView.addSubview(dataLabel)
      //  dataCheckLabel.snp.makeConstraints { (marker) in
      //      marker.top.equalToSuperview().inset(5)
      //      marker.left.equalTo(jobTitleDetailedLabel).inset(5)
      //  }
      //  self.contentView.addSubview(containerView)
      //  dataCheckLabel.snp.makeConstraints { (marker) in
      //      marker.top.equalToSuperview().inset(0)
       //     marker.left.equalToSuperview().inset(5)
      //  }
       // self.contentView.addSubview(countryImageView)
      //  countryImageView.snp.makeConstraints { (marker) in
      //     marker.top.equalToSuperview().inset(0)
       //     marker.left.equalTo(containerView).inset(5)
      //  }
        
       // profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        //profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        //profileImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
        //profileImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        //containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        //containerView.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
        //containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        //containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        //nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        //nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        //nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        //priceLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
        //priceLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        //priceLabel.widthAnchor.constraint(equalToConstant:26).isActive = true
        
        //dataLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
        //dataLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
        //countryImageView.widthAnchor.constraint(equalToConstant:26).isActive = true
        //countryImageView.heightAnchor.constraint(equalToConstant:26).isActive = true
        //countryImageView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-20).isActive = true
        //countryImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

}
