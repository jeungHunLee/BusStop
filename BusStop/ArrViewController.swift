//
//  ArrViewController.swift
//  BusStop
//
//  Created by 이정훈 on 2022/09/17.
//

import UIKit

class TableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        table.delegate = self
        table.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        
        cell.busNumber.text = "\(busInfo[(indexPath as NSIndexPath).row].number)"
        
        if busInfo[(indexPath as NSIndexPath).row].arrTime > 60 {
            let min = (busInfo[(indexPath as NSIndexPath).row].arrTime) / 60
            let sec = (busInfo[(indexPath as NSIndexPath).row].arrTime) % 60
            
            cell.arrTime.text = "\(min)분 \(sec)초 후 도착"
        } else {
            cell.arrTime.text = "잠시 후 도착할 예정"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

}

class CustomCell: UITableViewCell {
    @IBOutlet var busNumber: UILabel!
    @IBOutlet var arrTime: UILabel!
}
