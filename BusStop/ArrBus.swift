//
//  ArrBus.swift
//  BusStop
//
//  Created by 이정훈 on 2022/09/18.
//

import Foundation

var busInfo = [Bus]()

class Bus {
    var number = ""    //버스 번호
    var arrTime = 0  //도착 예상시간(초)
}

class ArrBus: NSObject, XMLParserDelegate {
    let key = "2iHJaiAhj3is09gMRVLduJ3n3BADIaM4/GnabUgm2z7SylYvZn3uRl3aX3dWmB8CLbDQcI5bGM4FKidusGb/Og=="
    var currentElement = ""
    var cityCode: Int
    var busStopID: String
    var b = Bus()
    
    init(_ cityCode: Int, _ busStopID: String) {
        self.cityCode = cityCode
        self.busStopID = busStopID
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
    
    func parsing() {
        let busStopURL = "http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList?serviceKey=\(key)&cityCode=\(cityCode)&nodeId=\(busStopID)&numOfRows=10&pageNo=1&_type=xml"
        
        let busStopXmlParser = XMLParser(contentsOf: URL(string: busStopURL)!)
        busStopXmlParser!.delegate = self
        busStopXmlParser!.parse()
        
        busInfo.sort(by: { $0.arrTime < $1.arrTime })
    }
}
