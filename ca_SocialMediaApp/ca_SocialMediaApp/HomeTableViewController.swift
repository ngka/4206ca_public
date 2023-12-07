// HomeTableViewController.swift
// ca_SocialMediaApp
//
// Created by user on 2/12/2023.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, UISearchBarDelegate {

    var managedObjectContext: NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil
    }

    
    var devices: [Info_image]?
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        searchBar.delegate = self

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchAndReloadTable(query: searchText)
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchAndReloadTable(query: "")
            searchBar.resignFirstResponder()
        }

    func searchAndReloadTable(query: String) {
        if let managedObjectContext = self.managedObjectContext {
            let fetchRequest = NSFetchRequest<Info_image>(entityName: "Info_image")
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            if query.count > 0 {
                let predicate = NSPredicate(format: "title contains[cd] %@", query)
                fetchRequest.predicate = predicate
            }
            
            do {
                let theDevices = try managedObjectContext.fetch(fetchRequest)
                self.devices = theDevices
                self.tableView.reloadData()
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchAndReloadTable(query: "")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let devices = self.devices {
            return devices.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        if let device = self.devices?[indexPath.row] {
            cell.titleLabel.text = device.title

            if let imageData = device.image, let image = UIImage(data: imageData) {
                cell.customImageView.image = image
            }

            if let location = device.location {
                let locationComponents = location.components(separatedBy: ",")
                if let city = locationComponents.first, !city.isEmpty {
                    cell.locationLabel.text = city
                } else {
                    cell.locationLabel.text = location
                }
            } else {
                cell.locationLabel.text = nil
            }

            if let date = device.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
                let dateString = dateFormatter.string(from: date)
                cell.dateLabel.text = "Time: " + dateString
            } else {
                cell.dateLabel.text = nil
            }
        }

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditSegue", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditSegue" {
            if let navVC = segue.destination as? UINavigationController {
                if let addEditVC = navVC.topViewController as? AddEditViewController {
                    if let indexPath = sender as? IndexPath {
                        if let devices = self.devices {
                            addEditVC.theDevice = devices[indexPath.row]
                        }
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let device = self.devices?.remove(at: indexPath.row) {
                managedObjectContext?.delete(device)
                try? self.managedObjectContext?.save()
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
