//
//  DetailVC.swift
//  ArtBookProject
//
//  Created by Şeyda Aydın on 8.06.2023.
//

import UIKit
import CoreData

class DetailVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var choosenPaintings = ""
    var choosenPaintingsId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if choosenPaintings != "" {
            //CoreData
            saveButton.isHidden = true
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            //Filtreleme
            
            let idString = choosenPaintingsId?.uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            
            do{
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let name = result.value(forKey: "name") as? String{
                            nameText.text = name
                        }
                        if let artistName = result.value(forKey: "artist") as? String {
                            artistText.text = artistName
                        }
                        if let year = result.value(forKey: "year") as? Int {
                            yearText.text = String(year)
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                    }
                }
                
            }catch{
                print("error")
            }
            
        }
        else{
            saveButton.isEnabled = false
            
            nameText.text = ""
            artistText.text = ""
            yearText.text = ""
        }
        
        //Recognizer
        
        /*
         let gesturedRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
         view.addGestureRecognizer(gesturedRecognizer)
         */
        
        imageView.isUserInteractionEnabled = true
        
        let gesturedRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedImage))
        
        imageView.addGestureRecognizer(gesturedRecognizer)
       
        
    }
    
    @objc func selectedImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true,completion: nil)
        
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
        saveButton.isEnabled = true
    }
    
    /*
     @objc func hideKeyboard() {
     
     view.endEditing(true)
     }
     */
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        //ATTRİBUTES
        
        newPainting.setValue(nameText.text!, forKey: "name")
        newPainting.setValue(artistText.text!, forKey: "artist")
        newPainting.setValue(UUID(), forKey: "id")
        
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        newPainting.setValue(data, forKey: "image")
        
        if let year = Int(yearText.text!) {
            newPainting.setValue(year, forKey: "year")
            
            do {
                try context.save()
                print("succes")
                
            }catch {
                print("error")
                
            }
            
            //yeni dataların geldiğini bildirir
            
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            self.navigationController?.popViewController(animated: true)
            
            
            
            
            
        }
        
        
    }
}
