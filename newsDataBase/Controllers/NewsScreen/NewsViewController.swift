//
//  NewsViewController.swift
//  newsDataBase
//
//  Created by Artem Chursin on 09/01/2019.
//  Copyright © 2019 Artem Chursin. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    //MARK: - Variables
    var selectedNews: NewsItem? = nil
    
    //MARK: - Outlets
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsText: UITextView!
    
    //MARK: - LifeStyle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
       screenDataConfig()
        self.title = newsTitle.text
    }
    
    //MARK: - Private methods
    //Заполнение экрана новости
    private func screenDataConfig() {
        
        guard let title = selectedNews?.itemTitle,
            let text = selectedNews?.itemText,
            let date = selectedNews?.itemDate
            else {
            return
        }
        
        if let newImageData = selectedNews?.newsImage {
            newsImage.image = UIImage(data: newImageData)
        }
        newsTitle.text = title
        newsText.text = text
        newsDate.text = "Опубликованно: " + date
    }
}
