# HTTPServerIO

HTTP Server IO type and handler for use with the SimpleFunctional library.

Provides a very basic HTTP web server as an IO handler. Will be extended as needed to handle more complex requests.

This is powered using [Vapor's HTTP library](https://github.com/vapor/http), which means it is a multi-platform IO handler. Linux, Mac, iOS


```swift
public struct HTTPServerIO: IO {
    
    public struct HTTPHeaders {
        public enum StandardHeader {
            case authorization
        }
        
        public let stringValuesForStandardHeader: [StandardHeader: [String]]
    }
    
    public enum Input {
        case serverStarted
        case incomingRequest(id: UInt, urlString: String, httpHeaders: HTTPHeaders)
    }
    
    public enum Output {
        case startServer(hostname: String, port: UInt)
        case respondToRequest(id: UInt, httpStatusCode: UInt, bodyBytes: [UInt8]?)
    }
}


```