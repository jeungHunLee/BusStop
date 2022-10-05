//
//  ViewController.swift
//  BusStop
//
//  Created by 이정훈 on 2022/09/17.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet var cityPicker: UIPickerView!
    @IBOutlet var busStopName: UITextField!
    @IBOutlet var busStopNumber: UITextField!
    
    var b = Bus()
    let city = ["성남", "수원", "용인", "화성", "천안", "대전", "청주", "충주", "울산"]
    var cityCode = 0
    var seletedCity = ""


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cityCode = 31020
        
        cityPicker.delegate = self
        cityPicker.dataSource = self
        busStopNumber.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return city.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return city[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if city[row] == "성남" {
            cityCode = 31020
        } else if city[row] == "수원" {
            cityCode = 31010
        } else if city[row] == "용인" {
            cityCode = 31190
        } else if city[row] == "화성" {
            cityCode = 31240
        } else if city[row] == "천안" {
            cityCode = 34010
        } else if city[row] == "대전" {
            cityCode = 25
        } else if city[row] == "청주" {
            cityCode = 33010
        } else if city[row] == "충주" {
            cityCode = 33020
        } else if city[row] == "울산" {
            cityCode = 26
        }
    }
    
    //return 키 터치하면 url로 이동하고 키보드 내리는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        busStopNumber.resignFirstResponder()    //호출된 first respnder를 해지(키보드 내리기)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableView = segue.destination as! TableView
        
        tableView.busStopName = busStopName.text!
        tableView.busStopNumber = busStopNumber.text!
        tableView.cityCode = cityCode
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        let busStop = BusStop(cityCode, busStopName.text!, busStopNumber.text!)
        let busStopID = busStop.returnBusStopID()
          
        let arrBus = ArrBus(cityCode, busStopID)
        arrBus.parsing()
        //arrBus.getData()
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
