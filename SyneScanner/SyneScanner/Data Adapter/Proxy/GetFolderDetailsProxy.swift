//
//  GetFolderDetailsProxy.swift
//  SyneScanner
//
//  Created by Markel on 17/11/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

@objc protocol GetFolderDetailsDelegate {
    @objc optional func getfoldereDetailsSuccess(folderId:String)
    @objc optional func closeFolderSuccessfully(response:String)

    func getFolderDetailFailed(errorMessage:String)
    
}
class GetFolderDetailsProxy: NetworkManager {
    //MARK: - Properties
    var delegate:GetFolderDetailsDelegate?
    
    var apiName = ""
    func getFolderDetailsFromServer()
    {
        apiName = GET_FOLDER_ID
        super.callPostMethodReuturnStringResponse(url: GET_FOLDER_ID)
    }
    
    func closeFolder()
    {
        apiName = CLOSE_FOLDER
        let url = String(format: "%@%@/Closed",CLOSE_FOLDER,SharedData.sharedInstance.guid)
        super.callPostMethod(headers: [:], paramaters: [:], url: url)

    }
    //MARK: - Response callback methods
    override func successCallBack(response:Any) {
        
        if apiName == GET_FOLDER_ID
        {
            delegate?.getfoldereDetailsSuccess!(folderId: response as! String )

        }
        else{
            delegate?.closeFolderSuccessfully!(response: response as! String )

        }
       
    }
    
    override func failureCallBack(error:String)
    {
        delegate?.getFolderDetailFailed(errorMessage: error)
        
    }

}
