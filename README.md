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
This project is licensed under the terms of the Creative Commons BY-SA license.