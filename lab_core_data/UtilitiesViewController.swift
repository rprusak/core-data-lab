//
//  UtilitiesViewController.swift
//  lab_core_data
//
//  Created by r on 03/01/2018.
//  Copyright © 2018 r. All rights reserved.
//

import UIKit
import CoreData

class UtilitiesViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var recordsNumberInput: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var sensors: [Sensor] = []
    
    func loadSensors() {
        do {
            sensors = try context.fetch(Sensor.fetchRequest())
        }
        catch {
            print("Fetching sensors failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("utilities view controler loaded");
        self.recordsNumberInput.delegate = self
        loadSensors()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // allow only numbers in text fiels
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return Int(string) != nil
    }
    
    // buton actions
    @IBAction func onGenerateRecordsButtonClicked(_ sender: UIButton) {
        print("generate records button clicked")
        if (recordsNumberInput.text?.isEmpty)! {
            self.resultTextView.text = "Enter number of records!";
            return
        }
    
        let recordsToGenerate : Int = Int(recordsNumberInput.text!)!
        
        if (recordsToGenerate <= 0) {
            self.resultTextView.text = "Invalid number of records!";
            return
        }
        
        if sensors.count == 0 {
            self.resultTextView.text = "There is no sensor";
            return
        }
        
        let startTime = NSDate()
        for _ in 0..<recordsToGenerate {
            addNewReading()
        }
        let finishTime = NSDate()
        
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        self.resultTextView.text = "Generating \(recordsToGenerate) records took \(measuredTime)";
    }
    
    func addNewReading() {
        let randomSensorId = Int(arc4random_uniform(UInt32(sensors.count)))
        let randomValue = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 100
        let randomTimestamp = Int(NSDate().timeIntervalSince1970) - Int(arc4random_uniform(31536000))
        
        let reading = Reading(context: context)
        reading.value = Float(randomValue)
        reading.timestamp = Int64(randomTimestamp)
        reading.relationship = sensors[randomSensorId]
        // Save the data to coredata
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    @IBAction func onDeleteAllRecordsClicked(_ sender: UIButton) {
        print("delete all records clicked")
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            let startTime = NSDate()
            try context.execute(deleteRequest)
            try context.save()
            let finishTime = NSDate()
            
            let measuredTime = finishTime.timeIntervalSince(startTime as Date)
            self.resultTextView.text = "Deleting records took \(measuredTime)";
        } catch {
            print ("There was an error")
        }
    }
    
    @IBAction func onFindLargestAndSmallestTimestampClicked(_ sender: UIButton) {
        print("find largest and smallest timestamp clicked")
        findSmallestTimestamp()
        findLargestTimestamp()
    }
    
    func findSmallestTimestamp() {
        let startTime = NSDate()

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        request.returnsObjectsAsFaults = false
        
        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = "result"
        expressionDesc.expression = NSExpression(forFunction: "min:", arguments:[NSExpression(forKeyPath: "timestamp")])
        expressionDesc.expressionResultType = .integer64AttributeType
        
        request.propertiesToFetch = [expressionDesc]
        request.resultType = .dictionaryResultType
        
        do {
            let result = try context.fetch(request)
            let dict = result[0] as! [String:Float]
            
            let val = dict["result"]!
            
            let finishTime = NSDate()
            let measuredTime = finishTime.timeIntervalSince(startTime as Date)
            self.resultTextView.text = "Min timestamp: \(val), time: \(measuredTime)";
        } catch {
            print ("There was an error")
        }
    }
    
    func findLargestTimestamp() {
        let startTime = NSDate()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        request.returnsObjectsAsFaults = false
        
        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = "result"
        expressionDesc.expression = NSExpression(forFunction: "max:", arguments:[NSExpression(forKeyPath: "timestamp")])
        expressionDesc.expressionResultType = .integer64AttributeType
        
        request.propertiesToFetch = [expressionDesc]
        request.resultType = .dictionaryResultType
        
        do {
            let result = try context.fetch(request)
            let dict = result[0] as! [String:Float]
            
            let val = dict["result"]!
            
            let finishTime = NSDate()
            let measuredTime = finishTime.timeIntervalSince(startTime as Date)
            self.resultTextView.text = self.resultTextView.text + " Max timestamp: \(val), time: \(measuredTime)";
        } catch {
            print ("There was an error")
        }
    }
    
    @IBAction func onCalculateAverageReadingValuesClicked(_ sender: UIButton) {
        print("calculate average reading values clicked")
        self.resultTextView.text = "calculate average reading values clicked"
        calculateAverageValue()
    }
    
    func calculateAverageValue() {
        let startTime = NSDate()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        request.returnsObjectsAsFaults = false
        
        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = "result"
        expressionDesc.expression = NSExpression(forFunction: "average:", arguments:[NSExpression(forKeyPath: "value")])
        expressionDesc.expressionResultType = .integer64AttributeType
        
        request.propertiesToFetch = [expressionDesc]
        request.resultType = .dictionaryResultType
        
        do {
            let result = try context.fetch(request)
            let dict = result[0] as! [String:Float]
            
            let val = dict["result"]!
            
            let finishTime = NSDate()
            let measuredTime = finishTime.timeIntervalSince(startTime as Date)
            self.resultTextView.text = "Average value: \(val), time: \(measuredTime)";
        } catch {
            print ("There was an error")
        }
    }
    
    @IBAction func onCalculateNumberOfReadingsAndAverageClicked(_ sender: UIButton) {
        print("calculate the number of readings and average clicked")
        self.resultTextView.text = "calculate the number of readings and average clicked"
    }
}
