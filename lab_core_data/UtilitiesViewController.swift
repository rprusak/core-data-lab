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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("utilities view controler loaded");
        self.recordsNumberInput.delegate = self
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
        self.resultTextView.text = "generate records button clicked";
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
