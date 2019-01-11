//
//  AddViewController.swift
//  newsDataBase
//
//  Created by Artem Chursin on 09/01/2019.
//  Copyright © 2019 Artem Chursin. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    //MARK: - Constants
    let imagePicker = UIImagePickerController()
    
    //MARK: - Variables
    var pickedImageProduct = UIImage()
    var newsArr: [NewsItem] = []
    var editingTextCounter = true
    var editingTitleCounter = true
    //MARK: - Outlets
    
    @IBOutlet weak var newsTitle: UITextField!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var backScroll: UIScrollView!
    
    
    //MARK: - LifeStyle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsDate.text = dateSet()
        imagePicker.delegate = self
        newsText.delegate = self
        newsTitle.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //запрос к CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NewsItem> = NewsItem.fetchRequest()
        do {
            newsArr = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        nottificationCenterConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        nottificationCenterClean()
    }
    
    //MARK: - Actions
    @IBAction func addImage(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func postNews(_ sender: Any) {
        
        if let title = newsTitle.text {
            if let text = newsText.text {
                let ac = UIAlertController(title: "Вы уверены?", message: "Добавить новость в базу данных?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default) { action in
                    self.saveNews(title: title, dateN: self.dateSet(), text: text)
                }
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                ac.addAction(ok)
                ac.addAction(cancel)
                present(ac, animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK: - Private methods
    
    private func saveNews(title: String, dateN: String, text: String) {
        
        if title != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "NewsItem", in: context)
            let newsObject = NSManagedObject(entity: entity!, insertInto: context) as! NewsItem
            newsObject.itemTitle = title
            newsObject.itemDate = dateN
            if text != "Введите текст новости..." {
                newsObject.itemText = text
            } else {
                newsObject.itemText = ""
            }
            
            let counter = Int64(newsArr.count) + 1
            newsObject.id = counter
            
            let imageData = pickedImageProduct.pngData()
            newsObject.newsImage = imageData
            
            do {
                try context.save()
                finalAlert(title: "Готово", message: "Новость сохранена")
            } catch {
                finalAlert(title: "Ошибка", message: "Произошла ошибка. Попробуйте позже")
                print(error.localizedDescription)
            }
        }
        else {
            finalAlert(title: "Ошибка", message: "Заголовок не должен быть пустым")
        }
    }
    
    private func dateSet() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        df.dateFormat = "dd.MM.yyyy"
        return df.string(from: date)
    }
    
    //Алерт на выполнение/ ошибку при работе с бд
    private func finalAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ок", style: .default, handler: nil)
        ac.addAction(ok)
        
        present(ac, animated: true, completion: nil)
    }
    
    //методы работы с клавиатурой
    private func nottificationCenterConfig() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func nottificationCenterClean() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        self.backScroll?.contentInset = contentInsets
        backScroll?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        backScroll?.contentInset = contentInsets
        backScroll?.scrollIndicatorInsets = contentInsets
    }
}


extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // UIImagePickerControllerDelegate
    // Расширение для работы с библиотекой фото
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        pickedImageProduct = selectedImage
        newsImage.image = pickedImageProduct
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension AddViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if editingTextCounter {
            newsText.text = String()
            editingTextCounter = false
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if editingTitleCounter {
            newsTitle.text = String()
            editingTitleCounter = false
        }
    }
}

