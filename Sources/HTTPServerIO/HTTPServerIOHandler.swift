import Foundation
import HTTP
import NIO
import SimpleFunctional

public final class HTTPServerIOHandler: BaseIOHandler<HTTPServerIO>, HTTPServerResponder {
    
    public override func handle(output: Output) {
        switch output {
        case let .startServer(hostname, port): startServer(hostname: hostname, port: port)
        case let .respondToRequest(id, httpStatusCode, bodyBytes): respondToRequest(id: id, httpStatusCode: httpStatusCode, bodyBytes: bodyBytes)
        }
    }
    
    // MARK: - HTTPServerResponder
    
    public func respond(to req: HTTPRequest, on worker: Worker) -> Future<HTTPResponse> {
        let id = nextRequestId
        nextRequestId += 1
        
        let promise = worker.eventLoop.newPromise(of: HTTPResponse.self)
        responsePromiseForId[id] = promise
        
        let headers = HTTPServerIO.HTTPHeaders(stringValuesForStandardHeader: [.authorization : req.headers["authorization"]])
        runInput(.incomingRequest(id: id, urlString: req.urlString, httpHeaders: headers))
        
        return promise.futureResult
    }
    
    // MARK: - Private
    
    private var nextRequestId = UInt(0)
    private var responsePromiseForId = [UInt: Promise<HTTPResponse>]()
    private var server: HTTPServer?
    
    private func startServer(hostname: String, port: UInt) {
        guard server == nil else { return }
        
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        // Make sure to shutdown the group when the application exits.
        defer { try! group.syncShutdownGracefully() }
        
        server = try! HTTPServer.start(
            hostname: hostname,
            port: Int(port),
            responder: self,
            on: group
        ).wait()
        
        runInput(.serverStarted)
    }
    
    private func respondToRequest(id: UInt, httpStatusCode: UInt, bodyBytes: [UInt8]?) {
        guard let promise = responsePromiseForId[id] else { return }
        responsePromiseForId[id] = nil
        
        let data = bodyBytes.flatMap { Data($0) } ?? Data()
        promise.succeed(result: .init(status: .init(statusCode: Int(httpStatusCode)), body: data))
    }
}
