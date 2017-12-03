//
//  ViewController.swift
//  Energy
//
//  Created by Taivon Thompson on 12/2/17.
//  Copyright © 2017 Taivon Thompson. All rights reserved.
//

import UIKit
import Charts
import WebKit
var appTimer: Timer!
class ViewController: UIViewController {
    var arduinoServer = ""
    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var currentLoad: UILabel!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var computer: UILabel!
    @IBOutlet weak var lights: UILabel!
    @IBOutlet weak var hvac: UILabel!
    @IBOutlet weak var washingMachine: UILabel!
    @IBOutlet weak var dishwasher: UILabel!
    @IBOutlet weak var dryer: UILabel!
    @IBOutlet weak var tv: UILabel!
    @IBOutlet weak var waterheater: UILabel!
    
    @IBOutlet weak var chart: LineChartView!
    
    var ip = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //var arduino = arduinoIP()
        //print(arduinoIP())
       //ip = arduinoIP()
        constructIP()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        
        return address
        
    }
    func arduinoIP() -> String {
        var p=0
        var out = ""
        if let addr = getWiFiAddress() {
            for l in addr{
                if l == "."{
                    p = p+1
                }
                if p != 3{
                    out.append(l)
                    
                }
            }
            out.append(".25")
            //print(out)
        } else {
            print("No WiFi address")
        }
        return out
    }
    //var arduinoServer = "http://192.168.1.25/$"
    //var arduinoServer = "http://10.10.10.25/$"
    func constructIP(){
        arduinoServer = "http://" + arduinoIP() + "/$"
        print(arduinoServer)
    }
    
    @IBAction func switch1(_ sender: UISwitch) {
        if sender.isOn == true {
            device1on()
        }
        else{
            device1off()
        }
        group.text = ""
    }
    
    @IBAction func switch2(_ sender: UISwitch) {
        if sender.isOn == true {
            device2on()
        }
        else{
            device2off()
        }
        group.text = ""
    }
    @IBAction func switch3(_ sender: UISwitch) {
        if sender.isOn == true {
            device3on()
        }
        else{
            device3off()
        }
        group.text = ""
    }
    
    @IBAction func switch4(_ sender: UISwitch) {
        if sender.isOn == true {
            device4on()
        }
        else{
            device4off()
        }
        group.text = ""
    }
    @IBAction func switch5(_ sender: UISwitch) {
        if sender.isOn == true {
            device5on()
        }
        else{
            device5off()
        }
        group.text = ""
    }
    
    @IBAction func switch6(_ sender: UISwitch) {
        if sender.isOn == true {
            device6on()
        }
        else{
            device6off()
        }
        group.text = ""
    }
    @IBAction func switch7(_ sender: UISwitch) {
        if sender.isOn == true {
            device7on()
        }
        else{
            device7off()
        }
        group.text = ""
    }
    
    @IBAction func switch8(_ sender: UISwitch) {
        if sender.isOn == true {
            device8on()
        }
        else{
            device8off()
        }
        group.text = ""
    }
    
    @IBAction func slider(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        currentLoad.text = "LOAD(MWh)=\(currentValue)"
        
        if (currentValue >= 15000 && currentValue < 20000) {
            //use maximum power capacity
            //dryer+washing machine+dishwasher
            dryer.text="DRYER: ON"
            group.text = "GROUP A IS ON: USING 6700W"
            groupA()
            
        }
        if (currentValue >= 20000 && currentValue < 25000) {
            //use around 2/3 power capacity
            //Washing machine+lights+WATER HEATER;2+4
            group.text = "GROUP B IS ON: USING 5400"
            groupB()
            
            
        }
        if (currentValue >= 25000 && currentValue < 30000) {
            //use around 1/3 or less power capacity
            //Lights+computer+HVAC+TV
            group.text = "GROUP C IS ON: USING 1350W"
            groupC()
            
        }
        if (currentValue >= 30000 && currentValue < 35000) {
            //use minimum power capacity
            //lights+TV+HVAC
            group.text = "GROUP D IS ON: USING 1050W"
            groupD()
        }
        
        
    }
    
    

    @IBAction func simulate(_ sender: UISwitch) {
        if sender.isOn == true {
            appTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(appender), userInfo: nil, repeats: true)
        }
        else{
           chart.clear()
            numbers.removeAll()
            if appTimer != nil {
                appTimer.invalidate()
                appTimer = nil
            }
            k=0
        }
        group.text = ""
    }
    @IBAction func start(_ sender: Any) {
        
         appTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(appender), userInfo: nil, repeats: true)
    }
   // @IBAction func start(_ sender: Any) {
       // appTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(appender), userInfo: nil, repeats: true)
    //}
    var i = 1

    var numbers : [Double] = []
    var j = 0
    @objc func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
            let currentValue = numbers[i]
            currentLoad.text = "LOAD(MWh)=\(currentValue)"
            
            if (currentValue >= 15000 && currentValue < 20000) {
                //use maximum power capacity
                //dryer+washing machine+dishwasher
                //dryer.text="DRYER: ON"
                group.text = "GROUP A IS ON: USING 6700W"
                groupA()
                
            }
            if (currentValue >= 20000 && currentValue < 25000) {
                //use around 2/3 power capacity
                //Washing machine+lights+WATER HEATER;2+4
                group.text = "GROUP B IS ON: USING 5400"
                groupB()
                
                
            }
            if (currentValue >= 25000 && currentValue < 30000) {
                //use around 1/3 or less power capacity
                //Lights+computer+HVAC+TV
                group.text = "GROUP C IS ON: USING 1350W"
                groupC()
                
            }
            if (currentValue >= 30000 && currentValue < 35000) {
                //use minimum power capacity
                //lights+TV+HVAC
                group.text = "GROUP D IS ON: USING 1050W"
                groupD()
            }
            
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "LOAD(MWh)") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        
        chart.data = data //finally - it adds the chart data to the chart and causes an update
        chart.chartDescription?.text = "Load Factor" // Here we set the description for the graph
        j = j + 1
    }
    var k = 0
    @objc func appender(){
        var num : [Double] = [15000,20000,25000,30000,35000]
        //for j in 0..<numbers.count {
        numbers.append(num[k])
        //}
        updateGraph()
        k = k + 1
        if k == num.count {
            k = 0
        }
    }

    func groupA(){
        //use maximum power capacity
        //dryer+washing machine+dishwasher;4+5+6
        computer.text = "COMPUTER: OFF"
        lights.text  = "LIGHTS(40X10): OFF"
        hvac.text = "HVAC: OFF"
        washingMachine.text = "WASHING MACHINE: ON"
        dishwasher.text = "DISHWASHER: ON"
        dryer.text = "DRYER: ON"
        tv.text = "TV: OFF"
        waterheater.text = "WATER HEATER: OFF"
        let url = URL(string: arduinoServer+"g")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func groupB(){
        //use around 2/3 power capacity
        //Washing machine+lights+WATER HEATER;2+4+8
        computer.text = "COMPUTER: OFF"
        lights.text  = "LIGHTS(40X10): ON"
        hvac.text = "HVAC: OFF"
        washingMachine.text = "WASHING MACHINE: ON"
        dishwasher.text = "DISHWASHER: OFF"
        dryer.text = "DRYER: OFF"
        tv.text = "TV: OFF"
        waterheater.text = "WATER HEATER: ON"
        let url = URL(string: arduinoServer+"h")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func groupC(){
        //use around 1/3 or less power capacity
        //Lights+computer+HVAC+TV;1+2+3+7
        computer.text = "COMPUTER: ON"
        lights.text  = "LIGHTS(40X10): ON"
        hvac.text = "HVAC: ON"
        washingMachine.text = "WASHING MACHINE: OFF"
        dishwasher.text = "DISHWASHER: OFF"
        dryer.text = "DRYER: OFF"
        tv.text = "TV: ON"
        waterheater.text = "WATER HEATER: OFF"
        let url = URL(string: arduinoServer+"i")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func groupD(){
        
        //use minimum power capacity
        //lights+TV+HVAC;2+3+7
        computer.text = "COMPUTER: OFF"
        lights.text  = "LIGHTS(40X10): ON"
        hvac.text = "HVAC: ON"
        washingMachine.text = "WASHING MACHINE: OF"
        dishwasher.text = "DISHWASHER: OFF"
        dryer.text = "DRYER: OFF"
        tv.text = "TV: ON"
        waterheater.text = "WATER HEATER: OFF"
        let url = URL(string: arduinoServer+"j")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device1on(){
        computer.text = "COMPUTER: ON"
        let url = URL(string: arduinoServer+"1")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device2on(){
        lights.text = "LIGHTS(40X10): ON"
        let url = URL(string: arduinoServer+"3")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device3on(){
        hvac.text = "HVAC: ON"
        let url = URL(string: arduinoServer+"5")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device4on(){
        washingMachine.text = "WASHING MACHINE: ON"
        let url = URL(string: arduinoServer+"7")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device5on(){
        dishwasher.text = "DISHWASHER: ON"
        let url = URL(string: arduinoServer+"9")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device6on(){
        dryer.text = "DRYER: ON"
        let url = URL(string: arduinoServer+"a")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device7on(){
        tv.text = "TV: ON"
        let url = URL(string: arduinoServer+"c")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device8on(){
        waterheater.text = "WATER HEATER: ON"
        let url = URL(string: arduinoServer+"e")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device1off(){
        computer.text = "COMPUTER: OFF"
        let url = URL(string: arduinoServer+"2")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device2off(){
        lights.text = "LIGHTS(40X10): OFF"
        let url = URL(string: arduinoServer+"4")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device3off(){
        hvac.text = "HVAC: OFF"
        let url = URL(string: arduinoServer+"6")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device4off(){
        washingMachine.text = "WASHING MACHINE: OFF"
        let url = URL(string: arduinoServer+"8")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device5off(){
        dishwasher.text = "DISHWASHER: OFF"
        let url = URL(string: arduinoServer+"0")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device6off(){
        dryer.text = "DRYER: OFF"
        let url = URL(string: arduinoServer+"b")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device7off(){
        tv.text = "TV: OFF"
        let url = URL(string: arduinoServer+"d")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
    func device8off(){
        waterheater.text = "WATER HEATER: OFF"
        let url = URL(string: arduinoServer+"f")
        let req = URLRequest(url: url!)
        myWebView.load(req)
    }
}

