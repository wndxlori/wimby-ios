#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SPClusterView.h"
#import "SPAnnotationsIndex.h"

@class SPCluster;

/** 
 * SuperPin. Use Interface Builder to change your MapView object from MKMapView to SPMapView and you're done.
 */
@interface SPMapView : MKMapView<MKMapViewDelegate> {
@private
    SPAnnotationsIndex *index;
    
    id<MKMapViewDelegate> trueDelegate;
    CGFloat clusteringCellSize;    
    double clusteringCellSizeInMapRect;

    NSUInteger clusteringThreshold;
    Class defaultClusterViewClass;
    BOOL clusteringEnabled;
    
    MKMapSize previousSize;
    
    NSArray *skipAnnotations;
    
    
    UIImageView* arrView;

}

/** Specifies the receiver’s delegate object. */
@property(nonatomic,assign) id<MKMapViewDelegate> delegate;

/** Provides access to SPMapView's internal SPAnnotationsIndex. */
@property(nonatomic,readonly) SPAnnotationsIndex *index;
/** Returns NSArray of all annotations currently displayed on the SPMapView. This includes user added annotations and SPCluster annotations. */
@property(nonatomic,readonly) NSArray *currentAnnotations;
/** NSArray of all annotations to be excluded from clustering. */
@property(nonatomic,retain) NSArray *skipAnnotations;
/** Size in pixel of a cell in SPMapView's clustering grid. Default: 80px */
@property(assign) CGFloat clusteringCellSize;
/** Maximum count of non-clustered annotations in a grid cell of the clustering grid. Default: 3 */
@property(assign) NSUInteger clusteringThreshold;
/** Class used to draw individual cluster annotations. Default: SPClusterView. See SPClusterView if you want to replace this with your own drawing code */
@property(assign) Class defaultClusterViewClass;
/** Enable clustering algorithm. If disabled SPMapView only provides a more efficient storage method for huge numbers of annotations and annotationsInMapRect: for iOS < 4.2. Default: YES */
@property(assign) BOOL clusteringEnabled;

/** Used internally to signal that previous clustering operation should be cancelled */
@property(assign) NSUInteger lastClusteringOpId;

/** 
 * Returns the annotation objects located in the specified map rectangle.
 *
 * Apple added this method to MKMapView in iOS 4.2.
 * SuperPin supports this method fully on iOS < 4.2.
 * 
 * @param mapRect: The portion of the map that you want to search for annotations.
 * @returns The set of annotation objects located in mapRect.
 */
- (NSSet *)annotationsInMapRect:(MKMapRect)mapRect;

/**
 * Forces SuperPin to recluster. This will result in a noticeable flash.
 */
- (void)recluster;

@end
