
import Foundation


func nullParser(input: String) -> [Any?]?
{
    if(input.hasPrefix("null"))
    {
        let remInput = String(input.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(4))
        return [nil, remInput]
    }
    return nil
}

func boolParser(input: String) -> [Any?]?
{
    if(input.hasPrefix("true"))
    {
        let remInput = String(input.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(4))
        return [true, remInput]
    }
    else if(input.hasPrefix("false"))
    {
        let remInput = String(input.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(5))
        return [false, remInput]
    }
    return nil
}

func stringParser(input: String)->[Any?]?
{
    var inputArray = Array(input.trimmingCharacters(in: .whitespacesAndNewlines)) //input string converted to Array
    var strArray = [String]() //string array where the resultant string is stored
    var foundClosingQuotes = false

    if(inputArray[0] == "\"")//Checking for the initial quotes
    {
        inputArray.remove(at: 0)//Removing the initial quotes from input

        var totalCount = inputArray.count

        while totalCount > 0
        {
            let val = inputArray[0]
            switch val
            {
            case "\\":
                if["\"","\\","/","b","f","n","r","t"].contains(String(inputArray[1]))
                {
                    strArray.append(String(inputArray.remove(at: 0)))
                    strArray.append(String(inputArray.remove(at: 0)))

                    totalCount = totalCount - 2
                }
                else if String(inputArray[1]) == "u" //
                {
                    if(inputArray.indices.contains(5))
                    {
                        strArray.append(String(inputArray.remove(at: 0)))//Remove "\\"
                        strArray.append(String(inputArray.remove(at: 0)))//Remove "u"

                        totalCount = totalCount - 2

                        for _ in 0...3
                        {
                            if["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","a", "b","c", "d","e","f"].contains(String(inputArray[0]))
                            {
                                strArray.append(String(inputArray.remove(at: 0)))
                                totalCount = totalCount - 1
                            }
                            else
                            {
                                return nil
                            }
                        }
                    }
                    else
                    {
                        return nil
                    }
                }
                else
                {
                    return nil
                }
            case "\"":  //the final quotes found
                inputArray.remove(at: 0)//Remove the final quotes from inputArray
                foundClosingQuotes = true

                return[strArray.joined(), String(inputArray)]

            default:
                strArray.append(String(inputArray.remove(at: 0)))
                totalCount = totalCount - 1
            }
        }

        if(foundClosingQuotes)
        {
            return[strArray.joined(), String(inputArray)]
        }
        else
        {
            return nil
        }
    }
    return nil
}

func numberParser(input: String) -> [Any?]?
{
    var inputArray = Array(input) //input string converted to Array
    var intCount = 0 //total count of integers
    var intArray = [String]() //Array where we append the integers

    var isDecimalDone = false       //decimal point has been found
    var isExponentDone = false      //the exponent has been found
    var isMinusDone = false         //the "-" symbol after e/E
    var isPlusDone = false          //the "+" symbol after e/E
    var totalCount = inputArray.count
    var index = 0

    if( ["0","1","2","3","4","5","6","7","8","9"].contains(inputArray[0]) || inputArray[0]=="-" )
    {
        while totalCount > 0
        {
            let val = inputArray[0]
            switch val
            {
            case "-":
                if(isMinusDone==false)
                {
                    if let _:Int = Int(String(inputArray[1])) //checking if digits are there after - symbol
                    {
                        if(index == 0 || isExponentDone)//if its a -ve no. or the - sign after e/E
                        {
                            intArray.append("-")
                            inputArray.remove(at: 0)
                            totalCount = totalCount - 1
                            index = index + 1

                            if(isExponentDone)
                            {
                                isMinusDone = true
                            }
                        }
                        else
                        {
                            return nil
                        }
                    }
                    else
                    {
                        return nil
                    }
                }
                else
                {
                    return nil
                }
            case "+":
                if(isPlusDone==false && isExponentDone)
                {
                    if let _:Int = Int(String(inputArray[1])) //checking if digits are there after - symbol
                    {
                        intArray.append("+")
                        inputArray.remove(at: 0)

                        totalCount = totalCount - 1
                        isPlusDone = true
                    }
                    else
                    {
                        return nil
                    }
                }
                else
                {
                    return nil
                }
            case "1","2","3","4","5","6","7","8","9":
                intCount += 1
                intArray.append(String(val))

                inputArray.remove(at: 0)
                totalCount = totalCount - 1
            case "0":
                if( (intCount > 0) || (inputArray.count == 1) || !(["0","1","2","3","4","5","6","7","8","9"].contains(inputArray[1])) ) //if 0 then check 0 is not the first element or only 0 or 0}}
                {
                    intCount += 1
                    intArray.append(String(val))
                    inputArray.remove(at: 0)
                    totalCount = totalCount - 1
                }
                else
                {
                    return nil
                }
            case ".":
                if(isDecimalDone == false && intCount > 0) //check if there are no decimal points before & there are integers before the decimal point
                {
                    if let _:Int = Int(String(inputArray[1])) //checking if digits are there after . "decimal point" symbol
                    {
                        intArray.append(".")
                        inputArray.remove(at: 0)
                        totalCount = totalCount - 1
                        isDecimalDone = true
                    }
                    else
                    {
                        return nil
                    }
                }
                else
                {
                    return nil
                }
            case "e", "E":
                if(isExponentDone==false)
                {
                    intArray.append(String(val))
                    inputArray.remove(at: 0)
                    totalCount = totalCount - 1
                    isExponentDone = true
                }
            default:
                if((intArray.joined()).isInteger) //if input is an Integer
                {
                    return [Int(intArray.joined()), String(inputArray)]
                }

                if((intArray.joined()).isFloat) //if input is a Float
                {
                    return [Float(intArray.joined()), String(inputArray)]
                }

                //else by default float
                return [Double(intArray.joined()), String(inputArray)]
            }
        }
    }
    else
    {
        return nil
    }

    if((intArray.joined()).isInteger) //if input is an Integer
    {
        return [Int(intArray.joined()), String(inputArray)]
    }

    if((intArray.joined()).isFloat) //if input is a Float
    {
        return [Float(intArray.joined()), String(inputArray)]
    }

    //else by default float
    return [Double(intArray.joined()), String(inputArray)]
}

extension String //Extension to down-cast
{
    var isInteger: Bool { return Int(self) != nil }
    var isFloat: Bool { return Float(self) != nil }
    var isDouble: Bool { return Double(self) != nil }
}

func arrayParser(input: String) -> [Any?]?
{
    if(input.hasPrefix("["))
    {
        var inputString = String(input.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines) /* Removing the "[" from the first element of                                               the array and then remove the spaces*/

        var resultArray = [Any?]()
        var foundType = false //To mark if the type of the element of the array isfound

        while(inputString.count > 0)
        {
            if(inputString.hasPrefix("]"))
            {
                inputString = String(inputString.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
                return [resultArray, inputString]
            }

            for function in arrFunc
            {
                if let result = function(inputString)//passing the inputString to various parsers to check their type
                {
                    resultArray.append(result[0])
                    inputString = result[1] as! String
                    foundType = true
                    break
                }
            }

            if(foundType == false)
            {
                return nil
            }

            foundType = false //reset foundType

            inputString = inputString.trimmingCharacters(in: .whitespacesAndNewlines)

            if(inputString[inputString.startIndex] == "]")
            {
                if(inputString.count > 0)
                {
                    inputString = String(inputString.dropFirst())
                }

                return [resultArray, inputString]
            }

            if(inputString[inputString.startIndex] == ",")
            {
                if(inputString.count > 0)
                {
                    inputString = String(inputString.dropFirst())
                }
                if(inputString.count > 0)
                {
                    if(inputString[inputString.startIndex] == "]") //for extra commas
                    {
                        return nil
                    }
                }
            }

            inputString = inputString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return nil
    }
    return nil
}

func objectParser(input: String)->[Any?]?
{
    //print("OBJECT PARSER CALLED")
    //let parsers = [nullParser, boolParser, numberParser, stringParser, arrayParser, objectParser]
    var inputString  = input.trimmingCharacters(in: .whitespacesAndNewlines) //Convert to mutable string

    if(inputString[inputString.startIndex] == "{") //Return nil if first char is not a "{"
    {
        var resultObject = [String:Any]() //The result where the object will be appended
        var foundType = false //To mark if the TYPE of the element is found

        inputString = String(inputString.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines) //Removing the first "{"

        if(inputString[inputString.startIndex] == "}")
        {
            inputString = String(inputString.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
            return [resultObject, inputString]
        }

        while(inputString.count > 0)
        {
            inputString = inputString.trimmingCharacters(in: .whitespacesAndNewlines)//removing the front and trailing spaces

            var remString = stringParser(input: inputString)//Check if the element after "{" must be a string

            if(remString == nil)
            {
                return nil //if not string then return nil
            }
            else
            {
                let firstKey = remString![0] as! String //Extract the key

                //take the rest as inputString
                inputString = (remString![1] as! String).trimmingCharacters(in: .whitespacesAndNewlines)

                if(inputString[inputString.startIndex] != ":") // After "String" key if ":" is not found then nil
                {
                    return nil
                }

                inputString = String(inputString.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines) //Removing ":" and whiteSpaces

                //Checking for the value
                for function in arrFunc
                {
                    if let result = function(inputString)//passing the extracted elements to various parsers to check their type
                    {
                        if(result[0] == nil)  // Only for nil values
                        {
                            resultObject[firstKey] = NSNull()
                        }
                        else
                        {
                            resultObject[firstKey] = result[0] //Adding the key:value pair to the dictionary
                        }

                        //inputString will contain the remaining string sent after parsing and we are trimming the white spaces

                        inputString = (result[1] as! String).trimmingCharacters(in: .whitespacesAndNewlines)

                        foundType = true
                        break
                    }
                }

                if(foundType == false)
                {
                    return nil
                }
                foundType = false //reset foundType

                //handling the "}" and "," after that
                if let indexOfSeparation = inputString.firstIndex(where: { ($0 == ",") || ($0 == "}") })
                {
                    let charSeparation = inputString[indexOfSeparation] //is it "," or "}"

                    if charSeparation == "}"
                    {
                        inputString = String(inputString.dropFirst()) //Remove the "}"
                        return [resultObject, inputString]
                    }

                    if charSeparation == ","
                    {
                        inputString = String(inputString.dropFirst()) //Remove the ","
                    }
                }
                else
                {
                    return nil
                }
            }
        }
    }
    return nil
}

let arrFunc = [nullParser, boolParser, stringParser, numberParser, arrayParser, objectParser]

func valueParser(input: String)->[Any?]?
{
    var inputString = input //make input string mutable
    inputString = inputString.trimmingCharacters(in: .whitespacesAndNewlines)

    for function in arrFunc
    {
        if let result = function(inputString)
        {
            return result
        }
    }
    return nil
}

func readFromFile(fileName: String)->[Any?]?
{
    if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do
        {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            return (valueParser(input: content))
        }
        catch {
              print(error.localizedDescription)
        }
    }
    else
    {
        print("FileNotFound")
    }

    return nil
}


/**********************************************/
//TEST-CASES for value-parser

//let resPass4 = readFromFile(fileName: "pass4.json")
//print(resPass4![0] as! Any)
//print(resPass4![1] as Any)
//print(resPass4![0] as! NSDictionary)
//print(resPass4![0] as! [String:Any])



//let resPass6 = readFromFile(fileName: "pass6.json")
//print(resPass6![0] as! Any)
