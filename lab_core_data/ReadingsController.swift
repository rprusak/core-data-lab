//
//  ReadingsController.swift
//  lab_core_data
//
//  Created by r on 03/01/2018.
//  Copyright © 2018 r. All rights reserved.
//

import UIKit
import UIKit

class ReadingsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var readings: [Reading] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readings.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingCell", for: indexPath)
        
        let tmp = readings[indexPath.row]
        cell.textLabel?.text = "Time: \(tmp.timestamp), value: \(tmp.value)"
        cell.detailTextLabel?.text = "From sensor: \(tmp.relationship?.name ?? "unknown")"
        return cell
    }
    
    func getData() {
        do {
            readings = try context.fetch(Reading.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reading = readings[indexPath.row]
            context.delete(reading)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                readings = try context.fetch(Reading.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
}
