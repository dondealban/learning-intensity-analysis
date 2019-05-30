<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="2.18.2" minimumScale="inf" maximumScale="1e+08" hasScaleBasedVisibilityFlag="0">
  <pipe>
    <rasterrenderer opacity="1" alphaBand="0" classificationMax="4" classificationMinMaxOrigin="MinMaxFullExtentEstimated" band="1" classificationMin="0" type="singlebandpseudocolor">
      <rasterTransparency/>
      <rastershader>
        <colorrampshader colorRampType="INTERPOLATED" clip="0">
          <item alpha="255" value="0" label="No Data" color="#ffffff"/>
          <item alpha="255" value="1" label="Forest" color="#006400"/>
          <item alpha="255" value="2" label="Mosaic Vegetation" color="#8ca000"/>
          <item alpha="255" value="3" label="Shrubland" color="#784b00"/>
          <item alpha="255" value="4" label="Other Vegetation" color="#ffb432"/>
          <item alpha="255" value="5" label="Cropland" color="#ffff64"/>
          <item alpha="255" value="6" label="Non-Vegetation" color="#0046c8"/>
        </colorrampshader>
      </rastershader>
    </rasterrenderer>
    <brightnesscontrast brightness="0" contrast="0"/>
    <huesaturation colorizeGreen="128" colorizeOn="0" colorizeRed="255" colorizeBlue="128" grayscaleMode="0" saturation="0" colorizeStrength="100"/>
    <rasterresampler maxOversampling="2"/>
  </pipe>
  <blendMode>0</blendMode>
</qgis>
