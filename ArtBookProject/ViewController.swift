//
//  ViewController.swift
//  ArtBookProject
//
//  Created by Şeyda Aydın on 8.06.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
     
    @IBOutlet weak var tableView: UITableView!
    var stringArray = [String]()
    var idArray = [UUID]()
    
    
    var selectPaintings = ""
    var selectPaintingsId : UUID?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
      
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    @objc func getData(){
        
        stringArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity:  false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    if let name = result.value(forKey: "name") as? String {
                        self.stringArray.append(name)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                
            }
         
                self.tableView.reloadData()
                
            }
        }catch{
            print("error")
        }
        
        
    }

    @objc func addButtonClicked() {
        
        selectPaintings = ""
        performSegue(withIdentifier: "toDetailVC", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        content.text = stringArray[indexPath.row]
        cell.contentConfiguration = content
        
   
    
            
            // Hücreye kalp ikonunu ekleme
            
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectPaintings = stringArray[indexPath.row]
        selectPaintingsId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            
            let destinationVC = segue.destination as! DetailVC
            destinationVC.choosenPaintings = selectPaintings
            destinationVC.choosenPaintingsId = selectPaintingsId
            
        }
        
    }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: " id  = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let id = result.value(forKey: "id") as? UUID {
                            
                            if id == idArray[indexPath.row] {
                                
                                context.delete(result)
                                stringArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                
                                do{
                                    try context.save()
                                }catch {
                                    print("error")
                                    
                                }
                                break
                                
                            }
                            
                        }
                    }
                }
            }catch {
                print("error")
            }

            
            
            
            
            
        }
        
    }

}

