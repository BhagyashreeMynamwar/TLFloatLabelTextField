import UIKit

@IBDesignable class TLFloatLabelTextField: UITextField {
    var _titleLabel = UILabel()
    let bottomLineView = UIView()
    
    // MARK:- Properties
    override var accessibilityLabel:String? {
        get {
            if let txt = text , txt.isEmpty {
                return _titleLabel.text
            } else {
                return text
            }
        }
        set {
            self.accessibilityLabel = newValue
        }
    }
    
    override var placeholder:String? {
        didSet {
            _titleLabel.text = placeholder
            _titleLabel.sizeToFit()
        }
    }
    @IBInspectable var placeHolderColor: UIColor = .white {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: placeHolderColor])
        }
    }
    override var attributedPlaceholder:NSAttributedString? {
        didSet {
            _titleLabel.text = attributedPlaceholder?.string
            _titleLabel.sizeToFit()
        }
    }
    
    var titleFont:UIFont = UIFont.boldSystemFont(ofSize: 17.0) {
        didSet {
            _titleLabel.font = titleFont
            _titleLabel.sizeToFit()
        }
    }
    
    @IBInspectable var hintLabelYPadding:CGFloat = 0.0
    
    @IBInspectable var titleLabelYPadding:CGFloat = 0.0 {
        didSet {
            var r = _titleLabel.frame
            r.origin.y = titleLabelYPadding
            _titleLabel.frame = r
        }
    }
    
    @IBInspectable var titleTextColour:UIColor = UIColor.gray {
        didSet {
            if !isFirstResponder {
                _titleLabel.textColor = titleTextColour
                bottomLineView.backgroundColor = _titleLabel.textColor
            }
        }
    }
    @IBInspectable var titleActiveTextColour:UIColor = .white {
        didSet {
            if isFirstResponder {
                _titleLabel.textColor = titleActiveTextColour
                bottomLineView.backgroundColor = _titleLabel.textColor

            }
        }
    }
    
    // MARK:- Init
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    // MARK:- Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        setTitlePositionForTextAlignment()
        setViewPosition()
        let isResp = isFirstResponder
        if let _ = text ,  isResp {
            _titleLabel.textColor = titleActiveTextColour
        } else {
            _titleLabel.textColor = titleTextColour
        }
        bottomLineView.backgroundColor = _titleLabel.textColor
        // Should we show or hide the title label?
        if let txt = text , txt.isEmpty {
            // Hide
            if isResp {
                showTitleLabel(isResp)
            } else {
                hideTitleLabel(isResp)
            }
        } else {
            // Show
            showTitleLabel(isResp)
        }
    }
    
    override func textRect(forBounds bounds:CGRect) -> CGRect {
        var r = super.textRect(forBounds: bounds)
            var top = ceil(_titleLabel.font.lineHeight + hintLabelYPadding)
            top = min(top, maxTopInset())
            r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
        return r.integral
    }
    
    override func editingRect(forBounds bounds:CGRect) -> CGRect {
        var r = super.editingRect(forBounds: bounds)
            var top = ceil(_titleLabel.font.lineHeight + hintLabelYPadding)
            top = min(top, maxTopInset())
            r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
        return r.integral
    }
    
    override func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
        var r = super.clearButtonRect(forBounds: bounds)
            var top = ceil(_titleLabel.font.lineHeight + hintLabelYPadding)
            top = min(top, maxTopInset())
            r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
        return r.integral
    }
    
    // MARK:- Public Methods
    
    // MARK:- Private Methods
    fileprivate func setup() {
        
        borderStyle = UITextBorderStyle.none
        titleActiveTextColour = tintColor
        // Set up title label
        _titleLabel.alpha = 0.0
        _titleLabel.font = titleFont
        _titleLabel.textColor = titleTextColour
        bottomLineView.backgroundColor = _titleLabel.textColor
        if let str = placeholder , !str.isEmpty {
            _titleLabel.text = str
            _titleLabel.sizeToFit()
        }
        self.addSubview(_titleLabel)
        self.addSubview(bottomLineView)
        self.layer.masksToBounds = true

    }
    fileprivate func maxTopInset()->CGFloat {
        if let fnt = font {
            return max(0, floor(bounds.size.height - fnt.lineHeight - 4.0))
        }
        return 0
    }
    
    fileprivate func setTitlePositionForTextAlignment() {
        let r = textRect(forBounds: bounds)
        var x = r.origin.x
        if textAlignment == NSTextAlignment.center {
            x = r.origin.x + (r.size.width * 0.5) - _titleLabel.frame.size.width
        } else if textAlignment == NSTextAlignment.right {
            x = r.origin.x + r.size.width - _titleLabel.frame.size.width
        }
        _titleLabel.frame = CGRect(x:x, y:_titleLabel.frame.origin.y, width:_titleLabel.frame.size.width, height:_titleLabel.frame.size.height)
    }
    fileprivate func setViewPosition() {
        let width = CGFloat(2.0)
        bottomLineView.frame = CGRect(x: 0, y: self.frame.size.height - width - 5, width:  self.frame.size.width, height: 1)
    }
    fileprivate func showTitleLabel(_ animated:Bool) {
        
        let dur = animated ? 0.3 : 0
        UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut], animations:{
            // Animation
            self._titleLabel.alpha = 1.0
            var r = self._titleLabel.frame
            r.origin.y = self.titleLabelYPadding
            self._titleLabel.frame = r
        }, completion:nil)
    }
    
    fileprivate func hideTitleLabel(_ animated:Bool) {
        let dur = animated ? 0.3 : 0
        UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn], animations:{
            // Animation
            self._titleLabel.alpha = 0.0
            var r = self._titleLabel.frame
            r.origin.y = self._titleLabel.font.lineHeight + self.hintLabelYPadding
            self._titleLabel.frame = r
        }, completion:nil)
    }
}
