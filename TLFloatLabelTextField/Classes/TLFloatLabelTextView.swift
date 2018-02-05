import UIKit

@IBDesignable class TLFloatLabelTextView: UITextView {
    let animationDuration = 0.0
    let placeholderTextColor = UIColor.lightGray.withAlphaComponent(0.65)
    fileprivate var isIB = false
    fileprivate var titleLabel = UILabel()
    fileprivate var hintLabel = UILabel()
    fileprivate var initialTopInset:CGFloat = 0
    let bottomLineView = UIView()
    // MARK:- Properties
    override var accessibilityLabel:String? {
        get {
            if text.isEmpty {
                return titleLabel.text!
            } else {
                return text
            }
        }
        set {
        }
    }
    
    var titleFont:UIFont = UIFont.boldSystemFont(ofSize: 15.0) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    @IBInspectable var hint:String = "" {
        didSet {
            titleLabel.text = hint
            titleLabel.sizeToFit()
            var r = titleLabel.frame
            r.size.width = frame.size.width
            titleLabel.frame = r
            hintLabel.text = hint
            hintLabel.sizeToFit()
        }
    }
    
    @IBInspectable var hintYPadding:CGFloat = 0.0 {
        didSet {
            adjustTopTextInset()
        }
    }
    
    @IBInspectable var titleYPadding:CGFloat = 0.0 {
        didSet {
            var r = titleLabel.frame
            r.origin.y = titleYPadding
            titleLabel.frame = r
        }
    }
    
    @IBInspectable var titleTextColour:UIColor = UIColor.gray {
        didSet {
            if !isFirstResponder {
                titleLabel.textColor = titleTextColour
                bottomLineView.backgroundColor = titleLabel.textColor
            }
        }
    }
    
    @IBInspectable var titleActiveTextColour:UIColor = UIColor.cyan {
        didSet {
            if isFirstResponder {
                titleLabel.textColor = titleActiveTextColour
                bottomLineView.backgroundColor = titleLabel.textColor
            }
        }
    }
    
    // MARK:- Init
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect, textContainer:NSTextContainer?) {
        super.init(frame:frame, textContainer:textContainer)
        setup()
    }
    
    deinit {
        if !isIB {
            let nc = NotificationCenter.default
            nc.removeObserver(self, name:NSNotification.Name.UITextViewTextDidChange, object:self)
            nc.removeObserver(self, name:NSNotification.Name.UITextViewTextDidBeginEditing, object:self)
            nc.removeObserver(self, name:NSNotification.Name.UITextViewTextDidEndEditing, object:self)
        }
    }
    
    // MARK:- Overrides
    override func prepareForInterfaceBuilder() {
        isIB = true
        setup()
    }
    fileprivate func setYPositionOfBottomLineView() {
        let r = textRect()
        let fixedWidth = self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        if newFrame.size.height > self.frame.height {
            bottomLineView.frame = CGRect(x: r.origin.x, y:newFrame.size.height - 1 , width:r.size.width, height:1)
        } else {
            bottomLineView.frame = CGRect(x: r.origin.x, y:self.frame.height - 1 , width:r.size.width, height:1)
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustTopTextInset()
        hintLabel.alpha = text.isEmpty ? 1.0 : 0.0
        let r = textRect()
        hintLabel.frame = CGRect(x:r.origin.x, y:r.origin.y, width:hintLabel.frame.size.width, height:hintLabel.frame.size.height)
        setTitlePositionForTextAlignment()
        setYPositionOfBottomLineView()
        let isResp = isFirstResponder
        if isResp  {
            titleLabel.textColor = titleActiveTextColour
            bottomLineView.backgroundColor = titleLabel.textColor
        } else {
            titleLabel.textColor = titleTextColour
            bottomLineView.backgroundColor = titleLabel.textColor
        }
        // Should we show or hide the title label?
        if text.isEmpty {
            if isResp {
                showTitle(isResp)
            } else {
                // Hide
                hideTitle(isResp)
            }
        } else {
            // Show
            showTitle(isResp)
        }
    }
    
    // MARK:- Private Methods
    
    fileprivate func setup() {
        initialTopInset = textContainerInset.top
        textContainer.lineFragmentPadding = 0.0
        titleActiveTextColour = tintColor
        // Placeholder label
        hintLabel.font = font
        hintLabel.text = hint
        hintLabel.numberOfLines = 0
        hintLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        hintLabel.textColor = placeholderTextColor
        insertSubview(hintLabel, at:0)
        insertSubview(bottomLineView, at:1)
        // Set up title label
        titleLabel.alpha = 0.0
        titleLabel.font = titleFont
        titleLabel.textColor = titleTextColour
        bottomLineView.backgroundColor = titleLabel.textColor
        if !hint.isEmpty {
            titleLabel.text = hint
            titleLabel.sizeToFit()
        }
        self.addSubview(titleLabel)
        
        // Observers
        if !isIB {
            let nc = NotificationCenter.default
            nc.addObserver(self, selector:#selector(UIView.layoutSubviews), name:NSNotification.Name.UITextViewTextDidChange, object:self)
            nc.addObserver(self, selector:#selector(UIView.layoutSubviews), name:NSNotification.Name.UITextViewTextDidBeginEditing, object:self)
            nc.addObserver(self, selector:#selector(UIView.layoutSubviews), name:NSNotification.Name.UITextViewTextDidEndEditing, object:self)
        }
    }
    
    fileprivate func adjustTopTextInset() {
        var inset = textContainerInset
        inset.top = initialTopInset + titleLabel.font.lineHeight + hintYPadding
        textContainerInset = inset
    }
    
    fileprivate func textRect()->CGRect {
        var r = UIEdgeInsetsInsetRect(bounds, contentInset)
        r.origin.x += textContainer.lineFragmentPadding
        r.origin.y += textContainerInset.top
        return r.integral
    }
    
    fileprivate func setTitlePositionForTextAlignment() {
        var titleLabelX = textRect().origin.x
        var placeholderX = titleLabelX
        if textAlignment == NSTextAlignment.center {
            titleLabelX = (frame.size.width - titleLabel.frame.size.width) * 0.5
            placeholderX = (frame.size.width - hintLabel.frame.size.width) * 0.5
        } else if textAlignment == NSTextAlignment.right {
            titleLabelX = frame.size.width - titleLabel.frame.size.width
            placeholderX = frame.size.width - hintLabel.frame.size.width
        }
        var r = titleLabel.frame
        r.origin.x = titleLabelX
        titleLabel.frame = r
        r = hintLabel.frame
        r.origin.x = placeholderX
        hintLabel.frame = r
    }
    fileprivate func showTitle(_ animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut], animations:{
            // Animation
            self.titleLabel.alpha = 1.0
            
            // set your superview's background color
            self.titleLabel.backgroundColor = self.superview?.backgroundColor
            var r = self.titleLabel.frame
            r.origin.y = self.titleYPadding + self.contentOffset.y
            self.titleLabel.frame = r
            
        }, completion:nil)
    }
    
    fileprivate func hideTitle(_ animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn], animations:{
            // Animation
            self.titleLabel.alpha = 0.0
            self.titleLabel.backgroundColor = self.backgroundColor
            var r = self.titleLabel.frame
            r.origin.y = self.titleLabel.font.lineHeight + self.hintYPadding
            self.titleLabel.frame = r
            
        }, completion:nil)
    }
}
