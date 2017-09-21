//
//  DataAdapter.swift
//  ServiceBot
//
//  Created by rupendra on 10/10/16.
//  Copyright © 2016 Example. All rights reserved.
//

import UIKit
import ATKit


var kRequestClass :DataAdapterRequest.Type = HttpRequest.self

class RequestUrl: NSObject {
    internal static func baseUrl() ->String {
        return "https://ocr-demo-api.azurewebsites.net/api/"
    }
    
    internal static func genrateUploadImageUrl() ->String {
        return RequestUrl.baseUrl() + "CommonBlob/UploadFile"
    }
}

public enum DataAdapterRequestType: String {
    case none = "none"
    case uploadImage = "uploadImage"
    case startWorkFlow = "startWorkFlow"

    
    static let allValues = [uploadImage, startWorkFlow]
    
    
    public init(rawValue pRawValue :String) {
        var aValue :DataAdapterRequestType = DataAdapterRequestType.none
        for aCase in DataAdapterRequestType.allValues {
            if aCase.rawValue == pRawValue {
                aValue = aCase
                break
            }
        }
        self = aValue
    }
}

class DataAdapterRequest: NSObject {
    var id: String!
    var tag: String!
    var indexNo:Int! // for different images

}

class HttpRequest: DataAdapterRequest {
    var urlString: String!
    var httpMethod: String!

    var httpRequestHeaders: Array<[String:String]>!
    var httpRequestBody: Data!
    var httpRequestParameters: Array<[String:Data]>!
    var httpRequestAttachments: Array<HttpRequestAttachment>!
}

class HttpRequestAttachment: NSObject {
    var requestParameterName: String!
    var title: String!
    var ext: String!
    var data: Data!
    
    
    override init() {
        super.init()
    }
    
    init(requestParameterName pRequestParameterName :String, title pTitle :String, ext pExtension :String, data pData :Data) {
        super.init()
        
        self.requestParameterName = pRequestParameterName
        self.title = pTitle
        self.ext = pExtension
        self.data = pData
    }
}

class StubRequest: DataAdapterRequest {
    var query: String!
}

/**
 * Data adapter sqlite request.
 */
fileprivate class SqliteRequest: DataAdapterRequest {
    var queryString: String!
    var queryValues: Array<AnyObject>!
}

class DataAdapterResult: NSObject {
    var result: Any!
    var error: NSError!
}


@objc protocol DataAdapterDelegate {
    @objc optional func dataAdapterDidExecuteRequest(sender pSender:DataAdapter, request pRequest :DataAdapterRequest, result pResult :DataAdapterResult)
}


class DataAdapter: NSObject, ATNetworkManagerDelegate {
    weak var delegate :DataAdapterDelegate!
    
    private var currentRequest :DataAdapterRequest!
    
    private var networkManager :ATNetworkManager = ATNetworkManager()
    
    private var _isRequestInProgress :Bool = false
    var isRequestInProgress :Bool {
        get {
            return _isRequestInProgress
        }
    }
    
    
    private func executeRequest(_ pRequest:DataAdapterRequest) {
        self._isRequestInProgress = true
        self.currentRequest = pRequest
        
        if pRequest is HttpRequest {
            let anHttpRequest :HttpRequest = pRequest as! HttpRequest
            
            self.networkManager.delegate = self
            
            // Assign request id
            self.networkManager.requestId = anHttpRequest.id
            
            // Assign request url
            self.networkManager.urlString = anHttpRequest.urlString
            
            // Assign request method
            self.networkManager.httpMethod = anHttpRequest.httpMethod
            
            // Assign request headers
            if anHttpRequest.httpRequestHeaders != nil {
                self.networkManager.httpRequestHeaders = anHttpRequest.httpRequestHeaders
            } else {
                self.networkManager.httpRequestHeaders = nil
            }
            
            // Assign request body
            self.networkManager.httpRequestBody = anHttpRequest.httpRequestBody
            
            // Assign request body form parameters
            if anHttpRequest.httpRequestParameters != nil {
                var anHttpRequestParameterDict :[String:Data] = [:]
                for anHttpRequestParameter in anHttpRequest.httpRequestParameters {
                    anHttpRequestParameterDict[anHttpRequestParameter.keys.first!] = anHttpRequestParameter[anHttpRequestParameter.keys.first!]
                }
                self.networkManager.httpRequestParameters = anHttpRequestParameterDict
            } else {
                self.networkManager.httpRequestParameters = nil
            }
            
            // Assign request attachments
            if anHttpRequest.httpRequestAttachments != nil {
                var aNetworkManagerAttachmentArray :Array<ATNetworkManagerAttachment> = Array<ATNetworkManagerAttachment>()
                for anHttpRequestAttachment in anHttpRequest.httpRequestAttachments {
                    let aNetworkManagerAttachment :ATNetworkManagerAttachment = ATNetworkManagerAttachment(requestParameterName: anHttpRequestAttachment.requestParameterName, fileTitle: anHttpRequestAttachment.title, fileExtenstion: anHttpRequestAttachment.ext, fileData: anHttpRequestAttachment.data)
                    aNetworkManagerAttachmentArray.append(aNetworkManagerAttachment)
                }
                self.networkManager.httpRequestAttachments = aNetworkManagerAttachmentArray
                self.networkManager.encodeAttachmentsInBase64 = false
            } else {
                self.networkManager.httpRequestAttachments = nil
                self.networkManager.encodeAttachmentsInBase64 = false
            }
            
            // Assign response mapper
            self.networkManager.responseMapper = {requestId, responseStatusCode, responseHeaders, responseBodyData in
                let aReturnVal :ATNetworkManagerResult = ATNetworkManagerResult()
                
                if self.currentRequest != nil && self.currentRequest.tag != nil && self.currentRequest.id == requestId {
                    let aDataAdapterResult :DataAdapterResult = DataAdapter.mapResponse(requestType: DataAdapterRequestType(rawValue: self.currentRequest.tag!), responseStatusCode: responseStatusCode, responseHeaders: responseHeaders, responseBodyData: responseBodyData as? Data, sqliteResult: nil)
                    aReturnVal.error = aDataAdapterResult.error
                    if aDataAdapterResult.result != nil {
                        aReturnVal.result = aDataAdapterResult.result as AnyObject
                    }
                } else {
                    aReturnVal.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey : "Can not find current request."])
                }
                
                return aReturnVal
            }
            
            // Send request
            self.networkManager.sendRequest(asynchronously: true)
        }
    }
    
    
    func didExecuteRequest(_ pRequest: DataAdapterRequest, result pResult: DataAdapterResult) {
        self._isRequestInProgress = false
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.dataAdapterDidExecuteRequest?(sender: self, request: pRequest, result: pResult)
        })
    }
    
    
    internal func defaultDirectLineRequestHeaders() -> Array<[String:String]> {
        var aReturnVal :Array<[String:String]> = Array<[String:String]>()
        
        aReturnVal.append(["Content-Type" : "application/json; charset=utf-8"])
        
        return aReturnVal
    }
    
    
    
    
    
    internal func uploadImage(indexNo:Int,img:UIImage) {
       
            var aRequest :DataAdapterRequest!
            let aRequestId :String = UUID().uuidString
            let aRequestTag :String = DataAdapterRequestType.uploadImage.rawValue
            
            if kRequestClass == HttpRequest.self {
                // Create request
                let anHttpRequest :HttpRequest = HttpRequest()
                
                // Assign request id
                anHttpRequest.id = aRequestId
                
                // Assign request tag
                anHttpRequest.tag = aRequestTag
                
                anHttpRequest.indexNo = indexNo
                // Assign request url
                
                    anHttpRequest.urlString = RequestUrl.genrateUploadImageUrl()
                
                
                // Assign request method
                anHttpRequest.httpMethod = "POST"
                
                // Assign request headers
                let aRequestHeaderArray = self.defaultDirectLineRequestHeaders()
                anHttpRequest.httpRequestHeaders = aRequestHeaderArray
                
                
                    
                    // Assign request attachments
                    let aBodyData :NSMutableData = NSMutableData()
                    let aBoundary = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                    anHttpRequest.httpRequestHeaders.append(["Content-Type" : String(format: "multipart/form-data; boundary=%@", aBoundary)])
                    
                
                            let aContentType :String = ATMimeType.imageJpeg.rawValue
                            let aRequestParameterName :String = "file"
                            let aRequestParameterData :Data! = UIImageJPEGRepresentation(img, 1.0)
                            let aFileName :String = "image.jpg"
                            
                            aBodyData.append(String(format: "\r\n--%@\r\n", aBoundary).data(using: String.Encoding.utf8)!)
                            aBodyData.append(String(format: "Content-Type: %@\r\n", aContentType).data(using: String.Encoding.utf8)!)
                            aBodyData.append(String(format: "Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", aRequestParameterName, aFileName).data(using: String.Encoding.utf8)!)
                            aBodyData.append(String(format: "Content-Length: %lu\r\n", aRequestParameterData.count).data(using: String.Encoding.utf8)!)
                            aBodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                            aBodyData.append(aRequestParameterData)
                            //aBodyData.append(String(format: "\r\n--%@", aBoundary).data(using: String.Encoding.utf8)!)
                
                    anHttpRequest.httpRequestBody = aBodyData as Data!
                    
                // Assign request
                aRequest = anHttpRequest
            }
            
            // Send request
            self.executeRequest(aRequest)
         
    }
    
     internal static func mapResponse(requestType pRequestType :DataAdapterRequestType?, responseStatusCode pResponseStatusCode :Int?, responseHeaders pResponseHeaders:[AnyHashable:Any]?, responseBodyData pResponseBodyData:Data?, sqliteResult pSqliteResult:Array<[String:AnyObject]>?) -> DataAdapterResult {
        let aReturnVal = DataAdapterResult()
        
        do {
            if pRequestType == DataAdapterRequestType.uploadImage
            {
                var aResponseDict :Any!
                do {
                    if pResponseBodyData != nil {
                        aResponseDict = try JSONSerialization.jsonObject(with: pResponseBodyData!, options: JSONSerialization.ReadingOptions.allowFragments)
                    }
                } catch {
                    NSLog("JSONSerialization exception")
                }
                if pResponseStatusCode != 200
                     && pResponseStatusCode != 204 {
                    var aMessage :String!
                    if aResponseDict != nil && (aResponseDict as! NSDictionary).value(forKey: "error") is NSDictionary {
                        let anErrorDict :NSDictionary = (aResponseDict as! NSDictionary).value(forKey: "error") as! NSDictionary
                        if anErrorDict.value(forKey: "message") is String {
                            aMessage = anErrorDict.value(forKey: "message") as! String
                        }
                    }
                    throw ATError.generic((aMessage != nil ? (aMessage as String) : "Unknown Error"))
                }
            }
        }
        catch ATError.generic(let pErrorMessage) {
            NSLog("mapResponse error")
            aReturnVal.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:pErrorMessage])
        } catch {
            NSLog("mapResponse exception")
            aReturnVal.error = NSError(domain: "com", code: 1, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription])
        }
        return aReturnVal
    }
    
    
    // MARK: ATNetworkManager Methods
    
    func atNetworkManagerDidExecuteRequest(sender pSender:ATNetworkManager, requestId pRequestId: String, result pResult: ATNetworkManagerResult) {
        if self.currentRequest != nil && self.currentRequest.tag != nil && pRequestId == self.currentRequest.id {
            let aDataAdapterResult :DataAdapterResult = DataAdapterResult()
            aDataAdapterResult.error = pResult.error
            aDataAdapterResult.result = pResult.result
            self.didExecuteRequest(self.currentRequest!, result: aDataAdapterResult)
        }
    }
    
    
    // MARK:- SQLite Methods
    
}
