/*
 Copyright 2021 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import Foundation
@testable import AEPServices

class MockFullscreenMessage: FullscreenMessage {
    var messageMonitor: MessageMonitoring
    var htmlPayload = ""

    private var messagingDelegate: MessagingDelegate? {
        return ServiceProvider.shared.messagingDelegate
    }

    override init(payload: String, listener: FullscreenMessageDelegate?, isLocalImageUsed: Bool, messageMonitor: MessageMonitoring) {
        self.messageMonitor = messageMonitor
        self.htmlPayload = payload
        super.init(payload: payload, listener: listener, isLocalImageUsed: isLocalImageUsed, messageMonitor: self.messageMonitor)
    }

    public override func show() {
        self.listener?.onShow(message: self)
        self.messagingDelegate?.onShow(message: self)
    }

    public override func dismiss() {
        self.listener?.onDismiss(message: self)
        self.messagingDelegate?.onDismiss(message: self)
    }
}
