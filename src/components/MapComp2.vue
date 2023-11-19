<template>
  <div>
    <button @click="getLocation">Get Location</button>
    {{ lat }}, {{ lng }}
    <div ref="mapContainer" style="width: 800px; height: 600px"></div>
  </div>
</template>
  
<script setup>
import { onMounted, ref } from 'vue'
// import 'leaflet/dist/leaflet.css'
// import 'leaflet-draw/dist/leaflet.draw.css'
// import L from 'leaflet'
// import 'leaflet-draw/dist/leaflet.draw-src'

const lat = ref(0)
const lng = ref(0)
const map = ref()
const mapContainer = ref()

var geojsonLayer

function loadTiledGeoJSON() {
  var bounds = map.value.getBounds()
  var filePath = './src/vector-tiles/test3.geojson'

  fetch(filePath)
    .then((response) => response.json())
    .then((data) => {
      // Create GeoJSON-VT tiles
      var tileIndex = geojsonvt(data, {
        extent: 4096, // Default extent, use the same value as your vector tiles
        debug: 1 // Enable debugging (optional)
      })

      // Convert map bounds to GeoJSON tile coordinates
      var tileCoords = {
        minX: bounds.getWest(),
        minY: bounds.getSouth(),
        maxX: bounds.getEast(),
        maxY: bounds.getNorth()
      }
      console.log('tile coords ' + tileCoords)

      var tiles = tileIndex.getTile(
        Math.floor(map.value.getZoom()),
        Math.floor(tileCoords.minX),
        Math.floor(tileCoords.minY)
      )
      console.log('tiles ' + tiles)

      var geojson = tiles
        ? geojsonvt.hiResToGeoJSON(tiles, tileCoords)
        : { type: 'FeatureCollection', features: [] }
      console.log('geojson ' + geojson)
      // Remove the existing GeoJSON layer if it exists
      if (geojsonLayer) {
        map.value.removeLayer(geojsonLayer)
      }

      // Create a new GeoJSON layer and add it to the map
      geojsonLayer = L.geoJSON(geojson).addTo(map.value)
    })
    .catch((error) => console.error('Error loading GeoJSON:', error))
}

function loadLocalGeoJSON() {
  var bounds = map.value.getBounds()

  // Your logic to determine the path to the local GeoJSON file based on bounds
  // For simplicity, let's assume the GeoJSON file is in the same directory
  var filePath = './src/vector-tiles/test3.geojson'

  // Use AJAX or Fetch to load GeoJSON data from the local file
  fetch(filePath)
    .then((response) => response.json())
    .then((data) => {
      if (geojsonLayer) {
        map.value.removeLayer(geojsonLayer)
      }

      geojsonLayer = L.geoJSON(data).addTo(map.value)
    })
    .catch((error) => console.error('Error loading GeoJSON:', error))
}

onMounted(() => {
  map.value = L.map(mapContainer.value).setView([lat.value, lng.value], 3)
  L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  }).addTo(map.value)

  var drawControl = new L.Control.Draw()
  map.value.addControl(drawControl)

  var drawFeatures = new L.FeatureGroup()
  map.value.addLayer(drawFeatures)

  map.value.on('draw:created', (e) => {
    var layer = e.layer

    console.log(e)
    drawFeatures.addLayer(layer)
  })

  const geoJsonUrl = './src/vector-tiles/test3.geojson'

  // var layer = omnivore.geojson(geoJsonUrl).addTo(map.value)

  map.value.on('moveend', function () {
    loadTiledGeoJSON()
  })
})

function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition((position) => {
      lat.value = position.coords.latitude
      lng.value = position.coords.longitude
      map.value.setView([lat.value, lng.value], 13)
    })
  }
}
</script>


  
  
  <style lang="scss" scoped>
</style>
  