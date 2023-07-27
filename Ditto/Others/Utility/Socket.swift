//
//  Socket.swift
//  iOSClient_BonjourWifi
//
//  Created by Shefrin Hakeem on 02/07/20.
//  Copyright © 2020 Shefrin Hakeem. All rights reserved.
//

import UIKit

enum SocketState: Int {
    case initial = 0
    case connect = 1
    case disconnect = 2
    case errorOccurred = 3
}

class Socket: NSObject {
    var inputStream: InputStream?
    var outputStream: OutputStream?
    var runloop: RunLoop?
    var status: Int = -1
    var timeout: Float = 5.0
    weak var mStreamDelegate: StreamDelegate?
    func initSockerCommunication( _ host: CFString, port: UInt32 ) {
        DispatchQueue.global().async {
            var readstream: Unmanaged<CFReadStream>?
            var writestream: Unmanaged<CFWriteStream>?
            CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host, port, &readstream, &writestream)
            self.inputStream = readstream!.takeRetainedValue()
            self.outputStream = writestream!.takeRetainedValue()
            self.inputStream?.delegate = self
            self.outputStream?.delegate = self
            self.inputStream?.schedule(in: .current, forMode: RunLoop.Mode.default)
            self.outputStream?.schedule(in: .current, forMode: RunLoop.Mode.default)
            self.inputStream?.open()
            self.outputStream?.open()
        }
    }
    func setStreamDelegate(_ delegete: StreamDelegate) {
        mStreamDelegate = delegete
    }
    func getInputStream() -> InputStream {
        return self.inputStream!
    }
    func getOutputStream() -> OutputStream {
        return self.outputStream!
    }
    func closeSocket() {
        inputStream?.close()
        outputStream?.close()
        inputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
        outputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
        inputStream?.delegate = nil
        outputStream?.delegate = nil
        inputStream = nil
        outputStream = nil
    }
}
extension Socket: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            self.status = SocketState.connect.rawValue
        case Stream.Event.hasBytesAvailable:
            break
        case Stream.Event.errorOccurred:
            break
        case Stream.Event.endEncountered:
            self.status = SocketState.errorOccurred.rawValue
        default:
            break
        }
        mStreamDelegate?.stream?(aStream, handle: eventCode)
    }
}
