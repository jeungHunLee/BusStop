//
//  ViewController.swift
//  BusStop
//
//  Created by 이정훈 on 2022/09/14.
//

import UIKit

class Bus {
    var number = ""    //버스 번호
    var arrTime = ""  //도착 예상시간(초)
}

class ViewController: UIViewController, XMLParserDelegate {
    var currentElement = ""
    var b = Bus()
    var busInfo = [Bus]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let key = "2iHJaiAhj3is09gMRVLduJ3n3BADIaM4/GnabUgm2z7SylYvZn3uRl3aX3dWmB8CLbDQcI5bGM4FKidusGb/Og=="
        let url = "http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList?serviceKey=\(key)&cityCode=25&nodeId=DJB8001793&numOfRows=10&pageNo=1&_type=xml"
        
        let xmlParser = XMLParser(contentsOf: URL(string: url)!)
        xmlParser!.delegate = self
        xmlParser!.parse()
        
        for i in 0..<busInfo.count {
            print(busInfo[i].number)
            print(busInfo[i].arrTime)
        }
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
            b.arrTime = string
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


}
