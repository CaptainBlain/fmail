//
//  Extension.swift
//  caliesta-business
//
//  Created by Blain Ellis on 16/08/2019.
//  Copyright © 2019 caliesta. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Contacts



extension UIImage {
    
    func checkImageSize() -> Double {
        var imageSize:Double = 0.0
        if let data = self.jpegData(compressionQuality: 1.0) {
            let imgData: NSData = NSData(data: data)
            let imageSizeInt: Int = imgData.count
            print("size of image in KB: %.2f ", Double(imageSizeInt) / 1000.0)
            imageSize = Double(imageSizeInt) / 1000.0
        }
        return imageSize
    }
    
}

extension Data {
    
    func checkImageSize() {
        var imageSize:Double = 0.0
        let imgData: NSData = NSData(data: self)
        let imageSizeInt: Int = imgData.count
        print("size of Data in KB: %.2f ", Double(imageSizeInt) / 1000.0)
    }
    
}

extension DateFormatter {
    
    static func getAPIDateFormatter() -> DateFormatter {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
        
    }
    
    
}

extension Date {
    
    func getDateStringForCreatedTime() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        let nowComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())

        let seconds = calendar.dateComponents([.second], from: timeComponents, to: nowComponents).second!
        let minutes = calendar.dateComponents([.minute], from: timeComponents, to: nowComponents).minute!
        let hour = calendar.dateComponents([.hour], from: timeComponents, to: nowComponents).hour!
        let day = calendar.dateComponents([.day], from: timeComponents, to: nowComponents).day!
        let month = calendar.dateComponents([.month], from: timeComponents, to: nowComponents).month!
        let year = calendar.dateComponents([.year], from: timeComponents, to: nowComponents).year!
       
        if year > 0 {
            return year > 1 ? "\(year) years ago" : "\(year) year ago"
        }
        
        if month > 0 {
            return month > 1 ? "\(month) months ago" : "\(month) month ago"
        }
        
        if day > 0 {
            return day > 1 ? "\(day) days ago" : "\(day) day ago"
        }
        
        if hour > 0 {
            return hour > 1 ? "\(hour) hours ago" : "\(hour) hour ago"
        }
        
        if minutes > 0 {
            return minutes > 1 ? "\(minutes) minutes ago" : "\(minutes) minutes ago"
        }

        if seconds > 0 {
            return seconds > 1 ? "\(seconds) seconds ago" : "\(seconds) seconds ago"
        }
        
        print("seconds: \(seconds) minutes: \(minutes)  hour: \(hour)  day: \(day)  month: \(month)  year: \(year)" )
        
        return ""
        
    }
    
    func getDateString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getAge() -> Int {
        
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: now)
        let age = ageComponents.year!
        return age
        
    }
    
    func getAgeString() -> String {
        
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: now)
        let age = ageComponents.year!
        return String.init(format: "%ld", age)
        
    }
    
    func isProfileImageExpired() -> Bool {
        print(self)
        print(self < Date())
        if self < Date() {
            return true
        }
        return false
    }
    
}

extension NSDate {
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

extension NSAttributedString {
    
    static func getFontWithColour(font: UIFont, color: UIColor) -> Dictionary<NSAttributedString.Key, Any> {
        
        return [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        
    }
    
    static func getFont(font: UIFont) -> Dictionary<NSAttributedString.Key, Any> {
        
        return [NSAttributedString.Key.font: font]
    }
    
    static func getColour(color: UIColor) -> Dictionary<NSAttributedString.Key, Any> {
        
         return [NSAttributedString.Key.foregroundColor: color]
    }
    
    
}

extension String {
    
    func getStringSize(for font: UIFont, andWidth width: CGFloat) -> CGSize {
        
        // calculate text height
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [
                                                NSAttributedString.Key.font: font],
                                            context: nil)
        let width = ceil(boundingBox.width)
        let height = ceil(boundingBox.height)
        
        return CGSize(width: width, height: height)
    }
    
    
    
}


extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0
        
        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            textWidth -= insetsWidth
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth
        
        return contentSize
    }
}

extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            
            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)
            
            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                
                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            
            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }
            
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}

extension UIFont {
    
    static func roboto(size: CGFloat) -> UIFont {
        
        return UIFont(name: "Roboto", size: size)!
    }
    
    static func robotoBold(size: CGFloat) -> UIFont {
        
        return UIFont(name: "Roboto-Bold", size: size)!
    }
    
    static func robotoLight(size: CGFloat) -> UIFont {
        
        return UIFont(name: "Roboto-Light", size: size)!
    }
    
    static func robotoMedium(size: CGFloat) -> UIFont {
        
        return UIFont(name: "Roboto-Medium", size: size)!
    }
    
    class func helveticaNeueRegular(_ size: CGFloat) -> UIFont? {
        
        return UIFont(name: "HelveticaNeue", size: size)
    }
    
    class func helveticaNeueBold(_ size: CGFloat) -> UIFont? {
        
        return UIFont(name: "HelveticaNeue-Bold", size: size)
    }
    
    //[UIFont fontWithName:@"SleightOfFont" size:40]
    class func poladroidSwishyFont(_ size: CGFloat) -> UIFont? {
        
        return UIFont(name: "SleightOfFont", size: size)
    }
    
    
    class func SHRfontRegular(_ size:CGFloat) -> UIFont
    {
        let font: UIFont = UIFont(name: "HelveticaNeue-Thin", size: size)!
        return font
    }
}

extension UIImageView {
    
    func blurImage() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    func screenShot() -> UIImage {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot!
    }
}


extension UIViewController {
    func showError(_ message: String, okButtonPressed: (() -> Void)?) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { (_) in
            if (okButtonPressed != nil) {
                okButtonPressed!()
            }
        }
        alertVC.addAction(okButton)
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
}

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        //if let slide = viewController as? SlideMenuController {
        //return topViewController(slide.mainViewController)
        //}
        return viewController
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(red:   .random(), green: .random(), blue:  .random(), alpha: 1.0)
    }
    
    //F6F6F6
    class func getLightGreyColor(_ alpha:CGFloat = 1.0) -> UIColor {
        return #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    }
    
    //B4DDF0
    class func getActionBlueColor(_ alpha:CGFloat = 1.0) -> UIColor {
        return getAquaColor(alpha)
    }
    
    class func getPowderBlueColor(_ alpha:CGFloat = 1.0) -> UIColor {
        return #colorLiteral(red: 0.8078431373, green: 1, blue: 0.9450980392, alpha: 1)
    }
    
    class func getAquaColor(_ alpha:CGFloat = 1.0) -> UIColor {
        return #colorLiteral(red: 0.6745098039, green: 0.9058823529, blue: 0.937254902, alpha: 1)
    }
    
    class func getLightPurpleColor(_ alpha:CGFloat = 1.0) -> UIColor {
        return #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.9254901961, alpha: 1)
    }
    
    class func getOrchidColor(_ alpha:CGFloat = 1.0) -> UIColor {
        return #colorLiteral(red: 0.6470588235, green: 0.4235294118, blue: 0.7568627451, alpha: 1)
    }
    
    class func getAppBlueColor(_ alpha:CGFloat = 1.0) -> UIColor {
        return #colorLiteral(red: 0.06274509804, green: 0.5960784314, blue: 0.968627451, alpha: 1)
    }
    
    static func lightTextColor() -> UIColor {
        return #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    
    static func darkTextColor() -> UIColor {
        return #colorLiteral(red: 0.02022366143, green: 0.03400618655, blue: 0.02071806246, alpha: 1)
    }
    
    static func lightGreyColor() -> UIColor {
        return #colorLiteral(red: 0.4549019608, green: 0.4588235294, blue: 0.4745098039, alpha: 1)
    }
    static func darkGreyColor() -> UIColor {
        return #colorLiteral(red: 0.2431372549, green: 0.2470588235, blue: 0.2588235294, alpha: 1)
    }
    
    static func redBarColor() -> UIColor {
        return #colorLiteral(red: 0.937254902, green: 0.3254901961, blue: 0.3098039216, alpha: 1)
    }
    static func yellowBarColor() -> UIColor {
        return #colorLiteral(red: 1, green: 0.8745098039, blue: 0.5725490196, alpha: 1)
    }
    static func greenBarColor() -> UIColor {
        return #colorLiteral(red: 0.6117647059, green: 0.8, blue: 0.3960784314, alpha: 1)
    }
    
    static func vpmColor() -> UIColor {
        return #colorLiteral(red: 0.4980392157, green: 0.1764705882, blue: 0.2862745098, alpha: 1)
    }
    static func whiteColor() -> UIColor {
        return #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.968627451, alpha: 1)
    }
    
    class func OneKnightPrimary(_ alpha:CGFloat = 1.0) -> UIColor {
        return UIColor(hex: 0x000000, alpha: alpha)
        //return UIColor(hex: 0x231F20, alpha: alpha)
    }
    
    class func OneKnightAccent(_ alpha:CGFloat = 1.0) -> UIColor {
        return UIColor(hex: 0xFFFFFF, alpha: alpha)
    }
    
    convenience init(hex: Int, alpha:CGFloat) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
}


extension UIImagePickerController {
    
    //  Converted to Swift 4 by Swiftify v4.2.28451 - https://objectivec2swift.com/
    class func initCameraPicker() -> UIImagePickerController {
        
        let imagePickerController = UIImagePickerController.initImagePicker()
        imagePickerController.sourceType = .camera
        return imagePickerController
        
    }
    
    class func initPhotoLibraryPicker() -> UIImagePickerController {
        
        let imagePickerController = UIImagePickerController.initImagePicker()
        imagePickerController.sourceType = .photoLibrary
        return imagePickerController
    }
    
    
    class func initImagePicker() -> UIImagePickerController {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.navigationBar.isTranslucent = false
        imagePickerController.navigationBar.barTintColor = UIColor.OneKnightAccent()
        imagePickerController.navigationBar.tintColor = UIColor.OneKnightPrimary()
        let placeholderAttributesDict = [
            NSAttributedString.Key.foregroundColor: UIColor.OneKnightAccent(),
            NSAttributedString.Key.font: UIFont.helveticaNeueBold(20)
        ]
        imagePickerController.navigationBar.titleTextAttributes = placeholderAttributesDict as [NSAttributedString.Key : Any]
        
        return imagePickerController
    }
    
    
}

public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

extension UIButton {
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
}

extension UITextView {
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
}

extension UIToolbar {
    
    func Toolbar(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.backgroundColor = UIColor.OneKnightPrimary()
        toolBar.barTintColor = UIColor.OneKnightPrimary()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}

public enum RoundButtonType: String {
    case normal = "";
    case pencil = "pencil-edit-button-white"
    case close = "delete"
    case heart = "heart"
    case fullheart = "favorite-heart-button";
}

extension UIButton {
    
    public func makeRound(type:RoundButtonType, selectedType:RoundButtonType? = nil) {
        
        let borderWidth:CGFloat = 2.0
        let backColor = UIColor.OneKnightPrimary(1.0)
        let borderColor = UIColor.OneKnightAccent(1.0)
        
        self.setTitle("", for: UIControl.State.normal)
        self.tintColor = UIColor.white
        self.layer.cornerRadius = self.frame.size.width / 2.0
        self.backgroundColor = backColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.setImage(UIImage(named: type.rawValue), for: UIControl.State.normal)
        if let selectedType = selectedType {
            //self.setImage(UIImage(named: selectedType.rawValue), for: UIControl.State.highlighted)
            self.setImage(UIImage(named: selectedType.rawValue), for: UIControl.State.selected)
            
        }
        
    }
    
}

extension CLLocation {
    
    func getGeocodeData(completion: @escaping (_ placemarkInfo: String) -> Void) {
        
        self.geocode { placemark, error in
            if let error = error as? CLError {
                print("CLError:", error)
                completion("")
                return
            } else if let placemark = placemark?.first {
                
                var placemarkInfo = ""
                
                if let name = placemark.name {
                    //print(name)
                    //placemarkInfo.append(name)
                    // placemarkInfo.append(", ")
                }
                
                if let subLocality = placemark.subLocality {
                    //print(subLocality)
                    placemarkInfo.append(subLocality)
                    placemarkInfo.append(", ")
                }
                
                if let subAdministrativeArea = placemark.subAdministrativeArea {
                    //print(subAdministrativeArea)
                    placemarkInfo.append(subAdministrativeArea)
                }
                
                // you should always update your UI in the main thread
                /*DispatchQueue.main.async {
                 //  update UI here
                 print("name:", placemark.name ?? "unknown")
                 
                 print("address1:", placemark.thoroughfare ?? "unknown")
                 print("address2:", placemark.subThoroughfare ?? "unknown")
                 print("neighborhood:", placemark.subLocality ?? "unknown")
                 print("city:", placemark.locality ?? "unknown")
                 
                 print("state:", placemark.administrativeArea ?? "unknown")
                 print("subAdministrativeArea:", placemark.subAdministrativeArea ?? "unknown")
                 print("zip code:", placemark.postalCode ?? "unknown")
                 print("country:", placemark.country ?? "unknown", terminator: "\n\n")
                 
                 print("isoCountryCode:", placemark.isoCountryCode ?? "unknown")
                 print("region identifier:", placemark.region?.identifier ?? "unknown")
                 
                 print("timezone:", placemark.timeZone ?? "unknown", terminator:"\n\n")
                 
                 // Mailind Address
                 //print(placemark.mailingAddress ?? "unknown")
                 }*/
                
                completion(placemarkInfo)
            }
        }
    }
    
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}

extension Formatter {
    static let mailingAddress: CNPostalAddressFormatter = {
        let formatter = CNPostalAddressFormatter()
        formatter.style = .mailingAddress
        return formatter
    }()
}

/*extension CLPlacemark {
 var mailingAddress: String? {
 return postalAddress?.mailingAddress
 }
 }*/

extension CNPostalAddress {
    var mailingAddress: String {
        return Formatter.mailingAddress.string(from: self)
    }
}

extension UIViewController {
    open override func awakeFromNib() {
        
    }
    
    public func showError(_ message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("error", comment: ""), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
