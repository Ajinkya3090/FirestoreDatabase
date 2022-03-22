//
//  TranslatorViewModel.swift
//  FirestoreDatabase
//
//  Created by Admin on 16/03/22.
//

import Foundation
import MLKitTranslate

class TranslatorViewModel {
    
    let languagesss: [TranslateLanguage] = [.english, .german, .spanish , .hindi , .marathi, .bengali, .gujarati]
    
    func translateText(text: String,language: TranslateLanguage,completion:@escaping(_ str:String)->()) {
        let translate = TranslatorOptions(sourceLanguage: .english, targetLanguage: language)
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: language)
        let englishTranslator = Translator.translator(options: options)
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        englishTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            englishTranslator.translate(text) { translatedText, error in
                guard error == nil, let translatedText = translatedText else { return }
                completion(translatedText)
                
            }
        }
    }
    func switchCases(language:TranslateLanguage)->String{
        switch language{
        case .english :
            return "English"
        case .german :
            return "German"
        case .spanish :
            return "Spanish"
        case .hindi :
            return "Hindi"
        case .marathi :
            return "Marathi"
        case .bengali :
            return "Bangali"
        case .gujarati :
            return "Gujarati"
        default:
            return ""
        }
        
    }
}
/*
 case .af: return "Afrikaans"
 case .ar: return "Arabic"
 case .be: return "Belarusian"
 case .bg: return "Bulgarian"
 case .bn: return "Bengali"
 case .ca: return "Catalan"
 case .cs: return "Czech"
 case .cy: return "Welsh"
 case .da: return "Danish"
 case .de: return "German"
 case .el: return "Greek"
 case .en: return "English"
 case .eo: return "Esperanto"
 case .es: return "Spanish"
 case .et: return "Estonian"
 case .fa: return "Persian"
 case .fi: return "Finnish"
 case .fr: return "French"
 case .ga: return "Irish"
 case .gl: return "Galician"
 case .gu: return "Gujarati"
 case .he: return "Hebrew"
 case .hi: return "Hindi"
 case .hr: return "Croatian"
 case .ht: return "Haitian"
 case .hu: return "Hungarian"
 case .id: return "Indonesian"
 case .is: return "Icelandic"
 case .it: return "Italian"
 case .ja: return "Japanese"
 case .ka: return "Georgian"
 case .kn: return "Kannada"
 case .ko: return "Korean"
 case .lt: return "Lithuanian"
 case .lv: return "Latvian"
 case .mk: return "Macedonian"
 case .mr: return "Marathi"
 case .ms: return "Malay"
 case .mt: return "Maltese"
 case .nl: return "Dutch"
 case .no: return "Norwegian"
 case .pl: return "Polish"
 case .pt: return "Portuguese"
 case .ro: return "Romanian"
 case .ru: return "Russian"
 case .sk: return "Slovak"
 case .sl: return "Slovenian"
 case .sq: return "Albanian"
 case .sv: return "Swedish"
 case .sw: return "Swahili"
 case .ta: return "Tamil"
 case .te: return "Telugu"
 case .th: return "Thai"
 case .tl: return "Tagalog"
 case .tr: return "Turkish"
 case .uk: return "Ukranian"
 case .ur: return "Urdu"
 case .vi: return "Vietnamese"
 case .zh: return "Chinese"
 */
