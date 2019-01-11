//
//  NewsListViewController.swift
//  newsDataBase
//
//  Created by Artem Chursin on 07/01/2019.
//  Copyright © 2019 Artem Chursin. All rights reserved.
//

import UIKit
import CoreData

class NewsListViewController: UIViewController {

    //MARK: - Variables
    var newsArr: [NewsItem] = []
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - Outlets
    @IBOutlet weak var newsTable: UITableView!
    
    //MARK: - LifeStyle ViewController
    override func viewWillAppear(_ animated: Bool) {
        reqestToCoreData()
        newsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTable.reloadData()
    }
    
    //MARK: - Private methods
    private func reqestToCoreData() {
        let fetchRequest: NSFetchRequest<NewsItem> = NewsItem.fetchRequest()
        do {
            newsArr = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
     private func configureCell(with indexPathRow:Int, cell:NewsListTableViewCell) -> NewsListTableViewCell {
        let news = newsArr[indexPathRow]
        cell.newsTitle.text = news.itemTitle
        cell.newsDate.text = news.itemDate
        
        if let newImageData = news.newsImage {
            
            cell.imageNews.image = UIImage(data: newImageData)
        }
        else {
            cell.imageNews.image = UIImage(named: "noneIm")
        }

        return cell
    }
}


extension NewsListViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTablleCell", for: indexPath) as! NewsListTableViewCell
        
        return configureCell(with: indexPath.row, cell: cell)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {return}
        
        let newsToDelete = newsArr[indexPath.row]
        
        context.delete(newsToDelete)
        
        do {
            try context.save()
            reqestToCoreData()
            print("Core updated")
            newsTable.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("Error: \(error), description \(error.userInfo)")
        }
    }
}

extension NewsListViewController: UITableViewDelegate {
    // MARK: - Table view data Delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNews" {
            let destination = segue.destination as? NewsViewController
            if let selectedRow = newsTable.indexPathForSelectedRow?.row {
                destination?.selectedNews = newsArr[selectedRow]
            }
        }
    }
}

