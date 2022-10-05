//
//  ArrBus.swift
//  BusStop
//
//  Created by 이정훈 on 2022/09/18.
//

import Foundation

class Bus {
    var number = ""    //버스 번호
    var arrTime1 = 0    //도착 예상시간(초)
    var arrTime2 = 0    //도착 에상시간(초)
}

class ArrBus: NSObject, XMLParserDelegate {
    let key =  //보안상 공개하지 않습니다.
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
            
        case "nodeid":    //정류소 id
            busStopID = string
            
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
    
    /*func getData() -> Void {
        let url = URL(string: "http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList?serviceKey=\(key)&cityCode=\(cityCode)&nodeId=\(busStopID)&numOfRows=10&pageNo=1&_type=xml")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
             print(error!)
             return
             
         }
         
         if let XMLdata = data {
             //let dataString = String(data: XMLdata, encoding: .utf8)
             let data = Data(XMLdata)
             let busStopXMLPerser = XMLParser(data: data)
             busStopXMLPerser.delegate = self
             busStopXMLPerser.parse()
             
             busInfo.sort(by: { $0.number < $1.number })
             
             for i in 0..<busInfo.count {
                 print(busInfo[i].number, busInfo[i].arrTime1, busInfo[i].arrTime2)
                 
             }
             
         }
         
     }
        task.resume()
     }*/
    
    /*func getData() -> Void {
        let  busStopIDURL = "http://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnNoList?serviceKey=\(key)&cityCode=\(cityCode)&nodeNm=\(busStopName)&nodeNo=\(busStopNumber)&numOfRows=10&pageNo=1&_type=xml"
        let encodedURL = busStopIDURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let busStopURL = URL(string: encodedURL)
        let busStopSession = URLSession(configuration: .default)
        let busStopTask = busStopSession.dataTask(with: busStopURL!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            if let busStopIDXMLdata = data {
                //let dataString = String(data: busStopIDXMLdata, encoding: .utf8)
                let data = Data(busStopIDXMLdata)
                let busStopIDXMLParser = XMLParser(data: data)
                busStopIDXMLParser.delegate = self
                busStopIDXMLParser.parse()
                
                print("busStopID2 = \(self.busStopID)")
            }
        }
        busStopTask.resume()
        
        let url = URL(string: "http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList?serviceKey=\(key)&cityCode=\(cityCode)&nodeId=\(busStopID)&numOfRows=10&pageNo=1&_type=xml")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            if let XMLdata = data {
                //let dataString = String(data: XMLdata, encoding: .utf8)
                let data = Data(XMLdata)
                let busStopXMLPerser = XMLParser(data: data)
                busStopXMLPerser.delegate = self
                busStopXMLPerser.parse()
                
                busInfo.sort(by: { $0.number < $1.number })
                
                for i in 0..<busInfo.count {
                    print(busInfo[i].number, busInfo[i].arrTime1, busInfo[i].arrTime2)
                }
            }
        }
        task.resume()
        
    }*/
}
