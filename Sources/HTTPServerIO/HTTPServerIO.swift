import Foundation
import SimpleFunctional

/// A simple http web server.
/// Note: Will block thread handle(output:) is called on when starting the server.
/// This class is not thread-safe. It should be used on one thread, in-order.
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
