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
        
        if let title = selectedNews?.itemTitle {
            newsTitle.text = title
        } else {
            newsTitle.text = "Error"
        }
        
        if let text = selectedNews?.itemText {
            newsText.text = text
        } else {
            newsTitle.text = "Error"
        }
        
        if let date = selectedNews?.itemDate {
            newsDate.text = "Опубликованно" + date
        } else {
            newsTitle.text = "Error"
        }
        
        if let newImageData = selectedNews?.newsImage {
            
            newsImage.image = UIImage(data: newImageData)
        }
        else {
            newsImage.image = UIImage(named: "apple1-2")
        }
        self.title = newsTitle.text
    }
}
