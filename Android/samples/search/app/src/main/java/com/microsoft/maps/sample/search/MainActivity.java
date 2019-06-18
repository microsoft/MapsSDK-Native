package com.microsoft.maps.sample.search;

import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.content.res.ResourcesCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.AppCompatButton;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.Toast;

import com.microsoft.maps.AltitudeReferenceSystem;
import com.microsoft.maps.GeoboundingBox;
import com.microsoft.maps.Geolocation;
import com.microsoft.maps.MapAnimationKind;
import com.microsoft.maps.MapElementLayer;
import com.microsoft.maps.MapIcon;
import com.microsoft.maps.MapImage;
import com.microsoft.maps.MapRenderMode;
import com.microsoft.maps.MapScene;
import com.microsoft.maps.MapServices;
import com.microsoft.maps.MapTappedEventArgs;
import com.microsoft.maps.MapView;
import com.microsoft.maps.Optional;
import com.microsoft.maps.search.MapLocation;
import com.microsoft.maps.search.MapLocationFinder;
import com.microsoft.maps.search.MapLocationFinderResult;
import com.microsoft.maps.search.MapLocationFinderStatus;
import com.microsoft.maps.search.MapLocationOptions;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {

    private static final Geolocation LOCATION_LAKE_WASHINGTON =
            new Geolocation(47.609466, -122.265185);

    private MapView mMapView;
    private MapElementLayer mPinLayer;
    private MapImage mPinImage;
    private View mDemoMenu;
    private AppCompatButton mButtonPoiTap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mMapView = new MapView(this, MapRenderMode.VECTOR);
        mMapView.setCredentialsKey(BuildConfig.CREDENTIALS_KEY);
        ((FrameLayout)findViewById(R.id.map_view)).addView(mMapView);

        MapServices.setCredentialsKey(BuildConfig.CREDENTIALS_KEY);

        mPinLayer = new MapElementLayer();
        mMapView.getLayers().add(mPinLayer);
        mPinImage = getPinImage();

        setupDemoMenu();
    }

    private void setupDemoMenu() {
        mDemoMenu = findViewById(R.id.menu_demo);

        FloatingActionButton buttonDemo = findViewById(R.id.button_demo);
        buttonDemo.setCompatElevation(0);
        buttonDemo.setOnClickListener((View v) -> {
            boolean wasVisible = mDemoMenu.getVisibility() == View.VISIBLE;
            mDemoMenu.setVisibility(wasVisible ? View.GONE : View.VISIBLE);
        });

        mButtonPoiTap = findViewById(R.id.button_poi_tap);
        mButtonPoiTap.setTag(false);
        mButtonPoiTap.setOnClickListener((View v) -> {
            boolean wasActive = (boolean) v.getTag();
            v.setBackground(wasActive
                    ? ResourcesCompat.getDrawable(v.getResources(), R.drawable.button_default, null)
                    : ResourcesCompat.getDrawable(v.getResources(), R.drawable.button_active, null));
            v.setTag(!wasActive);
        });
        mMapView.addOnMapTappedListener((MapTappedEventArgs e) -> {
            if ((boolean) mButtonPoiTap.getTag()) {
                Optional<Geolocation> location = mMapView.getLocationFromOffset(e.position);
                if (location.isPresent()) {
                    MapLocationFinder.findLocationsAt(
                        location.get(),
                        null,
                        (MapLocationFinderResult result) -> {
                            MapLocationFinderStatus status = result.getStatus();

                            if (status == MapLocationFinderStatus.SUCCESS) {

                                MapLocation resultLocation = result.getLocations().get(0);
                                Geolocation pinLocation = new Geolocation(
                                    location.get().getLatitude(),
                                    location.get().getLongitude(),
                                    0);
                                String pinTitle = String.format(
                                    Locale.ROOT,
                                    "%s (%s)",
                                    resultLocation.getDisplayName(), resultLocation.getEntityType());

                                addPin(pinLocation, pinTitle);

                            } else if (status == MapLocationFinderStatus.EMPTY_RESPONSE) {
                                Toast.makeText(MainActivity.this, "Unable to reverse geocode this location", Toast.LENGTH_LONG).show();

                            } else {
                                Toast.makeText(MainActivity.this, "Error processing the request", Toast.LENGTH_LONG).show();
                            }
                        });
                }
            }
            return false;
        });

        findViewById(R.id.button_poi_search).setOnClickListener((View v) -> showGeocodeDialog());
        findViewById(R.id.button_poi_clear).setOnClickListener((View v) -> clearPins());
    }

    @Override
    protected void onStart() {
        super.onStart();
        mMapView.setScene(
                MapScene.createFromLocationAndZoomLevel(LOCATION_LAKE_WASHINGTON, 10),
                MapAnimationKind.NONE);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mMapView != null) {
            mMapView.resume();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (mMapView != null) {
            mMapView.suspend();
        }
    }

    private void addPin(Geolocation location, String title) {
        MapIcon pushpin = new MapIcon();
        pushpin.setLocation(location);
        pushpin.setTitle(title);
        pushpin.setImage(mPinImage);
        mPinLayer.getElements().add(pushpin);
    }

    private void clearPins() {
        mPinLayer.getElements().clear();
    }

    private void showGeocodeDialog() {
        View view = LayoutInflater.from(this).inflate(R.layout.dialog_geocode, null);
        EditText editQuery = view.findViewById(R.id.query);
        EditText editCulture = view.findViewById(R.id.culture);
        EditText editRegion = view.findViewById(R.id.region);
        CheckBox checkReferenceLocation = view.findViewById(R.id.check_reference_location);
        CheckBox checkReferenceBoundingBox = view.findViewById(R.id.check_reference_boundingbox);

        new AlertDialog.Builder(this)
                .setView(view)
                .setPositiveButton("Search", (DialogInterface dialog, int which) -> {
                    String query = editQuery.getText().toString();
                    if (query.isEmpty()) {
                        return;
                    }

                    Geolocation referenceLocation = null;
                    if (checkReferenceLocation.isChecked()) {
                        referenceLocation = mMapView.getCenter();
                    }
                    GeoboundingBox referenceBoundingBox = null;
                    if (checkReferenceBoundingBox.isChecked()) {
                        referenceBoundingBox = mMapView.getBounds();
                    }

                    MapLocationOptions options = new MapLocationOptions();
                    if (!editCulture.getText().toString().isEmpty()) {
                        options.setCulture(editCulture.getText().toString());
                    }
                    if (!editRegion.getText().toString().isEmpty()) {
                        options.setRegion(editRegion.getText().toString());
                    }

                    MapLocationFinder.findLocations(query, referenceLocation, referenceBoundingBox, options, (MapLocationFinderResult result) -> {
                        MapLocationFinderStatus status = result.getStatus();

                        if (status == MapLocationFinderStatus.SUCCESS) {
                            List<Geolocation> points = new ArrayList<>();

                            for (MapLocation mapLocation : result.getLocations()) {
                                Geolocation pinLocation = new Geolocation(
                                    mapLocation.getPoint().getLatitude(),
                                    mapLocation.getPoint().getLongitude(),
                                    0,
                                    AltitudeReferenceSystem.TERRAIN);
                                addPin(pinLocation, mapLocation.getDisplayName());
                                points.add(mapLocation.getPoint());
                            }
                            mMapView.setScene(MapScene.createFromLocations(points), MapAnimationKind.DEFAULT);

                        } else if (status == MapLocationFinderStatus.EMPTY_RESPONSE) {
                            Toast.makeText(MainActivity.this, "No results were found", Toast.LENGTH_LONG).show();

                        } else {
                            Toast.makeText(MainActivity.this, "Error processing the request, code " + status.toString(), Toast.LENGTH_LONG).show();
                        }
                    });
                })
                .setNegativeButton("Cancel", (DialogInterface dialog, int which) -> dialog.cancel())
                .show();
    }

    private MapImage getPinImage() {
        Drawable drawable = ResourcesCompat.getDrawable(getResources(), R.drawable.ic_pin, null);

        int width = drawable.getIntrinsicWidth();
        int height = drawable.getIntrinsicHeight();
        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);

        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);

        return new MapImage(bitmap);
    }
}
