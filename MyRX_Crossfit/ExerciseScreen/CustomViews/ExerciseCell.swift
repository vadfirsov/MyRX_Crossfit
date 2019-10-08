//
//  ExerciseCell.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 01/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol ExerciseCellDelegate {
    func deleteBtnTapped(cellIndex : Int)
}

class ExerciseCell: UITableViewCell {
    
    var cellIndex = 0
    var delegate : ExerciseCellDelegate?
    var weightMeasurementUnit = "kg"
    
    @IBOutlet weak var titlesLeadingConst:  NSLayoutConstraint!
    @IBOutlet weak var delBtn:             UIButton!
    @IBOutlet weak var nameLabel:          UILabel!
    @IBOutlet weak var repsAndWeightLabel: UILabel!
    
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        delegate?.deleteBtnTapped(cellIndex: cellIndex)
    }
    
    func setLabel(withReps reps : Int, weight : Double, unit : WeightMeasurmentUnits) {
        var weightStr              = "\(weight) reps"
        if weight == 0 { weightStr = "no weight!" }
        repsAndWeightLabel.text    = "\(reps) reps w/ " + weightStr
    }
    
    func showDeleteButton(ifEditMode editMode : Bool) {
        titlesLeadingConst.constant = editMode ? 74 : 14
        self.delBtn.isHidden = false
        UIView.animate(withDuration: 0.8) {
            if editMode { self.delBtn.frame.size.width = 200 }
            else { self.delBtn.isHidden = true }
        }
    }
}

enum WeightMeasurmentUnits {
    case kg, lbs
}
