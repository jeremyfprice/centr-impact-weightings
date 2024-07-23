# Determining the Weightings for the CEnTR-IMPACT Metrics

Each descriptor is assigned a "value weighting" based on how community engaged scholars rank the descriptor within the possible descriptors of that component. The possible weighting values are on a logarithmic scale between 0.78 and 1.00.

Community engaged scholars were asked to complete a Qualtrics survey where they rank ordered each descriptor within its component. With this data, a Smith's Salience Score (S) was calculated for each descriptor of each component.

The weightings were assigned based on the following code:

```r
    weighting = case_when(salience == 1.00 ~ 1.00,
        salience == 0.80 | salience == 0.75 ~ 0.95,
        salience == 0.60 | salience == 0.50 ~ 0.90,
        salience == 0.40 | salience == 0.25 ~ 0.84,
        salience == 0.20 ~ 0.78))
```
[![DOI](https://zenodo.org/badge/DOI/10.17605/OSF.IO/TEG78.svg)](https://doi.org/10.17605/OSF.IO/TEG78)
[![Hippocratic License HL3-MEDIA-SOC-USTA](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-MEDIA-SOC-USTA&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/media-soc-usta.html)
