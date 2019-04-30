  //
  //  ChatMessage.swift
  //  MedicalApp
  //
  //  Created by Gaurav Varshney on 30/11/16.
  //  Copyright © 2016 Flexsin. All rights reserved.
  //
  
  import Foundation
  import UIKit
  import CoreData
  
  class ChatMessage: UIViewController,UITableViewDelegate,UITableViewDataSource,HPGrowingTextViewDelegate,UIGestureRecognizerDelegate,YMSPhotoPickerViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ServicesClassDelegate,NSFetchedResultsControllerDelegate,MMPopLabelDelegate
    
  {
    @IBOutlet weak var labelNavbarTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var contanierHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerConst: NSLayoutConstraint!
    
    var lastScale: CGFloat!
    
    var strDoctor_id = String()
    var strMessage_id = NSNumber()
    var strDoctorName = String()
    var isInsertRow = Bool()
    var fetchedResultsController =  NSFetchedResultsController<NSFetchRequestResult>()
    
    let cellIdentifier = "imageCellIdentifier"
    var CollectionViewImages : UICollectionView! = nil
    // var images: NSArray!
    var images = [Any]()
    var growingTextView : HPGrowingTextView!
    
    var serviceClass = ServicesClass()
    var arrDataSource = [Any]()
    
    var newString = String()
    var localId = String()
    var timer = Timer()
    var numOfRows = 0
    var strImgLocalPath = String()
    var deleteMsgId = String()
    var buttonCancel: UIButton!
    var buttonSend : UIButton!
    var lbl = MMPopLabel()
    var isFirstTime = Bool()
    var isPress = Bool()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    @IBOutlet weak var btnInfo: UIButton!
    
    override func viewDidLoad()
    {
        btnInfo.isHidden = false
        
        if !(UserDefaults.standard.object(forKey: "InitialChat") != nil)
        {
            UserDefaults.standard.set(true, forKey: "InitialChat")
        }
        
        self.lblHeader.text = String(format:"%@",strDoctorName)
        self.fetchRequest()
        
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 50
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickChatTable(_:)))
        
        tapGesture.delegate = self
        tblView.addGestureRecognizer(tapGesture)
        tblView.isUserInteractionEnabled = true
        
        self.addInputView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let layout = UICollectionViewFlowLayout()
        let deviceType = UIDevice().type.rawValue
        if deviceType == "iPhone XS Max" || deviceType == "iPhone X" || deviceType == "iPhone XS" || deviceType == "iPhoneXR"  {
            self.CollectionViewImages = UICollectionView(frame: CGRect(x: 0, y: 80, width: view.frame.size.width, height: view.frame.size.height - 64),collectionViewLayout: layout)
        }else{
            self.CollectionViewImages = UICollectionView(frame: CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height - 64),collectionViewLayout: layout)
        }
        self.CollectionViewImages.register(UINib.init(nibName: "DemoImageViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.CollectionViewImages.delegate = self
        self.CollectionViewImages.dataSource = self
        layout.scrollDirection = .horizontal
        self.view.addSubview(self.CollectionViewImages)
        self.CollectionViewImages.isHidden = true
        
        buttonCancel = UIButton(frame: CGRect(x: 0, y: self.view.frame.size.height - 40, width: self.CollectionViewImages.frame.size.width/2, height: 40))
        buttonCancel.backgroundColor = UIColor.init(red:22.0/255.0, green:141.0/255.0, blue:233.0/255.0, alpha:1.0)
        buttonCancel.setTitle("Cancel", for: .normal)
        buttonCancel.addTarget(self, action: #selector(self.buttonCancelTapped), for: .touchUpInside)
        
        buttonSend = UIButton(frame: CGRect(x: buttonCancel.frame.size.width+1, y: buttonCancel.frame.origin.y, width: self.CollectionViewImages.frame.size.width/2, height: 40))
        buttonSend.backgroundColor = UIColor.init(red:22.0/255.0, green:141.0/255.0, blue:233.0/255.0, alpha:1.0)
        buttonSend.setTitle("Send", for: .normal)
        buttonSend.addTarget(self, action: #selector(self.buttonSendTapped), for: .touchUpInside)
        
        serviceClass.delegate = self
        
        //        let parameters:Dictionary = ["lookup_id":CommonUtils.getValueFromKey("userID") as String, "doctor_lookup_id":self.strDoctor_id , "message_id":self.strMessage_id ] as [String : Any]
        //        let Url = BASE_URL + GetChatHistory
        //
        //        print(parameters)
        //
        //       // MBProgressHUD.showHUDMessage(message: "", PPview: self.view)
        //        serviceClass.postDataFromURL(url: Url, parameters: parameters, requestName: GetChatHistory)
        
        self.UpdateChat()
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.UpdateChat), userInfo: nil, repeats: true);
        
        self.view.layoutIfNeeded()
        
        let recognizer1 = UILongPressGestureRecognizer(target: self, action:#selector(self.pressChatTable(recognizer:)))
        recognizer1.delegate = self
        tblView.addGestureRecognizer(recognizer1)
        
        if let sections = fetchedResultsController.sections
        {
            let sectionsInfo = sections[0]
            numOfRows = sectionsInfo.numberOfObjects
        }
        
        if numOfRows == 0
        {
            MBProgressHUD.showHUDMessage(message: "Updating your Message...", PPview: self.view)
            
        }
        lbl = MMPopLabel.init(text:"This screen allows you to chat with the connected doctors and send or receive medical images as and when needed in real time.")
        MMPopLabel.appearance().labelColor = UIColor(red: 22.0/255.0, green: 141.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        MMPopLabel.appearance().labelTextColor = UIColor.white
        MMPopLabel.appearance().labelTextHighlightColor = UIColor.green
        
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            MMPopLabel.appearance().labelFont = UIFont(name: "Helvetica", size: CGFloat(24.0))
            MMPopLabel.appearance().buttonFont = UIFont(name: "Helvetica", size: CGFloat(24.0))
            
        }else{
            
            MMPopLabel.appearance().labelFont = UIFont(name: "Helvetica", size: CGFloat(14.0))
            MMPopLabel.appearance().buttonFont = UIFont(name: "Helvetica", size: CGFloat(14.0))
            
        }
        
        lbl.delegate = self;
        self.view.addSubview(self.lbl)
    }
    @objc func pressChatTable(recognizer: UILongPressGestureRecognizer)
    {
        
        if(!isPress)
        {
            isPress = true
            let pointInTable = recognizer.location(in: tblView)
            
            let indexPath:IndexPath = (tblView.indexPathForRow(at: pointInTable)! as IndexPath)
            let cell:UITableViewCell = tblView.cellForRow(at: indexPath)!
            cell.backgroundColor = UIColor(red: 22.0/255.0, green: 141.0/255.0, blue: 233.0/255.0, alpha: 1.0)
            let record = fetchedResultsController.object(at: indexPath)  //Record from the instance of NSFetchedResultedController
            let object : Chat = record as! Chat  //Converted Record to Entity type
            
            if(object.value(forKey: "message_type") as? String != "Noti")
            {
                let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.actionSheet)
                settingsActionSheet.addAction(UIAlertAction(title:"Delete message", style:UIAlertActionStyle.default, handler:{ action in
                    
                    self.deleteAMessage(msgId:object.value(forKey: "chat_id") as! String , doctorId: self.strDoctor_id)
                    cell.backgroundColor = UIColor.clear
                    self.isPress = false
                    
                    
                }))
                //            settingsActionSheet.addAction(UIAlertAction(title:"Delete All Message", style:UIAlertActionStyle.default, handler:{ action in
                //
                //                self.deleteAllMessage()
                //                cell.backgroundColor = UIColor.clear
                //            }))
                settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:{ action in
                    cell.backgroundColor = UIColor.clear
                    self.isPress = false
                    
                }))
                
                if (UIDevice.current.userInterfaceIdiom == .pad)
                {
                    settingsActionSheet.popoverPresentationController?.sourceView = cell;
                    // settingsActionSheet.popoverPresentationController?.sourceView = self.view;
                    settingsActionSheet.popoverPresentationController?.sourceRect = cell.bounds
                }
                
                
                present(settingsActionSheet, animated:true, completion:nil)
            }
        }
        
    }
    //message_id
    
    func deleteAMessage(msgId:String,doctorId:String)
    {
        deleteMsgId = msgId
        let parameters:Dictionary = ["lookup_id":CommonUtils.getValueFromKey("userID") as String, "doctor_lookup_id":self.strDoctor_id,"message_id":msgId] as [String : Any]
        let Url = BASE_URL + DeleteChat
        MBProgressHUD.showHUDMessage(message: "Message deleting...", PPview: self.view)
        // print(parameters)
        self.serviceClass.postDataFromURL(url: Url, parameters: parameters, requestName: DeleteChat)
    }
    
    func deleteAllMessage()
    {
        deleteMsgId = ""
        let parameters:Dictionary = ["lookup_id":CommonUtils.getValueFromKey("userID") as String, "doctor_lookup_id":self.strDoctor_id,"message_id":""] as [String : Any]
        let Url = BASE_URL + DeleteChat
        MBProgressHUD.showHUDMessage(message: "Delete All message...", PPview: self.view)
        //  print(parameters)
        self.serviceClass.postDataFromURL(url: Url, parameters: parameters, requestName: DeleteChat)
    }
    
    func deleteMessage(doctorId : String)
    {
        // let cell:UITableViewCell = tblView.cellForRow(at: indexp)!
        //cell.backgroundColor = UIColor.clear
        
        let dataEntry = DBClass.sharedInstance
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        
        // let predicate = NSPredicate(format: "((reciever_id = %@ && sender_id = %@) || (reciever_id = %@ && sender_id = %@)) AND chat_id = %@", CommonUtils.getValueFromKey("userID"), self.strDoctor_id, self.strDoctor_id, CommonUtils.getValueFromKey("userID"),msgId)
        
        let predicate = NSPredicate(format: "(reciever_id = %@ && sender_id = %@) || (reciever_id = %@ && sender_id = %@)", CommonUtils.getValueFromKey("userID"), self.strDoctor_id, self.strDoctor_id, CommonUtils.getValueFromKey("userID"))
        fetchReq.predicate = predicate
        
        var message = Array<Any>()
        
        do {
            
            message = try dataEntry.getManagedObjectContext() .fetch(fetchReq)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if (message.count != 0)
        {
            for obj in message
            {
                dataEntry.getManagedObjectContext().delete(obj as! NSManagedObject)
                
                do {
                    try dataEntry.getManagedObjectContext().save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
            
            //let lstObj = message.last as! Chat!
        }
        
        
        MBProgressHUD.hideHUD()
    }
    
    func messageDelete(msgId:String,doctorId : String)
    {
        // let cell:UITableViewCell = tblView.cellForRow(at: indexp)!
        //cell.backgroundColor = UIColor.clear
        
        let dataEntry = DBClass.sharedInstance
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        
        let predicate = NSPredicate(format: "((reciever_id = %@ && sender_id = %@) || (reciever_id = %@ && sender_id = %@)) AND chat_id = %@", CommonUtils.getValueFromKey("userID"), self.strDoctor_id, self.strDoctor_id, CommonUtils.getValueFromKey("userID"),msgId)
        
        fetchReq.predicate = predicate
        
        var message = Array<Any>()
        
        do {
            
            message = try dataEntry.getManagedObjectContext() .fetch(fetchReq)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if (message.count != 0)
        {
            for obj in message
            {
                dataEntry.getManagedObjectContext().delete(obj as! NSManagedObject)
            }
        }
        
        do {
            try dataEntry.getManagedObjectContext().save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        //        let obj = dataEntry.lastMessageObj(self.strDoctor_id)
        //        print("obj.message_type")
        //        print(obj.time!)
        //
        //        if(obj.message_type == "Noti")
        //        {
        //            print("true")
        //
        //        }else
        //        {
        //            print("false")
        //
        //        }
        
        
        MBProgressHUD.hideHUD()
        
        if numOfRows > 2
        {
            let indexPath = IndexPath(row: numOfRows-1, section: 0)
            tblView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    
    @objc func UpdateChat() {
        
        var msgId = "0" 
        
        if (DBClass.sharedInstance.lastMessage(strDoctor_id) != "")
        {
            msgId = DBClass.sharedInstance.lastMessage(strDoctor_id)
        }
        
        DispatchQueue.global(qos: .background).async {
            // print("This is run on the background queue")
            
            let parameters:Dictionary = ["lookup_id":CommonUtils.getValueFromKey("userID") as String, "doctor_lookup_id":self.strDoctor_id , "message_id":msgId] as [String : Any]
            let Url = BASE_URL + HitChatApiInEveryThreeSec
            
            //print(parameters)
            
            self.serviceClass.postDataFromURL(url: Url, parameters: parameters, requestName: HitChatApiInEveryThreeSec)
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
        }
    }
    
    func fetchRequest() {
        // Initialize Fetch Request
        
        let dataEntry = DBClass.sharedInstance
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        
        //let predicate = NSPredicate(format: "(reciever_id = %@ && sender_id = %@) || (reciever_id = %@ && sender_id = %@) || (message_type = %@)", CommonUtils.getValueFromKey("userID"), self.strDoctor_id, self.strDoctor_id, CommonUtils.getValueFromKey("userID"),"Noti")
        
        let predicate = NSPredicate(format: "(reciever_id = %@ && sender_id = %@) || (reciever_id = %@ && sender_id = %@) ", CommonUtils.getValueFromKey("userID"), self.strDoctor_id, self.strDoctor_id, CommonUtils.getValueFromKey("userID"))
        
        fetchReq.predicate = predicate
        
        // Add Sort Descriptors
        fetchReq.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReq, managedObjectContext: dataEntry.getManagedObjectContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        // Perform Fetch
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        
    }
    
    // MARK: - FetchedResultsController Delegate Methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // self.tblView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            tblView.insertRows(at: [newIndexPath!], with: .none)// Inserts new row
            break
        case .delete :
            tblView.deleteRows(at: [indexPath!], with: .none)// Delete row
            break
        case .update:
            // tblView.reloadRows(at: [indexPath!], with: .none)
            break
        case .move:
            tblView.deleteRows(at: [indexPath!], with: .none)
            tblView.insertRows(at: [newIndexPath!], with: .none)
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //self.tblView.endUpdates()
        
        print("controllerDidChangeContent")
        //        let indexPath = IndexPath(row: numOfRows-1 , section:0)
        //        tblView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    //    func updateTable() {
    //        var indexPath = IndexPath(row: numOfRows - 1, section: 0)
    //        self.tblView_ChatScreen.scrollToRow(at: indexPath, atScrollPosition: .bottom, animated: .none)
    //    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.view.addSubview(AppDelegate.getAppdelegate().imgNoti)
        self.view.addSubview(AppDelegate.getAppdelegate().lblcounter)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        var keyboardFrame: CGRect = CGRect.null
        if let info = notification.userInfo {
            keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            bottomContainerConst.constant=keyboardFrame.size.height
            self.view.layoutIfNeeded()
            
            if numOfRows > 2
            {
                let indexPath = IndexPath(row: numOfRows-1, section: 0)
                tblView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {      //  self.keyboardIsShowing = false
        bottomContainerConst.constant=0
        self.view.layoutIfNeeded()
    }
    
    func addInputView() -> Void
    {
        //        if (IS_IPHONE_5 || IS_IPHONE_4)
        //        {
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            growingTextView = HPGrowingTextView(frame: CGRect(x:60,y: 10,width:self.view.frame.size.width - 100 - 100,height: 50))
            
        }else
        {
            growingTextView = HPGrowingTextView(frame: CGRect(x:45,y: 5,width:self.view.frame.size.width - 65 - 65,height: 35))
            
        }//        }
        //        else if (IS_IPHONE_6)
        //        {
        //            growingTextView = HPGrowingTextView(frame: CGRectMake(45, 6, 245, 33))
        //
        //        }else
        //        {
        //            growingTextView = HPGrowingTextView(frame: CGRectMake(45, 6, 285, 33))
        //        }
        self.view.layoutIfNeeded()
        growingTextView.isScrollable = false;
        growingTextView.textColor = UIColor.black
        growingTextView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
        growingTextView.minNumberOfLines = 1;
        growingTextView.maxNumberOfLines = 4;
        
        
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            growingTextView.font = UIFont(name: "Helvetica", size: 25);
        }else
        {
            growingTextView.font = UIFont(name: "Helvetica", size: 15);
            
        }
        growingTextView.delegate = self;
        growingTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(2, 0, 2, 0);
        growingTextView.clipsToBounds = true;
        growingTextView.placeholder="Type Here";
        growingTextView.placeholderColor = UIColor.lightGray
        growingTextView.backgroundColor = UIColor.clear
        growingTextView.returnKeyType = UIReturnKeyType.next
        //growingTextView.keyboardType = .ASCIICapable;
        growingTextView.keyboardType = .default
        
        growingTextView.layer.cornerRadius = 1
        growingTextView.layer.borderWidth = 2.0
        growingTextView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.addSubview(growingTextView)
        
    }
    
    
    @objc func clickChatTable(_ sender: UITapGestureRecognizer)
    {
        growingTextView.resignFirstResponder()
    }
    
    // MARK: - UITable View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections
        {
            let sectionsInfo = sections[section]
            numOfRows = sectionsInfo.numberOfObjects
            return numOfRows
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let record = fetchedResultsController.object(at: indexPath)  //Record from the instance of NSFetchedResultedController
        let object : Chat = record as! Chat  //Converted Record to Entity type
        
        if(object.value(forKey: "message_type") as? String == "Media")
        {
            if (UIDevice.current.userInterfaceIdiom == .pad)
            {
                return 300
                
            }else{
                return 150
                
            }
            
        }else if(object.value(forKey: "message_type") as? String == "Noti")
        {
            if (UIDevice.current.userInterfaceIdiom == .pad)
            {
                return 70
                
            }else{
                return 35
                
            }
        }
            
        else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let record = fetchedResultsController.object(at: indexPath)  //Record from the instance of NSFetchedResultedController
        let object : Chat = record as! Chat  //Converted Record to Entity type
        
        if(object.value(forKey: "message_type") as? String == "Media")
        {
            if (UIDevice.current.userInterfaceIdiom == .pad)
            {
                return 300
                
            }else{
                return 150
                
            }
        }else if(object.value(forKey: "message_type") as? String == "Noti")
        {
            if (UIDevice.current.userInterfaceIdiom == .pad)
            {
                return 70
                
            }else{
                return 35
                
            }        }
        else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let record = fetchedResultsController.object(at: indexPath)  //Record from the instance of NSFetchedResultedController
        let object : Chat = record as! Chat  //Converted Record to Entity type
        
        if(object.value(forKey: "message_type") as? String == "Noti")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
            cell.selectionStyle = .none
            cell.imgBg.layer.cornerRadius = 7.0
            cell.imgBg.layer.borderWidth = 1.0
            cell.imgBg.layer.borderColor = UIColor.lightGray.cgColor
            
            let today = NSDate()
            let yesterday = today.addingTimeInterval(-24 * 60 * 60)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            let dateStr = dateFormatter.string(from: object.value(forKey:"time") as! Date)
            let dateStr1 = dateFormatter.string(from: today as Date)
            let dateStr2 = dateFormatter.string(from: yesterday as Date)
            
            
            if dateStr1 == dateStr
            {
                cell.lblDay.text = "Today"
                
            }
            else if dateStr2 == dateStr
            {
                cell.lblDay.text = "Yesterday"
                
            }
            else
            {
                cell.lblDay.text = dateStr
            }
            
            return cell
            
        }
        else if(object.value(forKey: "message_type") as? String == "Media"){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.selectionStyle = .none
            let chatImage = cell.contentView.viewWithTag(11) as! UIImageView
            let shadowImage = cell.contentView.viewWithTag(12) as! UIImageView
            let timeLabel = cell.contentView.viewWithTag(10) as! UILabel
            let bgImage = cell.contentView.viewWithTag(9) as! UIImageView
            
            chatImage.layer.cornerRadius = 10.0
            chatImage.layer.masksToBounds = true
            shadowImage.layer.cornerRadius = 10.0
            shadowImage.layer.masksToBounds = true
            
            let myDate = (object.value(forKey: "time") as? Date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            timeLabel.text = dateFormatter.string(from: myDate!)
            
            
            
            let imageTap = UITapGestureRecognizer()
            imageTap.addTarget(self, action: #selector(self.infoImageTapped))
            imageTap.delegate = nil
            imageTap.numberOfTapsRequired = 1
            chatImage.isUserInteractionEnabled = true
            chatImage.addGestureRecognizer(imageTap)
            
            let tempStr = object.localPathUrl! as String
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent(tempStr).path
            if FileManager.default.fileExists(atPath: filePath) {
                chatImage.image = UIImage(contentsOfFile: filePath)
            }
            else
            {
                //chatImage.image=UIImage(named:"placeholder.png")
            }
            
            if(object.value(forKey: "reciever_id") as? String == self.strDoctor_id){
                cell.leadingConstraint.constant = cell.contentView.frame.size.width - bgImage.frame.size.width - 10
                //chatImage.frame = CGRect(x:20,y:10,width:bgImage.frame.size.width - 30,height:bgImage.frame.size.height - 20)
                let myImage = UIImage(named: "blue")!
                bgImage.image=myImage.stretchableImage(withLeftCapWidth: 13, topCapHeight: 25);
            }
            else{
                //chatImage.frame = CGRect(x:10,y:10,width:bgImage.frame.size.width - 30,height:bgImage.frame.size.height - 20)
                
                cell.leadingConstraint.constant = 10
                let myImage = UIImage(named: "white")!
                bgImage.image=myImage.stretchableImage(withLeftCapWidth: 30, topCapHeight: 41);
            }
            self.view.layoutIfNeeded()
            
            return cell
        }
        else{
            if(object.value(forKey: "reciever_id") as? String == self.strDoctor_id)
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendmsgCell", for: indexPath) as! SendmsgCell
                cell.selectionStyle = .none
                
                let imgBg = cell.contentView.viewWithTag(101) as! UIImageView
                let txtViewMsg = cell.contentView.viewWithTag(102) as! UITextView
                let lblTime = cell.contentView.viewWithTag(103) as! UILabel
                
                txtViewMsg.text = object.value(forKey: "message") as! String
                
                //txtViewMsg.dataDetectorTypes = UIDataDetectorTypeAll
                
                if (UIDevice.current.userInterfaceIdiom == .pad)
                {
                    lblTime.font = UIFont (name: "Helvetica", size: 22)
                    
                }else{
                    lblTime.font = UIFont (name: "Helvetica", size: 12)
                    
                }
                
                let myDate = (object.value(forKey: "time") as? Date)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                lblTime.text = dateFormatter.string(from: myDate!)
                
                // lblTime.text = timeDifference((object.value(forKey: "time") as? Date)!, end: Date())
                
                txtViewMsg.isScrollEnabled = false
                var size : CGSize!
                size = self.sizeForTextView(txtViewMsg.text, font: txtViewMsg.font!)
                
                cell.textViewCellWidth1.constant = size.width
                
                cell.txtViewHeightCont.constant = size.height
                
                if (UIDevice.current.userInterfaceIdiom == .pad)
                {
                    if size.width > 300
                    {
                        cell.horizontalSpacingConst.constant = -180
                    }else
                    {
                        cell.horizontalSpacingConst.constant = -80
                    }
                }else{
                    if size.width > 150
                    {
                        cell.horizontalSpacingConst.constant = -90
                    }else
                    {
                        cell.horizontalSpacingConst.constant = -40
                    }
                }
                
                
                let myImage = UIImage(named: "blue")!
                imgBg.image=myImage.stretchableImage(withLeftCapWidth: 13, topCapHeight: 25)
                return cell
                
                
            }
            else // if(object.value(forKey: "reciever_id") as? String == CommonUtils.getValueFromKey("userID")){
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveMsgCell", for: indexPath) as! ReceiveMsgCell
                
                cell.selectionStyle = .none
                
                let imgBg = cell.contentView.viewWithTag(101) as! UIImageView
                let txtViewMsg = cell.contentView.viewWithTag(102) as! UITextView
                let lblTime = cell.contentView.viewWithTag(103) as! UILabel
                
                txtViewMsg.text = object.value(forKey: "message") as? String
                // txtViewMsg.dataDetectorTypes = UIDataDetectorTypeAll
                
                if (UIDevice.current.userInterfaceIdiom == .pad)
                {
                    lblTime.font = UIFont (name: "Helvetica", size: 22)
                    
                }else{
                    lblTime.font = UIFont (name: "Helvetica", size: 12)
                    
                }
                let myDate = (object.value(forKey: "time") as? Date)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                lblTime.text = dateFormatter.string(from: myDate!)
                
                //lblTime.text = timeDifference((object.value(forKey: "time") as? Date)!, end: Date())
                
                txtViewMsg.isScrollEnabled = false
                var size : CGSize!
                size = self.sizeForTextView(txtViewMsg.text, font: txtViewMsg.font!)
                
                cell.textViewWidthConst.constant = size.width
                cell.textViewHeightConst.constant = size.height
                
                if (UIDevice.current.userInterfaceIdiom == .pad)
                {
                    if size.width > 300
                    {
                        cell.horizontalSpacingConst1.constant = -180
                    }else
                    {
                        cell.horizontalSpacingConst1.constant = -80
                    }
                }else{
                    if size.width > 150
                    {
                        cell.horizontalSpacingConst1.constant = -90
                    }else
                    {
                        cell.horizontalSpacingConst1.constant = -40
                    }
                }
                
                let myImage = UIImage(named: "white")!
                imgBg.image=myImage.stretchableImage(withLeftCapWidth: 30, topCapHeight: 41)
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    
    @objc func infoImageTapped(_ recognizer: UITapGestureRecognizer)
    {
        
        let pointInTable = recognizer.location(in: tblView)
        
        let indexPath:IndexPath = (tblView.indexPathForRow(at: pointInTable)! as IndexPath)
        let cell:UITableViewCell = tblView.cellForRow(at: indexPath)!
        
        
        let record = fetchedResultsController.object(at: indexPath)  //Record from the instance of NSFetchedResultedController
        let object : Chat = record as! Chat  //Converted Record to Entity type
        
        if(object.value(forKey: "message_type") as? String == "Media")
        {
            var x:CGFloat = 0
            let scrollV = UIScrollView(frame: CGRect(x: CGFloat(x), y: CGFloat(50), width: CGFloat(self.view.frame.size.width - 20), height: CGFloat(self.view.frame.size.height - 100)))
            
            let bigImg = UIImageView()
            bigImg.frame = CGRect(x: CGFloat(x), y: CGFloat(0), width: CGFloat(scrollV.frame.size.width), height: CGFloat(scrollV.frame.size.height))
            bigImg.contentMode = .scaleAspectFit
            bigImg.isUserInteractionEnabled = true
            bigImg.contentMode = .scaleAspectFit
            bigImg.backgroundColor = UIColor.white
            
            let tempStr = object.localPathUrl! as String
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let filePath = documentsURL.appendingPathComponent(tempStr).path
            
            if FileManager.default.fileExists(atPath: filePath) {
                bigImg.image = UIImage(contentsOfFile: filePath)
            }
            else
            {
                bigImg.image=UIImage(named:"placeholder.png")
            }
            
            x = x + scrollV.frame.size.width;
            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.scale))
            pinchRecognizer.delegate = self
            bigImg.addGestureRecognizer(pinchRecognizer)
            scrollV.addSubview(bigImg)
            
            //scrollV.isPagingEnabled = true
            //scrollV.contentOffset = CGPoint(x: CGFloat(scrollV.frame.size.width * CGFloat(image.tag)), y: CGFloat(0))
            // scrollV.contentSize = CGSize(width: CGFloat(CGFloat(arrImageSource.count) * scrollV.frame.size.width), height: CGFloat(scrollV.frame.size.height))
            KGModal.sharedInstance().show(withContentView: scrollV)
        }
        
    }
    
    @objc func scale(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            // Reset the last scale, necessary if there are multiple objects with different scales
            lastScale = sender.scale
        }
        if sender.state == .began || sender.state == .changed {
            let currentScale: CGFloat = (sender.view!.layer.value(forKeyPath: "transform.scale")! as! CGFloat)
            // Constants to adjust the max/min values of zoom
            let kMaxScale: CGFloat = 2.0
            let kMinScale: CGFloat = 1.0
            var newScale: CGFloat = 1 - (lastScale - sender.scale)
            newScale = min(newScale, kMaxScale / currentScale)
            newScale = max(newScale, kMinScale / currentScale)
            let transform = sender.view?.transform.scaledBy(x: newScale, y: newScale)
            sender.view?.transform = transform!
            lastScale = sender.scale
        }
    }
    
    
    func sizeForTextView(_ text:String, font:UIFont) -> CGSize
    {
        
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            let textV:UITextView = UITextView(frame: CGRect(x:0, y:0,width:450.0,height:CGFloat.greatestFiniteMagnitude))
            textV.font = font
            textV.text = text
            textV.sizeToFit()
            //println("sizeForTextView : \(textV.frame.size)")
            
            return textV.frame.size
            
        }else{
            let textV:UITextView = UITextView(frame: CGRect(x:0, y:0,width:225.0,height:CGFloat.greatestFiniteMagnitude))
            textV.font = font
            textV.text = text
            textV.sizeToFit()
            //println("sizeForTextView : \(textV.frame.size)")
            
            return textV.frame.size
            
        }
        
    }
    @IBAction func onClickBack(_ sender: AnyObject)
    {
        timer.invalidate()
        UserDefaults.standard.set(false, forKey: "InitialChat")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAttachment(_ sender: Any) {
        
        let pickerViewController = YMSPhotoPickerViewController.init()
       // pickerViewController.numberOfPhotoToSelect = 3 //ANKITSONI
        
        let customColor = UIColor.init(red:22.0/255.0, green:141.0/255.0, blue:233.0/255.0, alpha:1.0)
        
        pickerViewController.theme.titleLabelTextColor = UIColor.white
        pickerViewController.theme.navigationBarBackgroundColor = customColor
        pickerViewController.theme.tintColor = UIColor.white
        pickerViewController.theme.orderTintColor = customColor
        pickerViewController.theme.orderLabelTextColor = UIColor.white
        pickerViewController.theme.cameraVeilColor = customColor
        pickerViewController.theme.cameraIconColor = UIColor.white
        pickerViewController.theme.statusBarStyle = .lightContent
        
        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
        // }
        //  else {
        //     self.yms_presentAlbumPhotoView(with: self)
        //  }
        
    }
    
    @IBAction func onClickSend(_ sender: Any)
    {
        UserDefaults.standard.set(false, forKey: "InitialChat")
        localId = DBClass.sharedInstance.createLocalId(Date())
        let myString = growingTextView.text
        newString = (myString?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
        
        if (newString.characters.count) > 0
        {
            
            let date = Date()
            var dict = Dictionary<String,Any>()
            dict["from"] = CommonUtils.getValueFromKey("userID")
            dict["local_id"] = localId
            dict["message"] = newString.toBase64()
            dict["ts"] = String(date.timeIntervalSince1970 * 1000.0)
            dict["message_type"] = "0"
            dict["message_id"]  = ""
            dict["to"] = self.strDoctor_id
            
            growingTextView.text = ""
            
            DispatchQueue.global(qos: .background).async {
                // print("This is run on the background queue")
                DBClass.sharedInstance.addSentMessageInDB(dict:dict)
                
                DispatchQueue.main.async {
                    //     print("This is run on the main queue, after the previous code in outer block")
                    //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0)
                    //            {
                    if self.numOfRows > 2
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            let indexPath = IndexPath(row: self.numOfRows - 1, section: 0)
                            self.tblView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                        }
                        
                    }
                }
            }
            
            
            DispatchQueue.global(qos: .background).async {
                // print("This is run on the background queue")
                
                let parameters:Dictionary = ["lookup_id":CommonUtils.getValueFromKey("userID") as String, "doctor_lookup_id":self.strDoctor_id , "message_id":"", "message":self.newString.toBase64(), "type":"0","local_id":self.localId ] as [String : Any]
                let Url = BASE_URL + PatientChatWithDoctor
                
                // print(parameters)
                
                // MBProgressHUD.showHUDMessage(message: "", PPview: self.view)
                self.serviceClass.postDataFromURL(url: Url, parameters: parameters, requestName: PatientChatWithDoctor)
                
                DispatchQueue.main.async {
                    //    print("This is run on the main queue, after the previous code in outer block")
                }
            }
            
            
        }
    }
    
    
    func sendTextMsg(text : String!) -> Void
    {
        var dict:[String:String] = Dictionary()
        dict["msg"] = text
        dict["isSender"] = "yes"
        
        let date = NSDate()
        var dateStr : String
        var timeStr : String
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = "YYYY-MM-dd-HH:mm:ss"
        dateStr = dateFormatter.string(from: date as Date)
        dateFormatter.dateFormat = "hh:mm a"
        timeStr = dateFormatter.string(from: date as Date)
        
        dict["Time"] = timeStr
        growingTextView.text=""
        
        //        tblView.beginUpdates()
        //        let IndexPathOfLastRow = IndexPath(row: arrChat.count-1, section: 0)
        //        tblView.insertRows(at: [IndexPathOfLastRow], with: UITableViewRowAnimation.none)
        //        tblView.endUpdates()
        //
    }
    
    // MARK: - growingTextView Delegates
    
    func growingTextView(_ growingTextView: HPGrowingTextView!, willChangeHeight height: Float)
    {
        let myIntValue:Int = Int(height)
        contanierHeightLayout.constant = CGFloat(myIntValue + 13);
        self.view.layoutIfNeeded()
    }
    
    //    func growingTextViewDidChange(_ growingTextView: HPGrowingTextView!)
    //    {
    //        if countElements(growingTextView.text)>0
    //        {
    //            if countElements(growingTextView.text) == 1 && growingTextView.text != "\n"
    //            {
    //                if (IS_IPHONE_5 || IS_IPHONE_4)
    //                {
    //                    self.growingTextView.frame = CGRectMake(45, 6, 235, 33)
    //                    textViewLineWidthConst.constant = 235;
    //                }
    //                else if (IS_IPHONE_6)
    //                {
    //                    self.growingTextView.frame = CGRectMake(45, 6, 290, 33)
    //                    textViewLineWidthConst.constant = 290;
    //                }else
    //                {
    //                    self.growingTextView.frame = CGRectMake(45, 6, 330, 33)
    //                    textViewLineWidthConst.constant = 330;
    //                }
    //
    //            }else if(countElements(growingTextView.text)==1 && growingTextView.text == "\n")
    //            {
    //                if (IS_IPHONE_5 || IS_IPHONE_4)
    //                {
    //                    self.growingTextView.frame = CGRectMake(45, 6, 235, 48)
    //                    textViewLineWidthConst.constant = 235;
    //                }
    //                else if (IS_IPHONE_6)
    //                {
    //                    self.growingTextView.frame = CGRectMake(45, 6, 290, 48)
    //                    textViewLineWidthConst.constant = 290;
    //
    //                }else
    //                {
    //                    self.growingTextView.frame = CGRectMake(45, 6, 330, 48)
    //                    textViewLineWidthConst.constant = 330;
    //                }
    //            }
    //        }else
    //        {
    //
    //            if (IS_IPHONE_5 || IS_IPHONE_4)
    //            {
    //                self.growingTextView.frame =  CGRectMake(45, 6, 185, 33)
    //                textViewLineWidthConst.constant = 185;
    //            }
    //            else if (IS_IPHONE_6)
    //            {
    //                self.growingTextView.frame = CGRectMake(45, 6, 240, 33)
    //                textViewLineWidthConst.constant = 240;
    //            }else
    //            {
    //                self.growingTextView.frame = CGRectMake(45, 6, 280, 33)
    //                textViewLineWidthConst.constant = 280;
    //            }
    //        }
    //    }
    //  }
    
    
    
    // MARK: - YMSPhotoPickerViewControllerDelegate
    
    func photoPickerViewControllerDidReceivePhotoAlbumAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController.init(title: "Allow photo album access?", message: "Need your permission to access photo albumbs", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewControllerDidReceiveCameraAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController.init(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
        picker.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPicking image: UIImage!) {
        picker.dismiss(animated: true) {
            self.images = [image]
            self.CollectionViewImages.reloadData()
        }
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPickingImages photoAssets: [PHAsset]!) {
        
        picker.dismiss(animated: true) {
            let imageManager = PHImageManager.init()
            let options = PHImageRequestOptions.init()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.isSynchronous = true
            
            let mutableImages: NSMutableArray! = []
            
            for asset: PHAsset in photoAssets
            {
                let scale = UIScreen.main.scale
                let targetSize = CGSize(width: (self.CollectionViewImages.bounds.width - 20*2) * scale, height: (self.CollectionViewImages.bounds.height - 20*2) * scale)
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: {
                    (image, info) in mutableImages.add(image!)
                    
                    //                if ((info?["PHImageFileURLKey"]) != nil) {
                    //                    // path looks like this -
                    //                    // file:///var/mobile/Media/DCIM/###APPLE/IMG_####.JPG
                    //                    self.strImgLocalPath = (info?["PHImageFileURLKey"] as! String)
                    //                }
                })
            }
            self.view .addSubview(self.buttonCancel)
            self.view .addSubview(self.buttonSend)
            
            if(photoAssets.count > 1)
            {
                self.lblHeader.text = "Preview Images"
                
            }else
            {
                self.lblHeader.text = "Preview Image"
                
            }
            
            self.images = mutableImages.copy() as? NSArray as! [Any]
            self.CollectionViewImages.reloadData()
            self.CollectionViewImages.isHidden = false;
        }
    }
    
    @objc func deletePhotoImage(_ sender: UIButton!) {
        let mutableImages: NSMutableArray! = NSMutableArray.init(array: images)
        mutableImages.removeObject(at: sender.tag)
        self.images = NSArray.init(array: mutableImages) as! [Any]
        self.CollectionViewImages.performBatchUpdates({
            self.CollectionViewImages.deleteItems(at: [IndexPath.init(item: sender.tag, section: 0)])
            if mutableImages.count == 0{
                buttonCancelTapped()
            }
        }, completion: nil)
    }
    
    
    // MARK: - Header Button
    @IBAction func onClickInfo(_ sender: UIButton)
    {
        self.lbl.pop(at:sender)
        
    }
    // MARK: - MMPopLabelDelegate
    
    func dismissedPopLabel(_ popLabel: MMPopLabel!)
    {
        print("disappeared")
    }
    
    func didPressButton(for popLabel: MMPopLabel!, at index: Int) {
        
        print("pressed %i",index)
        
    }
    @IBAction func onClickNotification(_ sender: Any)
    {
        self.lbl.dismiss()
        AppDelegate.getAppdelegate().showNotification(vwCntrlr: self)
        AppDelegate.getAppdelegate().imgNoti.isHidden = true
        AppDelegate.getAppdelegate().lblcounter.isHidden = true
        CommonUtils.save(toUserDefault: String(format:"%d",0), forKey: "nc")
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DemoImageViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DemoImageViewCell
        // cell.photoImageView.image =  self.images.object(at: (indexPath as NSIndexPath).item) as? UIImage
        cell.photoImageView.image = self.images[indexPath.item] as? UIImage
        cell.deleteButton.tag = (indexPath as NSIndexPath).item
        cell.deleteButton.addTarget(self, action: #selector(ChatMessage.deletePhotoImage(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    // MARK: - Custom Button Actions
    
    @objc func buttonCancelTapped(){
        
        buttonSend.removeFromSuperview()
        buttonCancel.removeFromSuperview()
        self.CollectionViewImages.isHidden = true
        self.lblHeader.text = self.strDoctorName
    }
    
    // Get path for a file in the directory
    
    @objc func buttonSendTapped(){
        
        self.lblHeader.text = self.strDoctorName
        buttonSend.removeFromSuperview()
        buttonCancel.removeFromSuperview()
        self.CollectionViewImages.isHidden = true
        // print("Selected Images Are : \(self.images)")
        
        var pngImageData : Data!
        
        for image in self.images
        {
            localId = DBClass.sharedInstance.createLocalId(Date())
            // print("image downloaded: \(image)")
            self.strImgLocalPath = ""
            
            let date = NSDate()
            let dateStr : String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-mm-yyyy"
            dateStr = dateFormatter.string(from: date as Date)
            let dt = dateFormatter.date(from:dateStr)
            //   print(dt!)
            //var documentsDirectory = paths.stringByAppendingPathComponent("/ChatFile")
            var fileURL = NSURL(fileURLWithPath:"")
            do {
                
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                fileURL = documentsURL.appendingPathComponent(String(format:"%@.jpeg",localId)) as NSURL
                pngImageData = UIImagePNGRepresentation(image as! UIImage)
                if (pngImageData != nil) {
                    
                    try pngImageData.write(to: fileURL as URL, options: .atomic)
                }
            } catch
            {
                print ("Error")
            }
            //let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            //let url = NSURL(fileURLWithPath: path)
            let filePath = fileURL.path//url.appendingPathComponent(String(format:"%@",date))?.path
            //let filePath = fileURL
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: filePath!)
            {
                print("FILE AVAILABLE")
                
                //let data = String(format:"%@",filePath!).data(using: .utf8)
                self.strImgLocalPath = (String(format:"%@.jpeg",localId)) //String(data: data!, encoding: String.Encoding.utf8)!
                
            }
            
            var dict = Dictionary<String,Any>()
            dict["from"] = CommonUtils.getValueFromKey("userID")
            dict["local_id"] = localId
            dict["message"] = ""
            dict["ts"] = String(date.timeIntervalSince1970 * 1000.0)
            dict["message_type"] = "Media"
            dict["message_id"]  = ""//self.strMessage_id
            dict["to"] = self.strDoctor_id
            dict["localPathUrl"] =  self.strImgLocalPath
            // save your image here into Document Directory
            
            DBClass.sharedInstance.addSentMessageInDB(dict:dict)
            
            DispatchQueue.main.async {
                //  print("This is run on the main queue, after the previous code in outer block")
                //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0)
                //            {
                if self.numOfRows > 2
                {
                    let indexPath = IndexPath(row: self.numOfRows - 1, section: 0)
                    self.tblView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                }
                // }
            }
            DispatchQueue.global(qos: .background).async {
                //  print("This is run on the background queue")
                
                let parameters:Dictionary = ["lookup_id":CommonUtils.getValueFromKey("userID") as String, "doctor_lookup_id":self.strDoctor_id,"local_id":self.localId ] as [String : Any]
                let Url = BASE_URL + SendImageInChat
                
                var arr = [UIImage]()
                arr.append(image as! UIImage)
                
                //   print(parameters as Any)
                // MBProgressHUD.showHUDMessage(message: "", PPview: self.xview)
                self.serviceClass.uploadSavedImage(url:Url, parameters:parameters, requestName:SendImageInChat ,arr:arr)
                
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                }
            }
        }
        
        // MARK: - API to save image on server
        
        
    }
    
    // MARK: - API Delegate
    
    func dataReceivedFromService(JSON:AnyObject, requestName : String, errorCode:Int , eroorMessage:String)
    {
        let dict = JSON as! Dictionary<String, Any>
        if (requestName == GetChatHistory)
        {
            arrDataSource.removeAll()
            if(errorCode == 200 && dict["ACK"] as! String  != "failure")
            {
                arrDataSource = dict["result"] as! Array
                // self.tblView.reloadData()
                for dict in arrDataSource
                {
                    
                    DBClass.sharedInstance.addRecievedMessageInDB(dict:dict as! Dictionary<String, Any>)
                }
            }
            else
            {
                MBProgressHUD.showToast(message: eroorMessage, name: "", PPView: self.view)
            }
            MBProgressHUD.hideHUD()
            
        }
        else if (requestName == PatientChatWithDoctor)
        {
            arrDataSource.removeAll()
            if(errorCode == 200 && dict["ACK"] as! String  != "failure")
            {
                //self.sendTextMsg(text: newString)
                DBClass.sharedInstance.addSentMessageInDB(dict:dict["result"] as! Dictionary<String, Any>)
                //                if numOfRows > 2
                //                {
                //                    let indexPath = IndexPath(row: numOfRows-1, section: 0)
                //                    tblView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                //                }
            }
            else
            {
                MBProgressHUD.showToast(message: eroorMessage, name: "", PPView: self.view)
                
            }
            MBProgressHUD.hideHUD()
            
        }
        else if (requestName == HitChatApiInEveryThreeSec)
        {
            arrDataSource.removeAll()
            if(errorCode == 200 && dict["ACK"] as! String  != "failure")
            {
                arrDataSource = dict["result"] as! Array
                // self.tblView.reloadData()
                for dict in arrDataSource
                {
                    DBClass.sharedInstance.addRecievedMessageInDB(dict:dict as! Dictionary<String, Any>)
                    self.view.layoutIfNeeded()
                    
                    if numOfRows > 2
                    {
                        let indexPath = IndexPath(row: numOfRows-1, section: 0)
                        tblView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                    }
                }
                MBProgressHUD.hideHUD()
            }
            else
            {
                //  MBProgressHUD.showToast(message: eroorMessage, name: "", PPView: self.view)
                if(!isFirstTime)
                {
                    if numOfRows > 2
                    {
                        let indexPath = IndexPath(row: numOfRows-1, section: 0)
                        tblView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                    }
                    isFirstTime = true
                }
                
            }
            MBProgressHUD.hideHUD()
            
        }
        else if (requestName == SendImageInChat)
        {
            arrDataSource.removeAll()
            if(errorCode == 200 && dict["ACK"] as! String  != "failure")
            {
                // self.tblView.reloadData()
                
                DBClass.sharedInstance.addSentMessageInDB(dict:dict["result"] as! Dictionary<String, Any>);
                self.view.layoutIfNeeded()
                
                //                    if numOfRows > 2
                //                    {
                //                        let indexPath = IndexPath(row: numOfRows-1, section: 0)
                //                                                                                                                                                                                                                                                                                                                                                                                                                                         tblView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                //                    }
                
            }
            else
            {
                //  MBProgressHUD.showToast(message: eroorMessage, name: "", PPView: self.view)
                
            }
            MBProgressHUD.hideHUD()
            
        }else if(requestName == DeleteChat)
        {
            arrDataSource.removeAll()
            
            if(errorCode == 200 && dict["ACK"] as! String  != "failure")
            {
                
                //                if deleteMsgId == ""
                //                {
                //                    self.deleteMessage(doctorId: self.strDoctor_id)
                //
                //                }else
                //                {
                self.messageDelete(msgId:deleteMsgId,doctorId: self.strDoctor_id)
                //                }
                
                
            }
            else
            {
                MBProgressHUD.showToast(message: eroorMessage, name: "", PPView: self.view)
                
            }
            //MBProgressHUD.hideHUD()
            
        }
    }
    
    func dataFailure(error:String, requestName:String, errorCode : Int)
    {
        print(errorCode)
        MBProgressHUD.hideHUD()
        MBProgressHUD.showToast(message: error, name: "cross", PPView: self.view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        AppDelegate.getAppdelegate().hideNotification()
    }
    
  }
  
  extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
  }
  
