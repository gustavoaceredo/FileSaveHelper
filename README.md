# FileSaveHelper # Swift 3
Save files of type text, jpeg or json.


USAGE FOR TEXT FILE:
```swift
//create the text that will be stored in your file
let myText = "Some text"

//write to txt file
let testFile = FileSaveHelper(fileName: "testFile", fileExtension: .TXT, subDirectory: "SavingFiles", directory: .documentDirectory)
    
    do {
      //print the data
      print(try testFile.getContentsOfFile())
    } catch {
      print (error)
    }
```

USAGE FOR JSON FILE:

```swift
//create an array with your desired dictionary objects
let dic = ["color": "red", "format": "italic", "type": "text"]
        
//write to a JSON file
let jsonFile = FileSaveHelper(fileName:"jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
do {
   //save the file and print the data
   try jsonFile.saveFile(dataForJson: dic as AnyObject)
   print(try jsonFile.getJSONData())
}
catch {
   print(error)
}
```
USAGE FOR IMAGE FILE:
```swift
//create the image that will be stored in your file
let myImage = UIImage(named: "testImage.jpeg")

//write to txt file
let testFile = FileSaveHelper(fileName: "testFile", fileExtension: .JPEG, subDirectory: "SavingFiles", directory: .documentDirectory)
    
    do {
      try testFile.saveFile(image: myImage!)
      //print the data
      print(try testFile.getImage())
    } catch {
      print (error)
    }

```
