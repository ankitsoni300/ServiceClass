 import Foundation
 import UIKit
 import Alamofire
 //import SwiftyJSON
 
 
 class ServicesClass_New : NSObject
 {
    
    var delegate : ServicesClassDelegate!
    
    typealias CompletionBlock = (_ result : Dictionary<String, Any>?, _ error : Error?) -> Void
    typealias CompletionDataBlock = (_ result : Data?) -> Void
    typealias ProgressBlock = (_ progressData : Progress) -> Void
    
    //MARK: Shared Instance
    
    static let sharedInstance : ServicesClass = {
        let instance = ServicesClass()
        return instance
    }()
    
    static func getDataFromURlWith(url:String,parameters:Dictionary<String, Any>?, requestName:String,completionBlock : @escaping CompletionBlock)
    {
        
        print("net available")
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value
                {
                    //print(response.result.value!)
                    //print(data)
                    
                    var dic : Dictionary<String,Any> = Dictionary()
                    
                    if data as? Array<Dictionary<String,Any>> != nil
                    {
                        dic["data"] = data as? Array<Dictionary<String,Any>>
                        completionBlock(dic,nil)
                    }
                    else
                    {
                        completionBlock(data as? Dictionary<String,Any>,nil)
                    }
                }
                
                break
                
            case .failure(_):
                print(response.result.error!)
                completionBlock(nil ,response.result.error!)
                break
                
            }
        }
        
    }
    
    static func postDataFromURL(url:String,parameters:Dictionary<String, Any>?, requestName:String,completionBlock : @escaping CompletionBlock)
    {
        print("net available")
        //application/json 
        //multipart/form-data
        let hders : HTTPHeaders = [ "Content-Type" : "application/json"] as [String : String]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: hders).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                if let dict = response.result.value
                {
                    let data = dict as! Dictionary<String,Any>
                    
                    // print(response.result.value!)
                    // print(data)
                    completionBlock(data as Dictionary,nil)
                }
                
                break
                
            case .failure(let error):
                print((error as NSError).localizedDescription)
                completionBlock(nil ,response.result.error!)
                print("\(error.localizedDescription)")
                
                break
                
            }
        }
    }
    
    static func downloadFile(strUrl : String, progressBlock : @escaping ProgressBlock, completionBlock : @escaping CompletionDataBlock)
    {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire.request(URL.init(string: strUrl)!).downloadProgress(queue: utilityQueue, closure: { (progress) in
            
            progressBlock(progress)
        })
            .responseData { (response) in
                
                if let data = response.result.value
                {
                    completionBlock(data)
                }
                else
                {
                    completionBlock(nil)
                }
        }
        
    }
    
    static func uploadData(url:String,parameters:Dictionary<String, Any>,requestName:String,arrImg:[UIImage],arrVideos:[URL],completionBlock : @escaping CompletionBlock)
    {
        
        print("net available")
        
        let hders = [
            
            "Content-Type": "application/json"
        ]
        
        Alamofire.upload(multipartFormData:
            {
                MultipartFormData in
                
                for img in arrImg
                {
                    let imageData = UIImageJPEGRepresentation(img , 0.8)!
                    MultipartFormData.append(imageData, withName: "image" , fileName:"file\(index).jpg", mimeType:"image/jpeg")
                }
                
                index = 0
                for video in arrVideos
                {
                    index = index + 1
                    var videoData : Data = Data()
                    do
                    {
                        videoData = try Data.init(contentsOf: URL.init(fileURLWithPath: video.path))
                        MultipartFormData.append(videoData, withName: "video", fileName:"file\(index).mp4",mimeType: "video/mp4")
                    }
                    catch
                    {
                        
                    }
                }
                for (key, value) in parameters
                {
                    MultipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
                
        }, to:url,method:.post,headers:hders, encodingCompletion: {
            encodingResult in
            
            //["content-type" : "application/json"]
            switch encodingResult
            {
            case .success(let upload, _, _):
                print("image uploaded")
                upload.responseJSON { response in

                    if let JSON = response.result.value
                    {
                        print("JSON: \(JSON)")
                    }
                    
                    if let dict = response.result.value
                    {
                        let data = dict as! Dictionary<String,Any>
                        
                        print(response.result.value!)
                        print(data)

                        completionBlock(data as Dictionary,nil)

                    }
                }
                
                break
                
            case .failure(let encodingError):
                completionBlock(nil ,encodingError)
                break
            }
        } )
        
    }
    
 }
