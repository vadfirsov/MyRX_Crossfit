//
//  RecordCell.swift
//  MyRX_Crossfit
//
//  Created by VADIM FIRSOV on 01/10/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol RecordCellDelegate {
    func deleteRow(atIndex index : Int)
}

class RecordCell: UITableViewCell {

    var delegate : RecordCellDelegate?
    var cellIndex = 0
    private var isPickersAvailable = false
    private var componentNum = 1
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightAndRepsLabel: UILabel!
    @IBOutlet weak var delBtn: UIButton!

    @IBOutlet weak var titlesLeadingConst: NSLayoutConstraint!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func deleteCell(_ sender: UIButton) {
        delegate?.deleteRow(atIndex: cellIndex)
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
