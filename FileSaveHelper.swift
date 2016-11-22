//
//  FileSaveHelper.swift
//  snapchat_filters
//
//  Created by Roxana Stan on 22/11/2016.
//  Copyright © 2016 Roxana Stan. All rights reserved.
//

import Foundation
import UIKit

class FileSaveHelper {
    
    // MARK:- Error Types
    private enum FileErrors:Error {
        case JsonNotSerialized
        case FileNotSaved
        case ImageNotConvertedToData
        case FileNotRead
        case FileNotFound
    }
    
    // Create an enum to contain the file types allowed by this class.
    // MARK:- File Extension Types
    enum FileExension:String {
        case TXT = ".txt"
        case JPG = ".jpg"
        case JSON = ".json"
    }
    
    // MARK:- Private Properties
    private let directory:FileManager.SearchPathDirectory
    private let directoryPath: String
    private let fileManager = FileManager.default
    private let fileName:String
    private let filePath:String
    private let fullyQualifiedPath:String
    private let subDirectory:String
    

    // Use the default file manager to check if they exist.
    var fileExists:Bool {
    get {
        return fileManager.fileExists(atPath: fullyQualifiedPath)
    }
    }

    var directoryExists:Bool {
    get {
        var isDir = ObjCBool(true)
        return fileManager.fileExists(atPath: filePath, isDirectory: &isDir )
    }
    }

    // Init with 4 params.
    // 1 - fileName: The name of the file.
    // 2 - fileExtension: The extension the file is going to use. This will be provided using the enum FileExtension.
    // 3 - subDirectory: The name of the sub directory where we will save the file.
    // 4 - directory: The directory the file will be saved in.
    init(fileName:String, fileExtension:FileExension, subDirectory:String, directory:FileManager.SearchPathDirectory){
        self.fileName = fileName + fileExtension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        
        print(self.directoryPath)
        createDirectory()
    }
    
    private func createDirectory(){
        
        if !directoryExists {
            do {
                
                try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("An Error was generated creating directory")
            }
        }
    }
    
    
    func saveFile(string fileContents:String) throws{
        do {
            
            try fileContents.write(toFile: fullyQualifiedPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch  {
            
            throw error
        }
    }
    
    func saveFile(dataForJson:AnyObject) throws{
        do {
            //2
            let jsonData = try convertObjectToData(data: dataForJson)
            if !fileManager.createFile(atPath: fullyQualifiedPath, contents: jsonData as Data, attributes: nil){
                throw FileErrors.FileNotSaved
            }
        } catch {
            //3
            print(error)
            throw FileErrors.FileNotSaved
        }
        
    }
    
    func saveFile(image:UIImage) throws {
        // 2
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
            throw FileErrors.ImageNotConvertedToData
        }
        // 3
        if !fileManager.createFile(atPath: fullyQualifiedPath, contents: data, attributes: nil){
            throw FileErrors.FileNotSaved
        }
    }
    
    private func convertObjectToData(data:AnyObject) throws -> NSData {
        
        do {
            //5
            let newData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return newData as NSData
        }
            //6
        catch {
            print("Error writing data: \(error)")
        }
        throw FileErrors.JsonNotSerialized
    }
    
    //function used for text type files
    func getContentsOfFile() throws -> String {
        // 2
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        
        // 3
        var returnString:String
        do {
            returnString = try String(contentsOfFile: fullyQualifiedPath, encoding: String.Encoding.utf8)
        } catch {
            throw FileErrors.FileNotRead
        }
        // 4
        return returnString
    }
    
    // function used for image type files
    func getImage() throws -> UIImage {
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        
        guard let image = UIImage(contentsOfFile: fullyQualifiedPath) else {
            throw FileErrors.FileNotRead
        }
        
        return image
    }
    
    // function used for json type files
    func getJSONData() throws -> NSDictionary {
        // 2
        guard fileExists else {
            throw FileErrors.FileNotSaved
        }
        
        do {
            // 3
            let data = try NSData(contentsOfFile: fullyQualifiedPath, options: NSData.ReadingOptions.mappedIfSafe)
            // 4
            let jsonDictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! NSDictionary
            return jsonDictionary
        } catch {
            throw FileErrors.FileNotSaved
        }
    }
}
