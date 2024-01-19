//
//  CardButton.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/19/21.
//

import UIKit

@IBDesignable open class CardButton: Card {
    /**
     Text of the title label.
     */
    @IBInspectable public var title: String = "The Art of the Impossible" {
        didSet{
            titleLbl.text = title
        }
    }
    /**
     Max font size the title label.
     */
    @IBInspectable public var titleSize: CGFloat = 26
    /**
     Text of the subtitle label.
     */
    @IBInspectable public var subtitle: String = "Inside the extraordinary world of Monument Valley 2" {
        didSet{
            subtitleLbl.text = subtitle
        }
    }
    /**
     Max font size the subtitle label.
     */
    @IBInspectable public var subtitleSize: CGFloat = 17

    /**
     Image displayed in the icon ImageView.
     */
    @IBInspectable public var icon: UIImage? {
        didSet{
            iconIV.image = icon
        }
    }

    //Priv Vars
    var titleLbl = UILabel ()
    var subtitleLbl = UILabel()
    private var iconIV = UIImageView()

    // View Life Cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override open func initialize() {
        super.initialize()

        backgroundIV.addSubview(iconIV)
        backgroundIV.addSubview(titleLbl)
        backgroundIV.addSubview(subtitleLbl)
    }
    
    override open func draw(_ rect: CGRect) {
        
        //Draw
        super.draw(rect)

        iconIV.image = icon
        iconIV.clipsToBounds = true

        titleLbl.textColor = textColor
        titleLbl.text = title
        titleLbl.font = UIFont.systemFont(ofSize: titleSize, weight: .bold)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.minimumScaleFactor = 0.1
        titleLbl.lineBreakMode = .byClipping
        titleLbl.numberOfLines = 2
        titleLbl.baselineAdjustment = .none
        
        subtitleLbl.text = subtitle
        subtitleLbl.textColor = textColor
        subtitleLbl.font = UIFont.systemFont(ofSize: subtitleSize, weight: .medium)
        subtitleLbl.shadowColor = UIColor.black
        subtitleLbl.shadowOffset = CGSize.zero
        subtitleLbl.adjustsFontSizeToFitWidth = true
        subtitleLbl.minimumScaleFactor = 0.1
        subtitleLbl.lineBreakMode = .byTruncatingTail
        subtitleLbl.numberOfLines = 0
        subtitleLbl.textAlignment = .left
     
        self.layout()
        
    }
    
    override open func layout(animating: Bool = true) {
        super.layout(animating: animating)
        
        let gimme  = LayoutHelper(rect: backgroundIV.bounds)

        iconIV.frame = CGRect(x: insets,
                              y: (insets / 2) + (gimme.Y(50, from: iconIV) / 2),
                              width: gimme.Y(25),
                              height: gimme.Y(25))

        titleLbl.frame = CGRect(x: insets + iconIV.frame.width + (insets/2),
                                y: insets,
                                width: gimme.X(80),
                                height: gimme.Y(7))
        
        subtitleLbl.frame = CGRect(x: insets + iconIV.frame.width + (insets/2),
                                   y: gimme.RevY(0, height: gimme.Y(14)) - insets,
                                   width: gimme.X(80),
                                   height: gimme.Y(14))
        titleLbl.sizeToFit()
    }
    
}



