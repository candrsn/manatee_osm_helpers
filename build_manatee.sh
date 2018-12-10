
import_layers() {
    EXPORT OGR_SQLITE_SYNCHRONOUS=off
    FLG="-dsco SPATIALITE=yes"
    for nm in address_rest buildings_rest parcels_rest; do
        ogr2ogr -f sqlite manatee.sqlite -nln $nm ${nm}.geojson -gt 50000 $FLG
	FLG="-append"
    done
}



