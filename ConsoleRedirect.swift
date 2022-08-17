//
//  ConsoleRedirect.swift
//  ConsoleRedirect
//
//  Created by Luo Qisheng on 2022/8/16.
//

import Foundation

class OutputListener {
    /// consumes the messages on STDOUT
    let inputPipe = Pipe()

    /// outputs messages back to STDOUT
    let outputPipe = Pipe()
}

public class ConsoleRedirect: NSObject {
    var port: DevicePort?
    let outputListener = OutputListener()
    
    var data: Data = Data()
    var connected = false
    
    public override init () {
        super.init()
        self.port = DevicePort(delegate: self)
        port?.open()
        
        // Copy STDOUT/STDERR file descriptor to outputPipe for writing strings back to STDOUT
        dup2(STDERR_FILENO, outputListener.outputPipe.fileHandleForWriting.fileDescriptor)
        dup2(STDOUT_FILENO, outputListener.outputPipe.fileHandleForWriting.fileDescriptor)

        // Intercept STDERR/STDOUT with inputPipe
        dup2(outputListener.inputPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        dup2(outputListener.inputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

        // listening on the readabilityHandler
        outputListener.inputPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if self?.connected == true {
                if let self = self, !self.data.isEmpty {
                    self.port?.writeData(data: self.data)
                    self.data = Data()
                }
                self?.port?.writeData(data: data)
            } else {
                self?.data.append(data)
            }
            // Write input back to stdout/stderr
            self?.outputListener.outputPipe.fileHandleForWriting.write(data)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            // clean
            self.data = Data()
        }
    }
}

extension ConsoleRedirect: PortDelegate {
    public func port(didConnect port: Port) {
        self.connected = true
    }
    
    public func port(didDisconnect port: Port) {
        
    }
    
    public func port(port: Port, didReceiveData data: OOData) {
        
    }
}
