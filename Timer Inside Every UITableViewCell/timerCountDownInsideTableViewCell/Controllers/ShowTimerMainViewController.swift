//
//  ShowTimerMainViewController.swift
//  timerCountDownInsideTableViewCell
//
//  Created by Tuhin Samui on 26/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class ShowTimerMainViewController: UIViewController {
    @IBOutlet weak var addItemBtnOutlet: UIButton!
    @IBOutlet weak var addItemBtnSuperView: UIView!
    @IBOutlet weak var showTimerMainTableView: UITableView!
    fileprivate var timerMainTableViewData: [[String: Any]] = []
    fileprivate var countDownTimer: Timer? = nil
    fileprivate var timerStartingValue: Int = 200000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTimerMainTableView.register(UINib(nibName: "ShowTimerMainTableCell", bundle: nil), forCellReuseIdentifier: "showTimerMainTableViewCellId")
        showTimerMainTableView.delegate  = self
        showTimerMainTableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addItemBtnAction(_ sender: UIButton) {
        if timerMainTableViewData.isEmpty { //Will Start the timer only if the main tableview is empty ot if this is the first item to add.
            startCountDownTimer()
        }
        let cellData: [String: Any] = ["cellName": "Player\(timerMainTableViewData.count == 0 ? 1 : (timerMainTableViewData.count + 1))", "timerCurrentValue": timerStartingValue, "cellIndex": timerMainTableViewData.count]
        timerMainTableViewData.append(cellData)
        showTimerMainTableView.reloadData()
    }
    
    
    fileprivate func stopCountDownTimer() {
        if ((countDownTimer?.isValid) != nil) {
            countDownTimer?.invalidate()
            countDownTimer = nil
        }
    }
    
    fileprivate func startCountDownTimer(){
        countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCurrentTimerValue), userInfo: nil, repeats: true)
        RunLoop.current.add(countDownTimer!, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func showAlertOnCellDelete(whichIndex indexValue: Int){
        let alertController: UIAlertController = UIAlertController(title: "Your time is up!", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        if self.presentedViewController == nil{ //Will Check if any previous alert present on screen
            self.present(alertController, animated: true, completion: nil)
        }else{
            debugPrint("Alert is Already Present Here...!!!!")
        }
        
    }
    
    
    @objc fileprivate func updateCurrentTimerValue(){
        DispatchQueue.main.async(execute: { //All the updation inside a asynchronous thread for performance optimisation!
            var cellIndexToBeRemoved: [Int] = []
            for (objectIndex, objectData) in self.timerMainTableViewData.enumerated(){
                if let timerCurrentValueCheck = objectData["timerCurrentValue"] as? Int,
                    timerCurrentValueCheck > 0{
                    self.timerMainTableViewData[objectIndex].updateValue((timerCurrentValueCheck - 1), forKey: "timerCurrentValue")
                } else {
                    if let cellIndexCheck = objectData["cellIndex"] as? Int {
                        cellIndexToBeRemoved.append(cellIndexCheck)
                    }
                }
            }
            
            if cellIndexToBeRemoved.count >= self.timerMainTableViewData.count {
                debugPrint("All cell removed! So the timer is going to stop!")
                self.stopCountDownTimer()
                self.timerMainTableViewData.removeAll()
                self.showAlertOnCellDelete(whichIndex: 0)
            } else if !cellIndexToBeRemoved.isEmpty{
                for valueIndex in cellIndexToBeRemoved {
                    for (cellIndex, cellValue) in self.timerMainTableViewData.enumerated() {
                        if let cellIndexCheck = cellValue["cellIndex"] as? Int,
                            cellIndexCheck == valueIndex{
                            debugPrint("Cell removed on the index \(valueIndex) and the corresponding dataIndex is \(cellIndexCheck)")
                            self.showAlertOnCellDelete(whichIndex: cellIndex)
                            self.timerMainTableViewData.remove(at: cellIndex)
                            break
                        } else {
                            continue
                        }
                    }
                }
            } else {
                debugPrint("No Cell to remove!!!")
            }
            self.showTimerMainTableView.reloadData()
        })
    }

}

//MARK: - UITableView Delegate Methods
extension ShowTimerMainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isSelected == true{
            cell.contentView.backgroundColor = UIColor.lightGray
            
        }
        if(tableView.responds(to: #selector(setter: UITableViewCell.separatorInset))) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        
        if(tableView.responds(to: #selector(setter: UIView.layoutMargins))) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - UITableView DataSource Methods
extension ShowTimerMainViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerMainTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "showTimerMainTableViewCellId", for: indexPath) as? ShowTimerMainTableCell{
            
            if let timerLblNameCheck = timerMainTableViewData[indexPath.row]["cellName"] as? String,
                !timerLblNameCheck.isEmpty{
                cell.showTimerFirstTxtLbl.text = timerLblNameCheck
            } else {
                cell.showTimerFirstTxtLbl.text = "No Name Found!"
            }
            
            if let currentTimerValueCheck = timerMainTableViewData[indexPath.row]["timerCurrentValue"] as? Int,
                currentTimerValueCheck != 0{
                cell.progressValueUpdateLbl.text = "\(currentTimerValueCheck)"
            } else {
                cell.progressValueUpdateLbl.text = "0"
            }
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .default
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
}
