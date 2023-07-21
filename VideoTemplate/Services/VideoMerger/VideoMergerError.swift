
import Foundation

enum VideoMergerError: Error {
	case failedCompositionsCreation
	case failedTracksCreation
	case failedExportSessionCreation
	case exportFailed(error: Error?)
	case exportCancelled
	case unknown
}
