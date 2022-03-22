//
//  TranslationViewController.swift
//  FirestoreDatabase
//
//  Created by Admin on 17/03/22.
//

import UIKit
import MLKitTranslate
import MLKitCommon

class TranslationViewController: UIViewController {
    @IBOutlet weak var tVEnglish: UITextView!
    @IBOutlet weak var btnTranslate: UIButton!
    @IBOutlet weak var pickerViewLangauge: UIPickerView!
    @IBOutlet weak var tVTranslatedText: UITextView!
    var langFrmViewModel : TranslateLanguage?
    let translationViewModel = TranslatorViewModel()
    
    
    
    override func viewDidLoad() {
        pickerViewLangauge.delegate = self
        pickerViewLangauge.dataSource = self
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textViewDidChangeWithNotification(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
//    @IBAction func tapToTranslate(_ sender: Any) {
//        translationViewModel.translateText(text: tVEnglish.text, language: langFrmViewModel ?? .english) { str in
//            self.tVTranslatedText.text = str
//        }
//    }
    
    @objc private func textViewDidChangeWithNotification(_ notification: Notification) {
        translationViewModel.translateText(text: tVEnglish.text, language: langFrmViewModel ?? .german) { str in
            self.tVTranslatedText.text = str
        }
    }
}

extension TranslationViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return translationViewModel.languagesss.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return translationViewModel.switchCases(language: translationViewModel.languagesss[row])
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        btnTranslate.setTitle(translationViewModel.switchCases(language: translationViewModel.languagesss[row]), for: .normal)
        self.langFrmViewModel = translationViewModel.languagesss[row]
    }
}
