
import UIKit
import Charts

class AppChartMarker: MarkerView, ViewLoadable {
    
    //MARK:- Outlet
    @IBOutlet weak var vwParent             : UIView!
    @IBOutlet weak var vwBg                 : UIView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblValue             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    @objc open var arrowSize        = CGSize(width: 15, height: 11)
    @objc open var insets           = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    var strTitle                    = ""
    var color1                      = UIColor()
    var color2                      = UIColor()
    var textColor                   = UIColor()
    var dataSetIndex                = 0
    var readingType: ReadingType?   = nil
    var selectedFibroScanType: FibroScanType = .LSM
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    fileprivate func setUpView() {
        self.applyStyle()
        self.configureUI()
        
        self.lblTitle.text = self.strTitle
    }
    
    fileprivate func configureUI(){
        
        self.vwBg.layoutIfNeeded()
        var color = self.color1
        if self.dataSetIndex == 1 {
            color = self.color2
        }
        
        let colorBg = GFunction.shared.applyGradientColor(startColor: color.withAlphaComponent(0.4),
                                                          endColor: color.withAlphaComponent(0.1),
                                                          locations: [0, 1],
                                                          startPoint: CGPoint(x: 0, y: self.vwBg.frame.maxY),
                                                          endPoint: CGPoint(x: self.vwBg.frame.maxX, y: self.vwBg.frame.maxY),
                                                          gradiantWidth: self.vwBg.frame.width,
                                                          gradiantHeight: self.vwBg.frame.height)
        
        self.vwBg.backGroundColor(color: colorBg)
        self.vwBg.cornerRadius(cornerRadius: 10)
            .themeShadow()
        self.vwParent.layoutIfNeeded()
        self.vwParent.backGroundColor(color: .white)
            .cornerRadius(cornerRadius: 10)
            .themeShadow()
        self.layoutSubviews()
    }
    
    fileprivate func applyStyle(){
        self.lblTitle.font(name: .semibold, size: 11).textColor(color: .themeBlack)
        self.lblValue.font(name: .bold, size: 9).textColor(color: .themeBlack)
        self.lblDesc.font(name: .semibold, size: 11).textColor(color: .themeBlack)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
        self.offset.x = -self.frame.size.width / 2.0
        self.offset.y = -self.frame.size.height - 7.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
//    init(color: UIColor, font: UIFont, textColor: UIColor)
//    {
//        self.color = color
//        self.font = font
//        self.textColor = textColor
////        super.init()
//    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)
        //laValue.text = String(entry.y)
//        self.frame.origin.y     = -50
        
        if let entryVal = entry as? CandleChartDataEntry {
            self.lblValue.text      = "\(entryVal.low)-\(entryVal.high)"
        }
        else {
            self.lblValue.text = String(format: "%0.0f", highlight.y)
            if self.readingType != nil {
                switch self.readingType! {
                    
                case .SPO2:
                    break
                case .PEF:
                    break
                case .BloodPressure:
                    break
                case .HeartRate:
                    break
                case .BodyWeight:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .BMI:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .BloodGlucose:
                    break
                case .HbA1c:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
//                    self.lblValue.text = "\(highlight.y.floorToPlaces(places: 1))"
                    break
                case .ACR:
                    break
                case .eGFR:
                    break
                case .FEV1Lung:
                    self.lblValue.text = String(format: "%0.2f", highlight.y)
                    break
                case .cat:
                    break
                case .six_min_walk:
                    break
                case .fibro_scan:
                    if self.selectedFibroScanType == .LSM {
                        self.lblValue.text = String(format: "%0.1f", highlight.y)
                    }
                    break
                case .fib4:
                    self.lblValue.text = String(format: "%0.2f", highlight.y)
                    break
                case .sgot:
                    break
                case .sgpt:
                    break
                case .triglycerides:
                    break
                case .total_cholesterol:
                    break
                case .ldl_cholesterol:
                    break
                case .hdl_cholesterol:
                    break
                case .waist_circumference:
                    break
                case .platelet:
                    break
                case .serum_creatinine:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .fatty_liver_ugs_grade:
                    let val = GFunction.shared.getFattyLiver(value: JSON(highlight.y).intValue,
                                                             arrFattyLiverGrade: GFunction.shared.setArrFattyLiver())
                    let strValue1       = val["name"].stringValue
                    self.lblValue.text  = strValue1
                    break
                case .random_blood_glucose:
                    break
                case .BodyFat:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .Hydration:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .MuscleMass:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .Protein:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .BoneMass:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .VisceralFat:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .BaselMetabolicRate:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .MetabolicAge:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .SubcutaneousFat:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .SkeletalMuscle:
                    self.lblValue.text = String(format: "%0.1f", highlight.y)
                    break
                case .fev1_fvc_ratio,.fvc,.aqi,.humidity,.temperature,.calories_burned,.sedentary_time:
                    break
                }
            }
        }
        self.dataSetIndex = highlight.dataSetIndex
        
        //UI Width update based on marker value
        let width = self.lblValue.text!.width(withConstraintedHeight: 25, font: UIFont.customFont(ofType: .semibold, withSize: 9.0)) + 20
        self.frame.size.width = width
        //self.lblDesc.text   = String(entry.x)
        self.layoutIfNeeded()
        self.setNeedsLayout()
        self.setUpView()
    }
    //------------------------------------------------------
    
//    override func draw(context: CGContext, point: CGPoint) {
//        guard let vw = self.vwBg else { return }
//
//        let offset = self.offsetForDrawing(atPoint: point)
//        let size = self.frame.size
//
//        var rect = CGRect(
//            origin: CGPoint(
//                x: point.x + offset.x,
//                y: point.y + offset.y),
//            size: size)
//        rect.origin.x -= size.width / 2.0
//        rect.origin.y -= size.height
//
//        context.saveGState()
//
//        context.setFillColor(color.cgColor)
//
//        if offset.y > 0
//        {
//            context.beginPath()
//            context.move(to: CGPoint(
//                x: rect.origin.x,
//                y: rect.origin.y + arrowSize.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
//                y: rect.origin.y + arrowSize.height))
//            //arrow vertex
//            context.addLine(to: CGPoint(
//                x: point.x,
//                y: point.y))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
//                y: rect.origin.y + arrowSize.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + rect.size.width,
//                y: rect.origin.y + arrowSize.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + rect.size.width,
//                y: rect.origin.y + rect.size.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x,
//                y: rect.origin.y + rect.size.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x,
//                y: rect.origin.y + arrowSize.height))
//            context.fillPath()
//        }
//        else
//        {
//            context.beginPath()
//            context.move(to: CGPoint(
//                x: rect.origin.x,
//                y: rect.origin.y))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + rect.size.width,
//                y: rect.origin.y))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + rect.size.width,
//                y: rect.origin.y + rect.size.height - arrowSize.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
//                y: rect.origin.y + rect.size.height - arrowSize.height))
//            //arrow vertex
//            context.addLine(to: CGPoint(
//                x: point.x,
//                y: point.y))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
//                y: rect.origin.y + rect.size.height - arrowSize.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x,
//                y: rect.origin.y + rect.size.height - arrowSize.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x,
//                y: rect.origin.y))
//            context.fillPath()
//        }
//
//        if offset.y > 0 {
//            rect.origin.y += self.insets.top + arrowSize.height
//        } else {
//            rect.origin.y += self.insets.top
//        }
//
//        rect.size.height -= self.insets.top + self.insets.bottom
//
//        UIGraphicsPushContext(context)
//
//        vw.draw(rect)
//
//        UIGraphicsPopContext()
//
//        context.restoreGState()
//    }
    
    //MARK:- Override Method
}
extension AppChartMarker {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ReadingChartMarker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}

protocol ViewLoadable {
    var nibName: String { get }
}

extension ViewLoadable where Self: UIView {
    fileprivate var containerView: UIView? { return subviews.first }

    var nibName: String { return String(describing: type(of: self)) }

    fileprivate func loadViewFromXib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        return view
    }

    fileprivate func xibSetup() {
        DispatchQueue.main.async {
            if let view = self.loadViewFromXib() {
                view.frame = self.bounds
                view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin]
                view.autoresizesSubviews = true
                self.backgroundColor = .clear
                self.addSubview(view)
                view.awakeFromNib()
            }
        }
    }
}
