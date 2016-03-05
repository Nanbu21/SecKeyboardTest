//
//  MyCustomView.swift
//  newSwftEx01
//
//  Created by Admin on 2016. 2. 19..
//  Copyright © 2016년 Admin. All rights reserved.
//

import UIKit


class MyCustomView: UIView {
    
    static let sharedInstance = MyCustomView(frame: CGRectZero)
    
    var KeyboardInputArray : [String] = ["ㅂ","ㅈ","ㄷ","ㄱ","ㅅ","ㅛ","ㅕ","ㅑ","ㅐ","ㅔ","ㅁ","ㄴ","ㅇ","ㄹ","ㅎ","ㅗ","ㅓ","ㅏ","ㅣ","ㅋ","ㅌ","ㅊ","ㅍ","ㅠ","ㅜ","ㅡ"]
    var KeyboardShiftArray : [String] = ["ㅃ","ㅉ","ㄸ","ㄲ","ㅆ","ㅛ","ㅕ","ㅑ","ㅒ","ㅖ","ㅁ","ㄴ","ㅇ","ㄹ","ㅎ","ㅗ","ㅓ","ㅏ","ㅣ","ㅋ","ㅌ","ㅊ","ㅍ","ㅠ","ㅜ","ㅡ"]
    var KeyboardFunction : [String] = ["Shi","Space", "다음문장","Del"]
    var KeyboardUnicodes : [Int] = []
    //    var myHangul = HangulInput()
    var changeBackgroundFlag = true
    var shiftBtn: UIButton = UIButton()
    var baBtn: UIButton = UIButton()
    var jaBtn: UIButton = UIButton()
    var daBtn: UIButton = UIButton()
    var gaBtn: UIButton = UIButton()
    var saBtn: UIButton = UIButton()
    var eeBtn: UIButton = UIButton()
    var eeBtn2: UIButton = UIButton()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var shiftFlag = false
    
    //    override init(){
    //        super.init()
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomView()
    }
    
    func getInstance() -> MyCustomView {
        return self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let imageView = UIImageView(frame: CGRectMake(0,0,screenSize.width,screenSize.height/3)); // set as you want
        imageView.image = UIImage(named: "bg_img1.png");
        addSubview(imageView)
        
        makeKeyboardButtons()
        makeRoundCorners()
        
    }
    
    func buttonDown(sender: UIButton){
        sender.backgroundColor = UIColor.blueColor()
    }
    
    func buttonPressed(sender: UIButton!) {
        sender.backgroundColor=UIColor.whiteColor()
        let uploadString = sender.titleLabel!.text;
        if shiftFlag
        {
            shiftFlag = false
            setShiftButn()
        }
        shiftBtn.backgroundColor = UIColor.darkGrayColor()
        NSNotificationCenter.defaultCenter().postNotificationName("TextChangedWithTouchUpInside", object: uploadString)
    }
    
    func funcButtonPressed(sender: UIButton!) {
        if( sender.tag == 0 && !shiftFlag)
        {
            shiftFlag = true
            setShiftButn()
        }else
        {
            shiftBtn.backgroundColor = UIColor.darkGrayColor()
            sender.backgroundColor=UIColor.darkGrayColor()
            shiftFlag = false
            setShiftButn()
        }
        let uploadString = KeyboardFunction[sender.tag];
        NSNotificationCenter.defaultCenter().postNotificationName("FunctionWithTouchUpInside", object: uploadString)
        
    }
    
    func colorButtonLongClicked(sender: AnyObject){
        let imageView = UIImageView(frame: CGRectMake(0,0,screenSize.width,screenSize.height/3)); // set
        
        
//        let myImage = NSKeyedUnarchiver.unarchiveObjectWithFile("bg_img3.png") as! UIImage
       
        imageView.image = UIImage(named: "bg_img2.png")
//        imageView.image = myImage
        addSubview(imageView)
        makeKeyboardButtons()
        makeRoundCorners()
    }
    
    func colorButtonPressed(sender: UIButton!){
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let imageView = UIImageView(frame: CGRectMake(0,0,screenSize.width,screenSize.height/3)); // set as you want
        if changeBackgroundFlag
        {
            sender.layer.opacity = 1
            imageView.image = UIImage(named: "bg_img.png");
            changeBackgroundFlag = false
        }else{
            sender.layer.opacity = 0.5
            imageView.image = UIImage(named: "bg_img1.png");
            changeBackgroundFlag = true
        }
        addSubview(imageView)
        makeKeyboardButtons()
        makeRoundCorners()
        
    }
    
    func makeKeyboardButtons()
    {
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
        var buttonWidth = screenSize.width/10.5;
        let buttonHeight = screenSize.height/13.2;
        let marginBesides = screenSize.width/10.2
        let marginLeft = screenSize.width/20
        
        for index in 0...KeyboardInputArray.count-1
        {
            
            let btn: UIButton = UIButton()
            
            if index < 10
            {
                let cgWidth : CGFloat = CGFloat(index)*marginBesides
                btn.frame=CGRectMake(marginBesides/10+cgWidth, marginBesides/20, buttonWidth, buttonHeight)
            }else if index < 19
            {
                let cgWidth : CGFloat = CGFloat(index-10)*marginBesides+marginLeft
                btn.frame=CGRectMake(marginBesides/10+cgWidth, marginBesides/10 + buttonHeight, buttonWidth, buttonHeight)
            }else
            {
                let cgWidth : CGFloat = CGFloat(index-19)*marginBesides+marginLeft+marginBesides
                btn.frame=CGRectMake(marginBesides/10+cgWidth, marginBesides/5 + buttonHeight*2, buttonWidth, buttonHeight)
            }
            btn.backgroundColor=UIColor.whiteColor()
            btn.setTitle(KeyboardInputArray[index], forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            btn.tag = index
            btn.addTarget(self, action: Selector("buttonDown:"), forControlEvents: .TouchDown)
            btn.addTarget(self, action: Selector("buttonPressed:"), forControlEvents: .TouchUpInside)
            
            
            
            if(index == 0){
                baBtn = btn
            }
            if(index == 1){
                jaBtn = btn
            }
            if(index == 2){
                daBtn = btn
            }
            if(index == 3){
                gaBtn = btn
            }
            if(index == 4){
                saBtn = btn
            }
            if(index == 8){
                eeBtn = btn
            }
            if(index == 9){
                eeBtn2 = btn
            }
            
            
            
            
            
            self.addSubview(btn)
            
        }
        
        for index in 0...KeyboardFunction.count-1
        {
            let btn: UIButton = UIButton()
            
            buttonWidth = screenSize.width/9
            if index == 0
            {
                let cgWidth : CGFloat = CGFloat(index)*marginBesides
                btn.frame=CGRectMake(marginBesides/10+cgWidth, marginBesides/5 + buttonHeight*2, buttonWidth, buttonHeight)
                shiftBtn = btn
                
            }else if index == 1
            {
                buttonWidth = screenSize.width/2.5
                btn.frame=CGRectMake(screenSize.width - buttonWidth - screenSize.width/3.5 -  marginLeft, marginBesides/3 + buttonHeight*3, buttonWidth, buttonHeight)
            }else if index == 2
            {
                buttonWidth = screenSize.width/4
                btn.frame=CGRectMake(screenSize.width - buttonWidth - marginLeft, marginBesides/3 + buttonHeight*3, buttonWidth, buttonHeight)
            }else
            {
                //                let cgWidth : CGFloat = CGFloat(index-19)*marginBesides+marginLeft+marginBesides
                btn.frame=CGRectMake(screenSize.width - 10 - buttonWidth, marginBesides/5 + buttonHeight*2, buttonWidth, buttonHeight)
            }
            btn.backgroundColor=UIColor.darkGrayColor()
            btn.setTitle(KeyboardFunction[index], forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btn.tag = index
            btn.addTarget(self, action: Selector("buttonDown:"), forControlEvents: .TouchDown)
            btn.addTarget(self, action: Selector("funcButtonPressed:"), forControlEvents: .TouchUpInside)
            self.addSubview(btn)
        }
        let longPressRec = UILongPressGestureRecognizer()

        longPressRec.addTarget(self, action: "colorButtonLongClicked:")
        let btn: UIButton = UIButton()
        buttonWidth = screenSize.width/8
        let cgWidth : CGFloat = marginLeft+marginBesides/2
        btn.backgroundColor=UIColor.yellowColor()
        btn.frame=CGRectMake(marginBesides/10+cgWidth, marginBesides/3 + buttonHeight*3, buttonWidth, buttonHeight)
        btn.addTarget(self, action: Selector("colorButtonPressed:"), forControlEvents: .TouchUpInside)
        btn.addGestureRecognizer(longPressRec)
        //        btn.addTarget(self, action: Selector("funcButtonPressed:"), forControlEvents: .TouchUpInside)
        self.addSubview(btn)
        
        
        let btn1: UIButton = UIButton()
        buttonWidth = screenSize.width/12
        btn1.backgroundColor=UIColor.purpleColor()
        btn1.frame=CGRectMake(marginBesides/10, marginBesides/3 + buttonHeight*3, buttonWidth, buttonHeight)
//        btn1.addTarget(self, action: Selector("colorButtonPressed:"), forControlEvents: .TouchUpInside)
//        btn1.addGestureRecognizer(longPressRec)
        //        btn.addTarget(self, action: Selector("funcButtonPressed:"), forControlEvents: .TouchUpInside)
        self.addSubview(btn1)
        
        
    }
    
    
    func makeRoundCorners()
    {
        for button in self.subviews
        {
            if button is UIButton
            {
                //                button.frame.size = CGSizeMake(screenWidth/15, screenHeight/15)
                button.layer.opacity = 0.5
                button.layer.cornerRadius = 10
                button.layer.masksToBounds = true
            }
        }
    }
    
    func setShiftButn(){
        if(shiftFlag)
        {
            baBtn.setTitle("ㅃ", forState: UIControlState.Normal)
            jaBtn.setTitle("ㅉ", forState: UIControlState.Normal)
            daBtn.setTitle("ㄸ", forState: UIControlState.Normal)
            gaBtn.setTitle("ㄲ", forState: UIControlState.Normal)
            saBtn.setTitle("ㅆ", forState: UIControlState.Normal)
            eeBtn.setTitle("ㅒ", forState: UIControlState.Normal)
            eeBtn2.setTitle("ㅖ", forState: UIControlState.Normal)
            
        }else
        {
            baBtn.setTitle("ㅂ", forState: UIControlState.Normal)
            jaBtn.setTitle("ㅈ", forState: UIControlState.Normal)
            daBtn.setTitle("ㄷ", forState: UIControlState.Normal)
            gaBtn.setTitle("ㄱ", forState: UIControlState.Normal)
            saBtn.setTitle("ㅅ", forState: UIControlState.Normal)
            eeBtn.setTitle("ㅐ", forState: UIControlState.Normal)
            eeBtn2.setTitle("ㅔ", forState: UIControlState.Normal)
        }
    }
    
}