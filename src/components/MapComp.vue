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

onMounted(() => {
  map.value = L.map(mapContainer.value).setView([lat.value, lng.value], 13)
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

  //   const geoJsonUrl = './src/vector-tiles/test.geojson'
  //   fetch(geoJsonUrl)
  //     .then(function (response) {
  //       return response.json()
  //     })
  //     .then(function (geojsonData) {
  //       // Create a GeoJSON layer and add it to the map
  //       L.geoJSON(geojsonData).addTo(map.value)
  //     })
  //     .catch(function (error) {
  //       console.error(error)
  //     })

  const geoJsonUrl = './src/vector-tiles/test3.geojson'

  var layer = omnivore.geojson(geoJsonUrl).addTo(map.value)
  //   fetch(geoJsonUrl)
  //     .then(function (response) {
  //       return response.json()
  //     })
  //     .then(function (geojsonData) {
  //       // Create a GeoJSON layer and add it to the map
  //       var vtLayer = L.geoJson.vt(geojsonData, options).addTo(map.value)
  //       console.log(vtLayer)
  //       console.log('creating layer')
  //     })
  //     .catch(function (error) {
  //       console.error(error)
  //     })
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
  