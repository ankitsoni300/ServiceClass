
//
//  APIConstants.swift
//  Como App
//
//  Created by Ankit Goel on 18/04/18.
//

import UIKit

class APIConstants: NSObject {
    
    
    /************ Test Server  ************/
    //static let baseUrl : String = "http://flexsin.org/lab/mobilewebservice/comoapp/Webservices/"
    
    /************ Live Server  ************/
    static let baseUrl : String = "http://54.215.163.132/Webservices/"
    
    //GET
    //http://flexsin.org/lab/mobilewebservice/comoapp/Webservices/performerrating.json
    //POST
    static let signUp : String = baseUrl + "signup.json"
    static let login : String = baseUrl + "login.json"
    static let forgot_password : String = baseUrl + "forgot_password.json"
    static let logout : String = baseUrl + "logout.json"
    static let change_password : String = baseUrl + "change_password.json"
    static let social_login : String = baseUrl + "social_login.json"
    static let post_task : String = baseUrl + "post_task.json"
    static let category : String = baseUrl + "category.json"
    static let initiatorpendingtask : String = baseUrl + "initiatorpendingtask.json"
    static let initiatorcompletedtask : String = baseUrl + "initiatorcompletedtask.json"
    static let user_profile : String = baseUrl + "user_profile.json"
    static let update_profile : String = baseUrl + "update_profile.json"
    static let task_details : String = baseUrl + "task_details.json"
    static let hometask : String = baseUrl + "hometask.json"
    static let followuser : String = baseUrl + "followuser.json"
    static let updatelocation : String = baseUrl + "updatelocation.json"
    static let findusers : String = baseUrl + "findusers.json"
    static let assigntask : String = baseUrl + "assigntask.json"
    static let update_task : String = baseUrl + "update_task.json"
    static let getFollowersUsers : String = baseUrl + "getFollowersUsers.json"
    static let getFollowingUsers : String = baseUrl + "getFollowingUsers.json"
    static let skip_task : String = baseUrl + "skip_task.json"
    static let accept_task : String = baseUrl + "accept_task.json"
    static let performerpendingtask : String = baseUrl + "performerpendingtask.json"
    static let performerrating : String = baseUrl + "performerrating.json"
    static let uploadVideoImage : String = baseUrl + "uploadvideo.json"
    static let performedCompletedTask : String = baseUrl + "performercompletedtask.json"
    static let raiseDisputeTask : String = baseUrl + "disputetask.json"
    static let performerSquabbles : String = baseUrl + "performersqabblestask.json"
   // static let InitiatorSquabbles : String = baseUrl + "diputedtask.json"
    static let cancelTask : String = baseUrl + "canceltask.json"
    static let InitiatorSquabbles : String = baseUrl + "initiatorsqabblestask.json"
    static let AddBankDetails : String = baseUrl + "addBankDetails.json"
    static let AddUpdateCardDetails : String = baseUrl + "updateCardDetails.json"
    static let ApproveDisapproveTask : String = baseUrl + "approvedordisapprovedbyinitiator.json"
    static let SquabblesList : String = baseUrl + "getallsqabbles.json"
    static let LikeDislikeSquabbles : String = baseUrl + "diputelikedislike.json"
    static let DisLike : String = baseUrl + "videodislike.json"
    static let BankDetailsList : String = baseUrl + "getbankDetailByUser.json"
    static let DeleteBankDetailsList : String = baseUrl + "deletebankdetails.json"
    static let PubliVideoLike : String = baseUrl + "videolike.json"
    static let PublicVideo : String = baseUrl + "publicvideos.json"
    static let TaskReportByUser : String = baseUrl + "taskreportbyuser.json"
    static let StripePayment : String = baseUrl + "strippayment.json"
    static let TransactionDetails : String = baseUrl + "paymenthistory.json"
    static let TopRatedUsers : String = baseUrl + "topRatedUsers.json"
    static let SearchUserList : String = baseUrl + "findusers.json"
    static let AssignTaskPublicOrPrivate : String = baseUrl + "videopublish.json"
    static let WithDrawCubes : String = baseUrl + "withdrawalrequest.json"
    static let MyVideoList : String = baseUrl + "myvideos.json"
    static let NotificationList : String = baseUrl + "getAllNotification.json"
    static let NotificationCount : String = baseUrl + "unreadnotification.json"
    static let DeleteNotification : String = baseUrl + "notificationdelete.json"
    static let GetKubeRate : String = baseUrl + "getKubeRate.json"
    static let Usercontact : String = baseUrl + "usercontact.json"
    static let NotificationUpdateStatus : String = baseUrl + "notificationUpdateStatus.json"
    static let Hidepublicvideos : String = baseUrl + "hidepublicvideos.json"
    static let DisapprovedAccept : String = baseUrl + "disapprovedAccept.json"
}
