//
//  WorkoutCell.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 06/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol WorkoutCellDelegate {
    func deleteWorkoutAt(index : Int)
}

class WorkoutCell: UITableViewCell {

    var cellIndex = 0
    var delegate : WorkoutCellDelegate?
    
    @IBOutlet weak var dateLabel:  UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var delBtn:     UIButton!
    
    @IBOutlet weak var titlesLeadingConst: NSLayoutConstraint!
    
    @IBAction func delBtnTapped(_ sender: UIButton) {
        delegate?.deleteWorkoutAt(index: cellIndex)
    }
    
    func showDeleteButton(ifEditMode editMode : Bool) {
        titlesLeadingConst.constant = editMode ? 72 : 14
        self.delBtn.isHidden = false
        UIView.animate(withDuration: 0.8) {
            if editMode { self.delBtn.frame.size.width = 200 }
            else { self.delBtn.isHidden = true }
        }
    }
}

