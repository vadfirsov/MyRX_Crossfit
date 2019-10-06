//
//  AddWorkoutVC.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 06/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol AddWorkoutDelegate {
    func received(workouts : [Workout])
}

class AddWorkoutVC: UIViewController {
    
    var delegate : AddWorkoutDelegate?
    
    
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeRepsTF: UITextField!
    @IBOutlet weak var detailsTV: UITextView!
    @IBOutlet weak var weightsTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let dbManager = CoreDataManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        showRow()
        titleTF.isHidden = titleTF.isHidden ? false : true
        initDatePicker()
    }
    
    //MARK: - DATE METHODS -
    @objc func dateChanged() {
        dateTF.text = stringDateFrom(date: datePicker.date)
    }
    
    private func stringDateFrom(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    private func initDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dateTF.text = stringDateFrom(date: datePicker.date)
    }
    
    //MARK: - ADD BUTTON -
    @IBAction func savedTapped(_ sender: UIBarButtonItem) {
        let context = AppDelegate.viewContext
        let workout = Workout(context: context)
        workout.date = datePicker.date
        workout.dateString = dateTF.text
        workout.details = detailsTV.text
        workout.time = timeRepsTF.text
        workout.weights = weightsTF.text
        
        let workouts = dbManager.save(workout: workout)
        delegate?.received(workouts: workouts)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func titleTapped(_ sender: UIButton) {
        showRow()
//        titleTF.isHidden = titleTF.isHidden ? false : true
    }
    
    @IBAction func dateTapped(_ sender: UIButton) {
        showRow()
//        dateTF.isHidden = dateTF.isEditing ? false : true
//        datePicker.isHidden = datePicker.isHidden ? false : true
    }
    
    @IBAction func detailsTapped(_ sender: UIButton) {
        showRow()
//        detailsTV.isHidden = detailsTV.isHidden ? false : true
    }
    
    @IBAction func resultTapped(_ sender: UIButton) {
        showRow()
//        timeRepsTF.isHidden = timeRepsTF.isHidden ? false : true
//        weightsTF.isHidden = weightsTF.isHidden ? false : true
    }
    
    private func showRow() {
        titleTF.isHidden = titleTF.isHidden ? false : true
        dateTF.isHidden = dateTF.isEditing ? false : true
        datePicker.isHidden = datePicker.isHidden ? false : true
        detailsTV.isHidden = detailsTV.isHidden ? false : true
        timeRepsTF.isHidden = timeRepsTF.isHidden ? false : true
        weightsTF.isHidden = weightsTF.isHidden ? false : true
    }
    
    
    
}
