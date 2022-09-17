//
//  BusStop.swift
//
//  Created by 이정훈 on 2022/09/17.
//

import Foundation

class BusStop: NSObject, XMLParserDelegate {
    var cityCode: Int
    var busStopName: String
    var busStopNumber: String
    var currentElement = ""
    var busStopID: String = ""
    
    init(_ cityCode: Int, _ busStopName: String, _ busStopNumber: String) {
        self.cityCode = cityCode
        self.busStopName = busStopName
        self.busStopNumber = busStopNumber
    }
    
    //XML 파서가 start 태그를 만나면 호출되는 함수
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) -> Void {
        currentElement = elementName
    }
    
    //현재 태그에 담겨 있는 문자열 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) -> Void {
        switch currentElement {
        case "nodeid":    //정류소 id
            busStopID = string
        default:
            break
        }
    }
    
    //XMl 파서가 end 태그를 만나면 호출되는 함수
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) -> Void {
    }
    
    func returnBusStopID() -> String {
        let key = //보안상 공개하지 않습니다.
        let  busStopIDURL = "http://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnNoList?serviceKey=\(key)&cityCode=\(cityCode)&nodeNm=\(busStopName)&nodeNo=\(busStopNumber)&numOfRows=10&pageNo=1&_type=xml"
        let encodedString = busStopIDURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let busStopIDXmlParser = XMLParser(contentsOf: URL(string: encodedString)!)
        busStopIDXmlParser!.delegate = self
        busStopIDXmlParser!.parse()
        
        return busStopID
    }
}
