//
//  JSON.swift
//  azenia
//
//  Created by MacBook Pro on 6/12/21.
//

import Foundation

class JSON {
    static func saveJson2DicWithFileName(jsonObject: Any, toFilename filename: String) throws -> Bool{
        let documentsFolder = FileManager.default.urls(for: .documentDirectory,
        in: .userDomainMask)[0].appendingPathComponent("\(filename)_azenia.json")
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: documentsFolder, options: [.atomicWrite])
    

        return false
    }
    
    static func readJson2DicWithFileName(fileName:String) -> [Any] {
        let documentsFolder = FileManager.default.urls(for: .documentDirectory,
        in: .userDomainMask)[0].appendingPathComponent("\(fileName)_azenia.json")
        
        var jsonObject = [Any]()
        do{
            let data = try Data(contentsOf: documentsFolder)
            jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves]) as! [Any]
        } catch {
            return jsonObject
        }
        return jsonObject
    }
    
    static func checkJson2DicHasBytes(fileName: String) -> Bool {
        let fm = FileManager.default
        let documentsFolder = try? fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let folderURL = documentsFolder?.appendingPathComponent("azenia")
        if let url = folderURL {
            let filePath = url.appendingPathComponent(fileName).path
            if fm.fileExists(atPath: filePath) {
                var attributes: [FileAttributeKey : Any]? = nil
                do {
                    attributes = try fm.attributesOfItem(atPath: filePath)
                } catch {
                }
                let size = attributes?[FileAttributeKey.size] as? UInt64 ?? 0
                if attributes != nil && size == 0 {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        }
        return true
    }
}
