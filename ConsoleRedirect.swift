//
//  ConsoleRedirect.swift
//  ConsoleRedirect
//
//  Created by Luo Qisheng on 2022/8/16.
//

import Foundation
import CocoaAsyncSocket

class OutputListener {
    /// consumes the messages on STDOUT
    let inputPipe = Pipe()

    /// outputs messages back to STDOUT
    let outputPipe = Pipe()
}

public class ConsoleRedirect: NSObject {
    var port: DevicePort?
    var asyncSocket: GCDAsyncSocket?
    var connectedSocket: GCDAsyncSocket?
    let outputListener = OutputListener()
    
    var data: Data? = Data()
    var connected = false
    
    public override init () {
        super.init()
        
        if !self.isiOSAppOnMac() {
            self.port = DevicePort(delegate: self)
            port?.open()
        } else {
            self.asyncSocket = GCDAsyncSocket(delegate: self, delegateQueue: .main)
            self.asyncSocket?.enableBackgroundingOnSocket()
            do {
                 try self.asyncSocket?.accept(onPort: 4568)
            } catch {
                print(error)
            }
        }
        
        // Copy STDOUT/STDERR file descriptor to outputPipe for writing strings back to STDOUT
        dup2(STDERR_FILENO, outputListener.outputPipe.fileHandleForWriting.fileDescriptor)
        dup2(STDOUT_FILENO, outputListener.outputPipe.fileHandleForWriting.fileDescriptor)

        // Intercept STDERR/STDOUT with inputPipe
        dup2(outputListener.inputPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        dup2(outputListener.inputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

        // listening on the readabilityHandler
        outputListener.inputPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard let self = self else { return }
            if !self.isiOSAppOnMac() {
                if self.connected == true {
                    if let data = self.data, !data.isEmpty {
                        self.port?.writeData(data: data)
                        self.data = nil
                    }
                    self.port?.writeData(data: data)
                } else {
                    self.data?.append(data)
                }
            } else if let connectedSocket = self.connectedSocket {
                connectedSocket.write(data, withTimeout: -1, tag: 0)
            }
          
            // Write input back to stdout/stderr
            self.outputListener.outputPipe.fileHandleForWriting.write(data)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) { [weak self] in
            // clean
            guard let self = self else { return }
            if !self.connected {
                self.clean()
            }
        }
    }
    
    private func isiOSAppOnMac() -> Bool {
        if #available(iOS 14.0, *) {
            return ProcessInfo.processInfo.isiOSAppOnMac || ProcessInfo.processInfo.environment["SIMULATOR_HOST_HOME"] != nil
        } else {
            return ProcessInfo.processInfo.environment["SIMULATOR_HOST_HOME"] != nil
        }
    }
    
    private func clean() {
        self.data = nil
        self.connectedSocket = nil
        self.asyncSocket = nil
        self.port?.close()
        self.port = nil
    }
}

extension ConsoleRedirect: PortDelegate {
    public func port(didConnect port: Port) {
        self.connected = true
    }
    
    public func port(didDisconnect port: Port) {
        self.connected = false
        self.clean()
    }
    
    public func port(port: Port, didReceiveData data: OOData) {
        
    }
}

extension ConsoleRedirect: GCDAsyncSocketDelegate {
    public func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        self.connectedSocket = newSocket
    }
}
