//
//  UtilitiesViewController.swift
//  lab_core_data
//
//  Created by r on 03/01/2018.
//  Copyright © 2018 r. All rights reserved.
//

import UIKit

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
    
    @IBAction func onFindLargestAndSmallestTimestampClicked(_ sender: UIButton) {
        print("find largest and smallest timestamp clicked")
        self.resultTextView.text = "find largest and smallest timestamp clicked";
    }
    
    @IBAction func onCalculateAverageReadingValuesClicked(_ sender: UIButton) {
        print("calculate average reading values clicked")
        self.resultTextView.text = "calculate average reading values clicked"
    }
    @IBAction func onCalculateNumberOfReadingsAndAverageClicked(_ sender: UIButton) {
        print("calculate the number of readings and average clicked")
        self.resultTextView.text = "calculate the number of readings and average clicked"
    }
}
