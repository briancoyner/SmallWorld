//
//  Created by Brian Coyner on 11/9/17.
//  Copyright © 2017 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit
import MapKit

/// See the `readme` file for different testing scenarios.

final class MapViewController: UIViewController, MKMapViewDelegate {

    private lazy var annotations = lazyMagicKingdomAnnotations()
    private lazy var mapView = lazyMapView()
}

extension MapViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Map View Clustering Bugs"
        showToolbarWithDemoButtons()

        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // The annotations have the same:
        // - clustering identifier
        // - priority (`.defaultHigh`).
        //
        // Changing the priority did not appear to affect any of the bugs related to this sample code.
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: false)
    }
}

// MARK: MKMapViewDelegate (Annotation View)

extension MapViewController {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is MKUserLocation:
            return nil
        case let clusterAnnotation as MKClusterAnnotation:
            // Creating new or "dequeuing" does not appear to have any impact on the clustering issues being discussed by this sample code.
            return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: clusterAnnotation)
        case let rideAnnotation as RideAnnotation:
            // Creating new or "dequeuing" does not appear to have any impact on the clustering issues being discussed by this sample code.
            return RideAnnotationView(annotation: rideAnnotation, reuseIdentifier: nil)
        default:
            return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
        }
    }
}

// MARK: MKMapViewDelegate (Selection)

extension MapViewController {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("\n__Did Select__")
        print("    Selected: \(mapView.selectedAnnotations)")
        print("  Cluster ID: \(view.clusteringIdentifier ?? "")")
        print("    Priority: \(view.displayPriority)")
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("\n__Did Deselect__")
        print("  Deselected: \(view.annotation?.debugDescription ?? "Hmm... No annotation?")")
        print("    Selected: \(mapView.selectedAnnotations)")
        print("  Cluster ID: \(view.clusteringIdentifier ?? "")")
        print("    Priority: \(view.displayPriority)")
    }
}

// MARK: MKMapViewDelegate (Cluster Annotation)

extension MapViewController {

    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        print("\n__Clustering__")
        print("   Clustered: \(memberAnnotations)")
        print("    Selected: \(mapView.selectedAnnotations)")

        //applyHackToForceSelectedAnnotationToAppearSelected(whenNotIncludedIn: memberAnnotations)

        return MKClusterAnnotation(memberAnnotations: memberAnnotations)
    }
}

extension MapViewController {

    private func applyHackToForceSelectedAnnotationToAppearSelected(whenNotIncludedIn memberAnnotations: [MKAnnotation]) {

        //
        // What is this hack?
        // - MapKit wants to cluster the given `memberAnnotations`.
        // - This hack looks to see if the selected annotation is part of the current cluster.
        // - If the selected annotation is not part of the cluster, then force re-select the annotation.
        //
        // This hack should not be necessary because MapKit, in my opinion, should always ensure that a selected annotation is always visible
        // regardless of the clustering identifier, display priority, etc.
        //

        if let selectedAnnotation = mapView.selectedAnnotations.first {
            if let selectedAnnotationVew = mapView.view(for: selectedAnnotation) {
                print("    Cluster ID: \(selectedAnnotationVew.clusteringIdentifier ?? "uhhh... why is this clustered?")")
                print("      Priority: \(selectedAnnotationVew.displayPriority)")
            }

            if memberAnnotations.contains(where: { $0 === selectedAnnotation }) == false {
                mapView.deselectAnnotation(selectedAnnotation, animated: false)
                mapView.selectAnnotation(selectedAnnotation, animated: false)
            }
        }
    }
}

extension MapViewController {

    @objc
    private func selectAnnotation() {
        // In our test set, the first annotation is "It's A Small World".
        // So any testing you do with the "Select" toolbar button is always
        // focused on this one annotation.
        let annotation = annotations[0]
        mapView.selectAnnotation(annotation, animated: true)
    }

    @objc
    private func deselectAnnotation() {
        guard let annotation = mapView.selectedAnnotations.first else {
            return
        }

        mapView.deselectAnnotation(annotation, animated: true)
    }
}

extension MapViewController {

    private func showToolbarWithDemoButtons() {
        setToolbarItems([
            UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectAnnotation)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Deselect", style: .plain, target: self, action: #selector(deselectAnnotation))
        ], animated: false)

        navigationController?.setToolbarHidden(false, animated: false)
    }
}

extension MapViewController {

    private func lazyMapView() -> MKMapView {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.mapType = .satellite
        view.showsUserLocation = true
        view.showsTraffic = false
        view.showsBuildings = true

        view.delegate = self

        return view
    }
}

extension MapViewController {

    private func lazyMagicKingdomAnnotations() -> [MKAnnotation] {
        return [
            makeAnnotation(
                withTitle: "It's a Small World",
                coordinate: CLLocationCoordinate2D(latitude: 28.420827, longitude: -81.581957)
            ),
            makeAnnotation(
                withTitle: "Splash Mountain",
                coordinate: CLLocationCoordinate2D(latitude: 28.419215, longitude: -81.585046)
            ),
            makeAnnotation(
                withTitle: "Seven Dwarfs Mine Train",
                coordinate: CLLocationCoordinate2D(latitude: 28.4205, longitude: -81.5801)
            ),
            makeAnnotation(
                withTitle: "Under the Sea",
                coordinate: CLLocationCoordinate2D(latitude: 28.421199, longitude: -81.579966)
            ),
            makeAnnotation(
                withTitle: "Space Mountain",
                coordinate: CLLocationCoordinate2D(latitude: 28.4191, longitude: -81.5771)
            ),
            makeAnnotation(
                withTitle: "Pirates of the Carribean",
                coordinate: CLLocationCoordinate2D(latitude: 28.4181, longitude: -81.5846)
            )
        ]
    }

    private func makeAnnotation(withTitle title: String, coordinate: CLLocationCoordinate2D) -> RideAnnotation {
        let annotation = RideAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title

        return annotation
    }
}
