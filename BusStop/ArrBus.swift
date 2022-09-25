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
    var arrTime1 = 0    //도착 예상시간(초)
    var arrTime2 = 0    //도착 에상시간(초)
}

class ArrBus: NSObject, XMLParserDelegate {
    let key = "2iHJaiAhj3is09gMRVLduJ3n3BADIaM4/GnabUgm2z7SylYvZn3uRl3aX3dWmB8CLbDQcI5bGM4FKidusGb/Og=="
    var currentElement = ""
    var cityCode: Int
    var busStopID: String
    var isExisting = false
    var arriveTime = 0
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
            for i in 0..<busInfo.count {
                if busInfo[i].number == string {
                    isExisting = true
                }
            }
            
            if !isExisting {     //존재하지 않으면 추가
                b.number = string
                b.arrTime1 = arriveTime
            }
            else {
                for i in 0..<busInfo.count {
                    if busInfo[i].number == string {
                        busInfo[i].arrTime2 = arriveTime
                        if busInfo[i].arrTime1 > busInfo[i].arrTime2 {
                            (busInfo[i].arrTime1, busInfo[i].arrTime2) = (busInfo[i].arrTime2, busInfo[i].arrTime1)
                        }
                    }
                }

            }
            
        case "arrtime":    //도착 시간
            arriveTime = Int(string)!
            
        default:
            break
        }
    }
        
    //XMl 파서가 end 태그를 만나면 호출되는 함수
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) -> Void {
        if elementName == "item" {
            if b.number != "" {
                busInfo.append(b)
            }
        }
        
        isExisting = false
    }
    
    func parsing() {
        let busStopURL = "http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList?serviceKey=\(key)&cityCode=\(cityCode)&nodeId=\(busStopID)&numOfRows=10&pageNo=1&_type=xml"
        
        let busStopXmlParser = XMLParser(contentsOf: URL(string: busStopURL)!)
        busStopXmlParser!.delegate = self
        busStopXmlParser!.parse()
        
        busInfo.sort(by: { $0.number < $1.number })
    }
}
