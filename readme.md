# iOS 11 Map View Clustering Bugs

## Selected annotation should remain visible (should never be clustered)

Steps to reproduce
- launch the sample app
  - all annotations have the same `clusteringIdentifier`
  - all annotations have the same `displayPriority`
- tap on the "Under the Sea"  annotation
  - expected and actual results
    - user sees the annotation view become selected
    - logs show that the annotation is selected
- zoom out just enough for the "Under The Sea" annotation to collide with the "Seven Dwarfs Mine Train" annotation
  - here's what I assume should happen, but does not happen
    - the "Under the Sea" annotation remains visible (and selected).
    - the "Seven Dwarfs Mine Train" annotation hides.
  
From the user's perspective, a selected annotation should always be visible regardless of the clustering identifier and display priority.

## Selecting an annotation that is currently within a cluster should be become visible

Steps to reproduce
- launch the sample app
  - all annotations have the same `clusteringIdentifier`
  - all annotations have the same `displayPriority`
- ensure no annotations are currently selected
- zoom out just enough for the "It's a Small World", "Under the Sea", and "Seven Dwarfs Mine Train" annotations cluster together.
  - expected results and actual results
    - a cluster annotation appears showing "3"
      - cluster contains the "It's a Small World", "Under the Sea", and "Seven Dwarfs Mine Train" annotations
- tap the "Select" toolbar button to select the "It's a Small World" annotation
- here's what I assume should happen, but does not happen
  - the "It's A Small World" annotation view becomes and and is selected
  - the "Under The Sea" and "Seven Dwarfs Mine Train" annotation views may or may not be visible based on MapKit clustering/ zoom level logic.
  
  From the user's perspective, selecting an annotation that is currently part of a cluster should become visible regardless of the clustering identifier and display priority.
  It's possible, for example, for a user to select an annotation from a table view (or as in this hack example, a toolbar button).
  
  Here's a real scenario (similar to the Maps app)
  - tap a cluster annotation containing the "It's a Small World", "Under the Sea", and "Seven Dwarfs Mine Train" annotations
  - app displays a table view showing additional details about the rides
  - user taps a table view row to select the "Under the Sea" annotation
  - the selected "Under the Sea" annotation is automatically removed from the cluster
  
  
## Other Notes
  
I have tried various ways to work around the issues. My workarounds either just don't work, or cause MapKit to crash.
  
Things I tried that I thought might work, but did not work:
- setting the selected annotation view `clusteringIdentifier` to `nil`.
  - this usually ends up crashing MapKit.
- setting the selected annotation's `displayPriority` to `.required` (while all other annotations had a lower priority).
  
# In Summary
  
From the user's perspective, the selected annotation is the most important annotation.
Therefore, MapKit should automatically ensure that the selected annotation is always visible
regardless of the `clusteringIdentifier`, `displayPriority`, etc.
  
Also, it would help if the MapKit API was documented with details on how the API should be used.
For example, tell us when it is safe to set the `clusteringIdentifier` and `displayPriority`.
Give us examples of when and why we would want to create a `MKClusterAnnotation` subclass and
implement the `mapView(_:, clusterAnnotationForMemberAnnotations :) -> MKClusterAnnotation`.
