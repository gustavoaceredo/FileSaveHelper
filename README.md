# FileSaveHelper # Swift 3
Save files of type text, jpeg or json.


USAGE:

```javascript
//create an array with your desired dictionary objects

let dic = ["color": "red", "format": "italic", "type": "text"]
        
let jsonFile = FileSaveHelper(fileName:"jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
do {
   try jsonFile.saveFile(dataForJson: dic as AnyObject)
   print(try jsonFile.getJSONData())
}
   catch {
         print(error)
   }
```
