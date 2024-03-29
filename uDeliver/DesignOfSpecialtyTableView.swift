import Foundation
import UIKit

@IBDesignable class DesignOfSpecialtyTableView : UIView {
    @IBInspectable var cornerRadius : CGFloat = 0
    
    
    @IBInspectable var shadowOffsetWidth : Int = 0
    @IBInspectable var shadowOffsetHeight : Int = 1

    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = 0.2
        layer.animation(forKey: "Rabiya")
    }
    
}
