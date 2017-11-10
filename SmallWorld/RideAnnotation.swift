//
//  Created by Brian Coyner on 11/9/17.
//  Copyright © 2017 Brian Coyner. All rights reserved.
//

import Foundation
import MapKit

final class RideAnnotation: MKPointAnnotation {
}

extension RideAnnotation {

    override var debugDescription: String {
        return title ?? super.debugDescription
    }
}
