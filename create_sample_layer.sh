#!/bin/bash

nunOfRows=$1

head -n $1 src/vector-tiles/07d_buildings_GeoJson.geojson > src/vector-tiles/test3.geojson; 
sed -i '$ s/.$//' src/vector-tiles/test3.geojson; 
echo "]}" >> src/vector-tiles/test3.geojson 
