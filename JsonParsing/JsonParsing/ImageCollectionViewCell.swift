//
//  ImageCollectionViewCell.swift
//  PhotoSearch
//
//  Created by Bella Wei on 8/2/21.
//

import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let indentifier = "ImageCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "house")
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with url: String){
        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            [weak self]data, _, error in guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.imageView.image = image
        }
       
        }
        task.resume()
        
    }

}
