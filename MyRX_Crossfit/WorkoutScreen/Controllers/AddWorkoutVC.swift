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
    
    @IBOutlet weak var titleTF:    UITextField!
    @IBOutlet weak var dateTF:     UITextField!
    @IBOutlet weak var timeRepsTF: UITextField!
    @IBOutlet weak var detailsTV:  UITextView!
    @IBOutlet weak var weightsTF:  UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet var contentHolders: [UIView]!
    @IBOutlet var buttons: [UIButton]!
    
    private let dbManager = CoreDataManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initDatePicker()
        setTextFields()
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
        let context =        AppDelegate.viewContext
        let workout =        Workout(context: context)
        workout.date =       datePicker.date
        workout.dateString = dateTF.text
        workout.details =    detailsTV.text
        workout.time =       timeRepsTF.text
        workout.weights =    weightsTF.text
        workout.title =      titleTF.text
        
        let workouts = dbManager.save(workout: workout)
        delegate?.received(workouts: workouts)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - BUTTONS -
    @IBAction func titleTapped(_ sender: UIButton) {
        showRow(ofBtn: sender)
    }
    
    @IBAction func dateTapped(_ sender: UIButton) {
        showRow(ofBtn: sender)
    }
    
    @IBAction func detailsTapped(_ sender: UIButton) {
        showRow(ofBtn: sender)
    }
    
    @IBAction func resultTapped(_ sender: UIButton) {
        showRow(ofBtn: sender)
    }
    
    private func showRow(ofBtn sender : UIButton) {
        for i in buttons.indices {
            if buttons[i] == sender {
                for view in contentHolders[i].subviews { view.isHidden = true }
                animateContentHolder(atIndex: i)
            }
        }
    }
    
    private func setTextFields() {
        for view in contentHolders {
           view.isHidden = true
        }
    }
    
    private func animateContentHolder(atIndex index : Int) {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentHolders[index].isHidden = self.contentHolders[index].isHidden ? false : true
        }) { (_) in for view in self.contentHolders[index].subviews { view.isHidden = false } }
    }
}
