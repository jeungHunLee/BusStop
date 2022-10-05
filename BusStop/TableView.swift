//
//  ArrViewController.swift
//  BusStop
//
//  Created by 이정훈 on 2022/09/17.
//

import UIKit

var busInfo = [Bus]()

class TableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cityCode = 0
    var busStopName = ""
    var busStopNumber = ""
    
    @IBOutlet var table: UITableView!
    @IBOutlet var busStopNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        table.delegate = self
        table.dataSource = self
        
        busStopNameLabel.text! = busStopName
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        
        cell.busNumber.text = "\(busInfo[(indexPath as NSIndexPath).row].number)"
        
        if busInfo[(indexPath as NSIndexPath).row].arrTime1 > 60 {
            let min = (busInfo[(indexPath as NSIndexPath).row].arrTime1) / 60
            let sec = (busInfo[(indexPath as NSIndexPath).row].arrTime1) % 60
            
            cell.arrTime1.text = "\(min)분 \(sec)초 뒤 도착"
        } else {
            cell.arrTime1.text = "잠시 후 도착할 예정"
        }
        
        if busInfo[(indexPath as NSIndexPath).row].arrTime2 == 0 {
            cell.arrTime2.text = "도착 정보 없음"
        } else {
            if busInfo[(indexPath as NSIndexPath).row].arrTime2 > 60 {
                let min = (busInfo[(indexPath as NSIndexPath).row].arrTime2) / 60
                let sec = (busInfo[(indexPath as NSIndexPath).row].arrTime2) % 60
                
                cell.arrTime2.text = "\(min)분 \(sec)초 뒤 도착"
            } else {
                cell.arrTime2.text = "잠시 후 도착 예정"
            }
        }
        return cell
    }
    
    //행 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busInfo.count
    }
    
    //행 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    /*@IBAction func reload(_ sender: UIBarButtonItem) {
        let busStop = BusStop(cityCode, busStopName, busStopNumber)
        let busStopID = busStop.returnBusStopID()
        
        let arrBus = ArrBus(cityCode, busStopID)
        arrBus.parsing()
        
    }*/
    
    deinit {
        busInfo = [Bus]()
    }

}

class CustomCell: UITableViewCell {
    @IBOutlet var busNumber: UILabel!
    @IBOutlet var arrTime1: UILabel!
    @IBOutlet var arrTime2: UILabel!
}
