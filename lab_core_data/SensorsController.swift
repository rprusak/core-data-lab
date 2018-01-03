//
//  SensorsController.swift
//  lab_core_data
//
//  Created by r on 03/01/2018.
//  Copyright © 2018 r. All rights reserved.
//

import UIKit

class SensorsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var sensors: [Sensor] = []
    
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
        return sensors.count
    }
    
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SensorCell", for: indexPath)
        
        let tmp = sensors[indexPath.row]
        cell.textLabel?.text = tmp.name
        cell.detailTextLabel?.text = tmp.desc
        return cell
    }
    
    func getData() {
        do {
            sensors = try context.fetch(Sensor.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sensor = sensors[indexPath.row]
            context.delete(sensor)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                sensors = try context.fetch(Sensor.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
}

