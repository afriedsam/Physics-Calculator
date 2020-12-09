//
//  ViewController.swift
//  1D Kinematics Calculator
//
//  Created by Aidan Friedsam on 12/8/20.
//

/*
 Formulas:
 v = v0 + at
 Δx = ((v + v0) / 2) * t
 Δx = v0 * t + ½*a*t2
 v2 = v02 + 2aΔx
 */

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vi_textField: UITextField!
    @IBOutlet weak var vf_textField: UITextField!
    @IBOutlet weak var delta_x_textField: UITextField!
    @IBOutlet weak var a_textField: UITextField!
    @IBOutlet weak var t_textField: UITextField!
    @IBOutlet weak var viLabel: UILabel!
    @IBOutlet weak var vfLabel: UILabel!
    @IBOutlet weak var deltaXLabel: UILabel!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var tLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    var vi: Double = -99999999999
    var vf: Double = -99999999999
    var a: Double = -99999999999
    var t: Double = -99999999999
    var delta_x: Double = -99999999999
    
    //For equation 3 if you solve for t there are two options so these handle instances where one or both instances = NaN or Inf
    var OP1isNanorInf: Bool = false
    var OP2isNanorInf: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        viLabel.adjustsFontSizeToFitWidth = true
        vfLabel.adjustsFontSizeToFitWidth = true
        deltaXLabel.adjustsFontSizeToFitWidth = true
        aLabel.adjustsFontSizeToFitWidth = true
        tLabel.adjustsFontSizeToFitWidth = true
    }
    
    //shake to clear
    override func becomeFirstResponder() -> Bool {
        return true
    }
    //shake to clear
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            clearPressed(clearButton)
            view.endEditing(true)
        }
    }
    
    // close keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func vi_changed(_ sender: UITextField) {
        if Double(sender.text!) == nil {
            vi_textField.text = nil
            viLabel.alpha = 0
        }
        else {
            vi = Double(sender.text!)!
            viLabel.alpha = 1
        }
        eqn_1(vf: vf, vi: vi, a: a, t: t)
        eqn_2(delta_x: delta_x, vf: vf, vi: vi, t: t)
        eqn_3(delta_x: delta_x, vi: vi, t: t, a: a)
        eqn_4(vf: vf, vi: vi, a: a, delta_x: delta_x)
    }
    
    @IBAction func vf_changed(_ sender: UITextField) {
        if Double(sender.text!) == nil {
            vf_textField.text = nil
            vfLabel.alpha = 0
        }
        else {
            vf = Double(sender.text!)!
            vfLabel.alpha = 1
        }
        eqn_1(vf: vf, vi: vi, a: a, t: t)
        eqn_2(delta_x: delta_x, vf: vf, vi: vi, t: t)
        eqn_3(delta_x: delta_x, vi: vi, t: t, a: a)
        eqn_4(vf: vf, vi: vi, a: a, delta_x: delta_x)
    }
    
    @IBAction func delta_x_changed(_ sender: UITextField) {
        if Double(sender.text!) == nil {
            delta_x_textField.text = nil
            deltaXLabel.alpha = 0
        }
        else {
            delta_x = Double(sender.text!)!
            deltaXLabel.alpha = 1
        }
        eqn_1(vf: vf, vi: vi, a: a, t: t)
        eqn_2(delta_x: delta_x, vf: vf, vi: vi, t: t)
        eqn_3(delta_x: delta_x, vi: vi, t: t, a: a)
        eqn_4(vf: vf, vi: vi, a: a, delta_x: delta_x)
    }
    
    
    @IBAction func a_changed(_ sender: UITextField) {
        if Double(sender.text!) == nil {
            a_textField.text = nil
            aLabel.alpha = 0
        }
        else {
            a = Double(sender.text!)!
            aLabel.alpha = 1
        }
        eqn_1(vf: vf, vi: vi, a: a, t: t)
        eqn_2(delta_x: delta_x, vf: vf, vi: vi, t: t)
        eqn_3(delta_x: delta_x, vi: vi, t: t, a: a)
        eqn_4(vf: vf, vi: vi, a: a, delta_x: delta_x)
    }
    
    @IBAction func t_changed(_ sender: UITextField) {
        if Double(sender.text!) == nil {
            t_textField.text = nil
            tLabel.alpha = 0
        }
        else {
            t = Double(sender.text!)!
            tLabel.alpha = 1
        }
        eqn_1(vf: vf, vi: vi, a: a, t: t)
        eqn_2(delta_x: delta_x, vf: vf, vi: vi, t: t)
        eqn_3(delta_x: delta_x, vi: vi, t: t, a: a)
        eqn_4(vf: vf, vi: vi, a: a, delta_x: delta_x)
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        vi = -99999999999
        vf = -99999999999
        a = -99999999999
        t = -99999999999
        delta_x = -99999999999
        vf_textField.text = nil
        vi_textField.text = nil
        a_textField.text = nil
        t_textField.text = nil
        delta_x_textField.text = nil
        vf_textField.isEnabled = true
        vi_textField.isEnabled = true
        a_textField.isEnabled = true
        t_textField.isEnabled = true
        delta_x_textField.isEnabled = true
        viLabel.alpha = 0
        vfLabel.alpha = 0
        deltaXLabel.alpha = 0
        aLabel.alpha = 0
        tLabel.alpha = 0
        vi_textField.backgroundColor = .none
        vf_textField.backgroundColor = .none
        delta_x_textField.backgroundColor = .none
        a_textField.backgroundColor = .none
        t_textField.backgroundColor = .none
    }
    
    func eqn_1(vf: Double, vi: Double, a: Double, t: Double) { //vf = vi + at
        if (vf == -99999999999) && (vi != -99999999999) && (a != -99999999999) && (t != -99999999999) { //solve for v final
            vf_textField.text = nil
            vf_textField.text = String(format: "%.2f", vi + a * t)
            vfLabel.alpha = 1
            vf_textField.isEnabled = false
            delta_x_textField.isEnabled = false
            vf_textField.backgroundColor = .green
          }
        else if (vf != -99999999999) && (vi == -99999999999) && (a != -99999999999) && (t != -99999999999) { //solve for v initial
            vi_textField.text = nil
            vi_textField.text = String(format: "%.2f", vf - (a * t))
            viLabel.alpha = 1
            vi_textField.isEnabled = false
            delta_x_textField.isEnabled = false
            vi_textField.backgroundColor = .green
          }
        else if (vf != -99999999999) && (vi != -99999999999) && (a == -99999999999) && (t != -99999999999) { //solve for a
            a_textField.text = nil
            a_textField.text = String(format: "%.2f", (vf - vi) / t)
            aLabel.alpha = 1
            a_textField.isEnabled = false
            delta_x_textField.isEnabled = false
            a_textField.backgroundColor = .green
          }
        else if (vf != -99999999999) && (vi != -99999999999) && (a != -99999999999) && (t == -99999999999){ //solve for t
            t_textField.text = nil
            t_textField.text = String(format: "%.2f", (vf - vi) / a)
            tLabel.alpha = 1
            t_textField.isEnabled = false
            delta_x_textField.isEnabled = false
            t_textField.backgroundColor = .green
          }
      }
    
    func eqn_2(delta_x: Double, vf: Double, vi: Double, t: Double) { //delta_x = ((vf + vi) / 2) * t
        if (delta_x == -99999999999) && (vf != -99999999999) && (vi != -99999999999) && (t != -99999999999) { //solve for delta x
            delta_x_textField.text = nil
            delta_x_textField.text = String(format: "%.2f", ((vf + vi) / 2.0) * t)
            deltaXLabel.alpha = 1
            delta_x_textField.isEnabled = false
            delta_x_textField.backgroundColor = .green
        }
        else if (delta_x != -99999999999) && (vf == -99999999999) && (vi != -99999999999) && (t != -99999999999) { //solve for v final
            vf_textField.text = nil
            vf_textField.text = String(format: "%.2f", ((delta_x / t) * 2.0) - vi)
            vfLabel.alpha = 1
            vf_textField.isEnabled = false
            vf_textField.backgroundColor = .green
        }
        else if (delta_x != -99999999999) && (vf != -99999999999) && (vi == -99999999999) && (t != -99999999999) { //solve for v initial
            vi_textField.text = nil
            vi_textField.text = String(format: "%.2f", ((delta_x / t) * 2.0) - vf)
            viLabel.alpha = 1
            vi_textField.isEnabled = false
            vi_textField.backgroundColor = .green
        }
        else if (delta_x != -99999999999) && (vf != -99999999999) && (vi != -99999999999) && (t == -99999999999) { //solve for t
            t_textField.text = nil
            t_textField.text = String(format: "%.2f", delta_x / ((vf + vi)/2.0))
            tLabel.alpha = 1
            t_textField.isEnabled = false
            t_textField.backgroundColor = .green
        }
    }
    
    func eqn_3(delta_x: Double, vi: Double, t: Double, a: Double) { //delta_x = vi*t + 1/2 * a * t^2
        if (delta_x == -99999999999) && (vi != -99999999999) && (t != -99999999999) && (a != -99999999999) { //solve for delta x
            delta_x_textField.text = nil
            delta_x_textField.text = String(format: "%.2f", vi * t + (1.0/2.0) * a * (pow(t, 2)))
            deltaXLabel.alpha = 1
            delta_x_textField.isEnabled = false
            delta_x_textField.backgroundColor = .green
        }
        else if (delta_x != -99999999999) && (vi == -99999999999) && (t != -99999999999) && (a != -99999999999) { //solve for vi
            vi_textField.text = nil
            vi_textField.text = String(format: "%.2f", (delta_x - ((1.0/2.0) * a * (pow(t, 2)))) / t)
            viLabel.alpha = 1
            vi_textField.isEnabled = false
            vi_textField.backgroundColor = .green
        }
        else if (delta_x != -99999999999) && (vi != -99999999999) && (t == -99999999999) && (a != -99999999999) { //solve for t
            t_textField.text = nil
            OP1isNanorInf = false
            OP2isNanorInf = false
            let descriminant = sqrt(pow(vi, 2) + 2.0 * a * delta_x)
            let negative_b = (-1.0 * vi)
            let option_1 = String(format: "%.2f", ((negative_b + descriminant) / a))
            let option_2 = String(format: "%.2f", ((negative_b - descriminant) / a))
            if option_1 == "inf" || option_1 == "-inf" || option_1 == "nan" {
                OP1isNanorInf = true
            }
            if option_2 == "inf" || option_2 == "-inf" || option_2 == "nan" {
                OP2isNanorInf = true
            }
            if OP1isNanorInf == true && OP2isNanorInf != true {
                t_textField.text = option_2
            }
            else if OP1isNanorInf != true && OP2isNanorInf == true {
                t_textField.text = option_1
            }
            else if OP1isNanorInf != true && OP2isNanorInf != true {
                t_textField.text = "\(option_1) or \(option_2)"
            }
            else {
                t_textField.text = "NO SOLUTION"
            }
            tLabel.alpha = 1
            t_textField.isEnabled = false
            t_textField.backgroundColor = .green
        }
        else if (delta_x != -99999999999) && (vi != -99999999999) && (t != -99999999999) && (a == -99999999999) { //solve for a
            a_textField.text = nil
            a_textField.text = String(format: "%.2f", ((2.0 * (delta_x - vi * t)) / pow(t, 2)))
            aLabel.alpha = 1
            a_textField.isEnabled = false
            a_textField.backgroundColor = .green
        }
    }
    
    func eqn_4(vf: Double, vi: Double, a: Double, delta_x: Double) { //vf^2 = vi^2 + 2 * a * delta_x
        if (vf == -99999999999) && (vi != -99999999999) && (a != -99999999999) && (delta_x != -99999999999) { //solve for vf
            vf_textField.text = nil
            let option_1 = String(format: "%.2f", sqrt(pow(vi, 2) + 2.0 * a * delta_x))
            let option_2 = Double(String(format: "%.2f", sqrt(pow(vi, 2) + 2.0 * a * delta_x)))! * -1.0
            vf_textField.text = String(format: "%.2f", sqrt(pow(vi, 2) + 2.0 * a * delta_x))
            vfLabel.alpha = 1
            vf_textField.isEnabled = false
            vf_textField.backgroundColor = .green
            
            if OP1isNanorInf != true && OP2isNanorInf != true {
                vf_textField.text = "\(option_1) or \(option_2)"
            }
        }
        else if (vf != -99999999999) && (vi == -99999999999) && (a != -99999999999) && (delta_x != -99999999999) { //solve for vi
            vi_textField.text = nil
            vi_textField.text = String(format: "%.2f", sqrt(pow(vf, 2) - (2.0 * a * delta_x)))
            viLabel.alpha = 1
            vi_textField.isEnabled = false
            vi_textField.backgroundColor = .green
        }
        else if (vf != -99999999999) && (vi != -99999999999) && (a == -99999999999) && (delta_x != -99999999999) { //solve for a
            a_textField.text = nil
            a_textField.text = String(format: "%.2f", (pow(vf, 2) - pow(vi, 2)) / (2 * delta_x))
            aLabel.alpha = 1
            a_textField.isEnabled = false
            a_textField.backgroundColor = .green
        }
        else if (vf != -99999999999) && (vi != -99999999999) && (a != -99999999999) && (delta_x == -99999999999) { //solve for delta_x
            delta_x_textField.text = nil
            delta_x_textField.text = String(format: "%.2f", (pow(vf, 2) - pow(vi, 2)) / (2 * a))
            deltaXLabel.alpha = 1
            delta_x_textField.isEnabled = false
            delta_x_textField.backgroundColor = .green
        }
    }
    
    
    @IBAction func negateVI(_ sender: UIButton) {
        if vi != -99999999999 { //Only negate if a number has been entered
            vi = vi * -1.0
            vi_textField.text = String(vi)
            eqn_1(vf: vf, vi: vi, a: a, t: t)
            eqn_2(delta_x: delta_x, vf: vf, vi: vi, t: t)
            eqn_3(delta_x: delta_x, vi: vi, t: t, a: a)
            eqn_4(vf: vf, vi: vi, a: a, delta_x: delta_x)
        }
    }
    
    @IBAction func negateVF(_ sender: UIButton) {
        if vf != -99999999999 {
            vf = vf * -1.0
            vf_textField.text = String(vf)
            eqn_1(vf: vf, vi: vi, a: a, t: t)
            eqn_2(delta_x: delta_x, vf: vf, vi: vi, t: t)
            eqn_3(delta_x: delta_x, vi: vi, t: t, a: a)
            eqn_4(vf: vf, vi: vi, a: a, delta_x: delta_x)
        }
    }
    
    @IBAction func negateDeltaX(_ sender: UIButton) {
        if delta_x != -99999999999 {
            delta_x = delta_x * -1.0
            delta_x_textField.text = String(delta_x)
            eqn_1(vf: vf, vi: vi, a: a, t: t)
            eqn_2(delta_x: delta_x, vf: vf, vi: vi, t: t)
            eqn_3(delta_x: delta_x, vi: vi, t: t, a: a)
            eqn_4(vf: vf, vi: vi, a: a, delta_x: delta_x)
        }
    }
    
    @IBAction func negateA(_ sender: UIButton) {
        if a != -99999999999 {
            a = a * -1.0
            a_textField.text = String(a)
            eqn_1(vf: vf, vi: vi, a: a, t: t)
            eqn_2(delta_x: delta_x, vf: vf, vi: vi, t: t)
            eqn_3(delta_x: delta_x, vi: vi, t: t, a: a)
            eqn_4(vf: vf, vi: vi, a: a, delta_x: delta_x)
        }
    }
    
    @IBAction func negateT(_ sender: Any) {
        if t != -99999999999 {
            t = t * -1.0
            t_textField.text = String(t)
            eqn_1(vf: vf, vi: vi, a: a, t: t)
            eqn_2(delta_x: delta_x, vf: vf, vi: vi, t: t)
            eqn_3(delta_x: delta_x, vi: vi, t: t, a: a)
            eqn_4(vf: vf, vi: vi, a: a, delta_x: delta_x)
        }
    }
    

}

