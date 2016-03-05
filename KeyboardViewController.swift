//
//  KeyboardViewController.swift
//  KeyboardTest
//
//  Created by Admin on 2016. 2. 18..
//  Copyright © 2016년 Admin. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    var myCustomView : MyCustomView!
    static let sharedInstance = KeyboardViewController()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:  Selector("textInputs:"),
            name: "TextChangedWithTouchUpInside",
            object: nil)
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:  Selector("funcInputs:"),
            name: "FunctionWithTouchUpInside",
            object: nil)
        
//        myCustomView = MyCustomView(frame: CGRectZero)
        myCustomView = MyCustomView.sharedInstance
        print("a ::::::  " + String(myCustomView))
//        self.view = MyCustomView(frame: CGRectZero)
        self.view = myCustomView
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .System)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("N", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
        
    }
    
    func getInstance() -> KeyboardViewController{
        return self
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    init(a: MyCustomView){
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(a)
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .System)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("N", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.backgroundColor = UIColor.whiteColor()
        self.nextKeyboardButton.layer.opacity = 0.7
        self.nextKeyboardButton.layer.cornerRadius = 10
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    func funcInputs(notification: NSNotification){
        let string = String(notification .valueForKey("object")!)
        if string == "Shi"
        {
            mClickedShift = false
        }
        else
        {
            mClickedShift = false
        }
        if string == "Del"
        {
            cleanStateAll()
            textDocumentProxy.deleteBackward()
            //            textDocumentProxy.deleteBackward()
        }
        if string == "Space"
        {
            cleanStateAll()
            textDocumentProxy.insertText(" ")
        }
        if string == "다음문장"
        {
            cleanStateAll()
            textDocumentProxy.insertText("\n")
        }
    }
    
    func cleanStateAll()
    {
        mStateChar = 0
        mCurrentString.removeAll()
        whenNeedBeforeString = ""
        newString.removeAll()
        beforeString = ""
        returnFlag = false
        isCompleted = true
    }
    
    func cleanStateAll1()
    {
        mStateChar = 1
        //        mCurrentString.removeAll()
        whenNeedBeforeString = ""
        //        newString.removeAll()
        beforeString = ""
        returnFlag = false
        isCompleted = true
    }
    
    func textInputs(notification: NSNotification){
        let string = String(notification .valueForKey("object")!)
        
        //        let myHangul = HangulInput()
        var removeFlag = true
        
        if mStateChar == 0
        {
            removeFlag = false
        }
        
        
        let result = enterNewChar(string)
        if returnFlag
        {
            newString.removeAll()
            mStateChar = 0
            beforeString = ""
            mCurrentString.removeAll()
        }
        
        if isConsonantDouble != ""
        {
            textDocumentProxy.deleteBackward()
            textDocumentProxy.insertText(isConsonantDouble)
            cleanStateAll()
            removeFlag = false
            isConsonantDouble = ""
        }
        
        if isVowelFist != ""
        {
            textDocumentProxy.insertText(isVowelFist)
            cleanStateAll()
            isVowelFist = ""
            return
        }
        
        if !isCompleted && removeFlag
        {
            textDocumentProxy.deleteBackward()
        }
        
        if needToRearrangeBeforeString
        {
            textDocumentProxy.deleteBackward()
            textDocumentProxy.insertText(whenNeedBeforeString)
            textDocumentProxy.insertText("\(result)")
        }else{
            
            textDocumentProxy.insertText(result)
        }
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation == UIInterfaceOrientation.Portrait || toInterfaceOrientation == UIInterfaceOrientation.PortraitUpsideDown
        {
            
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver("TextChangedWithTouchUpInside")
        NSNotificationCenter.defaultCenter().removeObserver("FunctionWithTouchUpInside")
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.yellowColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }
    
    
    
    
    let FIRST_CHAR : [String:Int] = [
        "ㄱ":0x1100,  "ㄴ":0x1102,  "ㄷ":0x1103,"ㄹ":0x1105, "ㅁ":0x1106, "ㅂ":0x1107, "ㅅ":0x1109,
        "ㅇ":0x110B , "ㅈ":0x110C,"ㅊ":0x110E,"ㅋ":0x110F,"ㅌ":0x1110,"ㅍ":0x1111,"ㅎ":0x1112,
        "ㄱㄱ":0x1101,  "ㄷㄷ":0x1104,   "ㅂㅂ":0x1108,  "ㅅㅅ":0x110A,  "ㅈㅈ":0x110D,
        "ㄲ":0x1101,  "ㄸ":0x1104,   "ㅃ":0x1108,  "ㅆ":0x110A,  "ㅉ":0x110D
    ]
    
    
    let SEC_CHAR : [String:Int] = [
        "ㅛ":0x116D,        "ㅕ":0x1167,        "ㅑ":0x1163,        "ㅐ":0x1162,        "ㅔ":0x1166,        "ㅗ":0x1169,
        "ㅓ":0x1165,        "ㅏ":0x1161,        "ㅣ":0x1175,        "ㅠ":0x1172,        "ㅜ":0x116E,        "ㅡ":0x1173,
        "ㅒ":0x1164,         "ㅖ":0x1168,
        "ㅗㅏ":0x116A,        "ㅗㅣ":0x116C,        "ㅗㅐ":0x116B,        "ㅜㅓ":0x116F,        "ㅜㅣ":0x1171,        "ㅜㅔ":0x1170,        "ㅡㅣ":0x1174
    ]
    
    
    
    let TRD_CHAR : [String:Int] = [
        "ㄱ":0x11A8,        "ㄴ":0x11AB,        "ㄷ":0x11AE,        "ㄹ":0x11AF,        "ㅁ":0x11B7,        "ㅂ":0x11B8,        "ㅅ":0x11BA,
        "ㅇ":0x11BC,        "ㅈ":0x11BD,        "ㅊ":0x11BE,        "ㅋ":0x11BF,        "ㅌ":0x11C0,        "ㅍ":0x11C1,        "ㅎ":0x11C2,
        "ㄱㄱ":0x11A9,        "ㄱㅅ":0x11AA,        "ㄴㅈ":0x11AC,        "ㄴㅎ":0x11AD,        "ㄹㄱ":0x11B0,        "ㄹㅁ":0x11B1,        "ㄹㅂ":0x11B2,
        "ㄲ":0x11A9, "ㅆ":0x11BB,
        "ㄹㅅ":0x11B3,        "ㄹㅌ":0x11B4,        "ㄹㅍ":0x11B5,        "ㄹㅎ":0x11B6,        "ㅂㅅ":0x11B9,        "ㅅㅅ":0x11BB    ]
    
    var mClickedShift = false                // shift버튼 클릭되었는지 여부
    var mStateChar = 0                       // 글자 상태 0:NONE  1:자음   2: 자음+모음   3:자음+모음+받침  4:쌍받침
    var mCurrentString: [String] = []        // 현재까지 완성된 글자 저장
    var whenNeedBeforeString = ""            // 이전 글자 저장이 필요한 경우 사용
    var newString : [UnicodeScalar] = []     // 글자 작성배열
    var beforeString = ""                    // 이전 글자 저장소
    var returnFlag = false                   // 글자가 새로 시작되었는지 여부
    var isCompleted = true                   // 이전 글자가 완성되었는지 여부
    var needToRearrangeBeforeString = false  // 이전 글자에 변경있는지 여부
    var isVowelFist : String = ""            // 모음이 처음으로 나타남
    var isConsonantDouble : String = ""      // 자음이 연속으로 사용됨
    
    func enterNewChar(newStr : String) -> String
    {
        needToRearrangeBeforeString = false
        returnFlag = false
        isCompleted = false
        if(mCurrentString.count > 0)
        {
            beforeString = mCurrentString[mCurrentString.count  - 1]
        }
        
        
        if mStateChar == 0
        {
            if FIRST_CHAR[newStr] != nil                                    // Normal Case
            {
                //                if mClickedShift
                //                {
                //                    var inputDoubleStr = newStr + newStr
                //                    if FIRST_CHAR[inputDoubleStr] != nil
                //                    {
                //                        newString.append(UnicodeScalar(FIRST_CHAR[inputDoubleStr]!))
                //                        mStateChar = 1
                //                        mCurrentString.append(inputDoubleStr)
                //                        return getStringWithNewString(newString)
                //                    }else
                //                    {
                //                        inputDoubleStr = newStr
                //                        newString.append(UnicodeScalar(FIRST_CHAR[newStr]!))
                //                    }
                //                }else{
                newString.append(UnicodeScalar(FIRST_CHAR[newStr]!))
                //                }
                mStateChar = 1
            }
            else if SEC_CHAR[newStr] != nil                             // USER input vowel
            {
                //                newString.removeAll()
                //                newString.append(UnicodeScalar(SEC_CHAR[newStr]!))
                //                let tempResult = getStringWithNewString(newString)
                isVowelFist = newStr
                return ""
            }
            
            
        }else if mStateChar == 1
        {
            if FIRST_CHAR[newStr] != nil                                    // USER input consonant twice
            {
                if FIRST_CHAR[beforeString + newStr] != nil
                {
                    newString[0] = (UnicodeScalar(FIRST_CHAR[newStr+beforeString]!))
                    mStateChar = 1
                }else
                {
                    isConsonantDouble = beforeString
                    mCurrentString.removeAll()
                    newString.removeAll()
                    newString.append((UnicodeScalar(FIRST_CHAR[newStr]!)))
                    let tempResult = getStringWithNewString(newString)
                    mStateChar = 1
                    mCurrentString.append(newStr)
                    return tempResult
                }
            }else if SEC_CHAR[newStr] != nil
            {
                newString.append(UnicodeScalar(SEC_CHAR[newStr]!))
                mStateChar = 2
            }
            
            
            
        }else if mStateChar == 2
        {
            if TRD_CHAR[newStr] != nil
            {
                //                if mClickedShift
                //                {
                //                    var inputDoubleStr = newStr + newStr
                //                    if TRD_CHAR[inputDoubleStr] != nil
                //                    {
                //                        newString.append(UnicodeScalar(TRD_CHAR[inputDoubleStr]!))
                //                        mStateChar = 3
                //                        mCurrentString.append(inputDoubleStr)
                //                        return getStringWithNewString(newString)
                //                    }else
                //                    {
                //                        inputDoubleStr = newStr
                //                        newString.append(UnicodeScalar(TRD_CHAR[newStr]!))
                //                    }
                //                }else{
                newString.append(UnicodeScalar(TRD_CHAR[newStr]!))
                //                }
                mStateChar = 3
            }else if SEC_CHAR[beforeString + newStr] != nil
            {
                newString.removeLast()
                newString.append(UnicodeScalar(SEC_CHAR[beforeString + newStr]!))
                mStateChar = 2
                
            }else if SEC_CHAR[newStr] != nil
            {
                newString.removeAll()
                newString.append(UnicodeScalar(SEC_CHAR[newStr]!))
                mStateChar = 0
                returnFlag = true
                isCompleted = true
            }else if FIRST_CHAR[newStr] != nil
            {
                newString.removeAll()
                newString.append(UnicodeScalar(FIRST_CHAR[newStr]!))
                mStateChar = 1
                isCompleted = true
            }
            
        }else if mStateChar == 3
        {
            if TRD_CHAR[beforeString + newStr] != nil
            {
                newString.removeLast()
                newString.append(UnicodeScalar(TRD_CHAR[beforeString+newStr]!))
                mStateChar = 4
            }else if FIRST_CHAR[newStr] != nil
            {
                mCurrentString.removeAll()
                newString.removeAll()
                newString.append(UnicodeScalar(FIRST_CHAR[newStr]!))
                mStateChar = 1
                isCompleted = true
            }else if SEC_CHAR[newStr] != nil
            {
                newString.removeLast()
                
                whenNeedBeforeString = getStringWithNewString(newString)
                mCurrentString.removeAll()
                newString.removeAll()
                newString.append(UnicodeScalar(FIRST_CHAR[beforeString]!))
                newString.append(UnicodeScalar(SEC_CHAR[newStr]!))
                isCompleted = true
                mStateChar = 2
                needToRearrangeBeforeString = true
            }
        }else if mStateChar == 4
        {
            if SEC_CHAR[newStr] != nil
            {
                newString.removeLast()
                newString.append(UnicodeScalar(TRD_CHAR[mCurrentString[mCurrentString.count - 2]]!))
                whenNeedBeforeString = getStringWithNewString(newString)
                mCurrentString.removeAll()
                newString.removeAll()
                newString.append(UnicodeScalar(FIRST_CHAR[beforeString]!))
                newString.append(UnicodeScalar(SEC_CHAR[newStr]!))
                isCompleted = true
                mStateChar = 2
                needToRearrangeBeforeString = true
            }else
            {
                mCurrentString.removeAll()
                newString.removeAll()
                newString.append(UnicodeScalar(FIRST_CHAR[newStr]!))
                mStateChar = 1
                isCompleted = true
            }
        }
        
        mClickedShift = false
        mCurrentString.append(newStr)
        return getStringWithNewString(newString)
    }
    
    
    func getStringWithNewString(uniStr : [UnicodeScalar]) -> String
    {
        var result = ""
        
        for scalar in uniStr
        {
            result.append(scalar)
        }
        
        return result
    }
    
    func refreshCurrentState()
    {
        mStateChar = 0
        newString.removeAll()
    }
    
    func removeChar()
    {
        if mStateChar == 0
        {
            
        }else if mStateChar == 1
        {
            
        }else if mStateChar == 2
        {
            
        }else
        {
            
        }
    }
    
    
}
