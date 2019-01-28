import Foundation

extension NSObject {
    func initLog() {
        #if DEBUG
        logger.info("🏵🏵🏵 INIT \(self) 🏵🏵🏵")
        #endif
    }

    func deinitLog() {
        #if DEBUG
        logger.info("🎃🎃🎃 DEINIT \(self) 🎃🎃🎃")
        #endif
    }
}
