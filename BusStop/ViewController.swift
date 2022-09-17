//
//  ViewController.swift
//  BusStop
//
//  Created by 이정훈 on 2022/09/17.
//

import UIKit

var busInfo = [Bus]()

class Bus {
    var number = ""    //버스 번호
    var arrTime = 0  //도착 예상시간(초)
}


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, XMLParserDelegate {
    @IBOutlet var cityPicker: UIPickerView!
    @IBOutlet var busStopName: UILabel!
    @IBOutlet var busStopNumber: UILabel!
    
    var currentElement = ""
    var b = Bus()
    let city = ["성남", "수원", "용인", "화성", "청주", "충주"]
    var cityCode = 0
    var seletedCity = ""


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cityCode = 31020
        
        cityPicker.delegate = self
        cityPicker.dataSource = self
    }
    
    //XML 파서가 start 태그를 만나면 호출되는 함수
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) -> Void {
        currentElement = elementName
            
        if currentElement == "item" {
                b = Bus()
        }
    }
        
    //현재 태그에 담겨 있는 문자열 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) -> Void {
        switch currentElement {
        case "routeno":    //노선 번호
            b.number = string
        case "arrtime":    //도착 시간
            b.arrTime = Int(string)!
        default:
            break
        }
            //print(string)
    }
        
    //XMl 파서가 end 태그를 만나면 호출되는 함수
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) -> Void {
        if elementName == "item" {
            busInfo.append(b)
        }
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
        } else if city[row] == "청주" {
            cityCode = 33010
        } else if city[row] == "충주" {
            cityCode = 33020
        }
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        let busStop = BusStop(cityCode, busStopName.text!, busStopNumber.text!)
        let busStopID = busStop.returnBusStopID()
        
        let key = "2iHJaiAhj3is09gMRVLduJ3n3BADIaM4/GnabUgm2z7SylYvZn3uRl3aX3dWmB8CLbDQcI5bGM4FKidusGb/Og=="
        let busStopURL = "http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList?serviceKey=\(key)&cityCode=\(cityCode)&nodeId=\(busStopID)&numOfRows=10&pageNo=1&_type=xml"
        
        let busStopXmlParser = XMLParser(contentsOf: URL(string: busStopURL)!)
        busStopXmlParser!.delegate = self
        busStopXmlParser!.parse()
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
