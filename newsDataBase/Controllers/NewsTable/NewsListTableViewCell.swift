//
//  NewsListTableViewCell.swift
//  newsDataBase
//
//  Created by Artem Chursin on 07/01/2019.
//  Copyright © 2019 Artem Chursin. All rights reserved.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var maskCellView: UIView!
    @IBOutlet weak var contentCell: UIView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var newsDate: UILabel!
    
    //MARK: - CellConfig
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // конфигурация внешнего вида ячейки
        let radius: CGFloat = 42
        
        maskCellView.layer.cornerRadius = radius
        
        imageNews.layer.masksToBounds = true
        imageNews.layer.cornerRadius = radius
        
        maskCellView.layer.shadowOpacity = 0.4
        maskCellView.layer.shadowRadius = 5
        maskCellView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
