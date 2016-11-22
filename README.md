# FileSaveHelper # Swift 3
Save files of type text, jpeg or json.


USAGE:

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
