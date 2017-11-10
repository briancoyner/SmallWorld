//
//  Created by Brian Coyner on 11/9/17.
//  Copyright © 2017 Brian Coyner. All rights reserved.
//

import Foundation
import MapKit

final class RideAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        didSet {
            guard let _ = annotation as? RideAnnotation else {
                return
            }

            if isSelected {
                clusteringIdentifier = nil
            } else {
                clusteringIdentifier = "RideAnnotation"
                displayPriority = .defaultHigh
            }
        }
    }
}

extension RideAnnotationView {

    override var debugDescription: String {
        return "RideAnnotationView: \(String(describing: annotation))"
    }
}
