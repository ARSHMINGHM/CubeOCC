---
project: CubeOCC
type: dataset
status: active
last_reviewed: 2026-08-31
parent: 15_TASK_BACKLOG
---

# Monitor-Capture Dataset Labeling

Parent task tree:

- [[15_TASK_BACKLOG]]

Related technical note:

- [[08_SIMULATION_CAMERA_MODEL]]

Related dataset tool:

- [[15_02_ROI_WARP_AND_DEGRADATION_TOOL]]

## Purpose

When we capture CubeOCC sender frames from a monitor using a camera, each image set needs enough metadata to compare receiver behavior later.

This note is the dataset-labeling checklist for those monitor-capture image sets.

## Dataset Label Box

Use this approximate box for each captured image set:

```text
dataset_id:
source_folder:
capture_date:

distance:
viewing_angle:
room_brightness:
screen_brightness:
blur:
glare_or_reflection:
exposure:

grid_size:
camera_fps:
optical_frame_rate:

notes:
```

## ROI Warp And Degraded Variants

After capture, prepare the images for receiver testing and later ML/SVM work using:

- [[15_02_ROI_WARP_AND_DEGRADATION_TOOL]]

Short flow:

```text
raw monitor-capture image
-> four corner points, given manually or auto-detected from bright markers
-> perspective warp to regular ROI image
-> downsample/upscale variants
-> Gaussian blur variants
-> labeled prepared dataset folder
```

Recommended run:

```powershell
python dataset\prepare_monitor_capture.py --input-dir captures\MLCAP_001_Baseline_30fps --auto-corners --corner-method quadrants --out dataset_prepared\MLCAP_001_Baseline_30fps
```

The detailed commands, corner JSON fallback, degradation settings, and stress-test result are documented in [[15_02_ROI_WARP_AND_DEGRADATION_TOOL]].

## GitHub Issue Links

| Dataset label task | GitHub issue |
| --- | --- |
| Label each monitor-capture image set with distance. | [#31](https://github.com/ARSHMINGHM/CubeOCC/issues/31) |
| Label each monitor-capture image set with viewing angle. | [#32](https://github.com/ARSHMINGHM/CubeOCC/issues/32) |
| Label each monitor-capture image set with brightness and screen brightness. | [#33](https://github.com/ARSHMINGHM/CubeOCC/issues/33) |
| Label each monitor-capture image set with blur, glare/reflection, and exposure. | [#34](https://github.com/ARSHMINGHM/CubeOCC/issues/34) |
| Label each monitor-capture image set with grid size, camera FPS, and optical frame rate. | [#35](https://github.com/ARSHMINGHM/CubeOCC/issues/35) |

## ML Capture Task Table

Use this as the first 100-row V1 monitor-capture set for later ML/SVM-style analysis. Keep one folder per row when possible, using the Dataset ID as the folder name.

| Done | Dataset ID                       | Distance | Viewing angle | Room brightness   | Screen brightness | Blur           | Glare/reflection  | Exposure      | Grid size | Camera FPS | Optical frame rate | Notes             |
| ---- | -------------------------------- | -------: | ------------: | ----------------- | ----------------: | -------------- | ----------------- | ------------- | --------- | ---------: | -----------------: | ----------------- |
| [ ]  | MLCAP_001_Baseline_30fps         |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | baseline          |
| [ ]  | MLCAP_002_Near_30fps             |    30 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | distance          |
| [ ]  | MLCAP_003_MidNear_30fps          |    45 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | distance          |
| [ ]  | MLCAP_004_MidFar_30fps           |    80 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | distance          |
| [ ]  | MLCAP_005_Far_30fps              |   100 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | distance          |
| [ ]  | MLCAP_006_AngleNeg30_30fps       |    60 cm |       -30 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | angle             |
| [ ]  | MLCAP_007_AngleNeg15_30fps       |    60 cm |       -15 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | angle             |
| [ ]  | MLCAP_008_Angle15_30fps          |    60 cm |        15 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | angle             |
| [ ]  | MLCAP_009_Angle30_30fps          |    60 cm |        30 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | angle             |
| [ ]  | MLCAP_010_DarkRoom_30fps         |    60 cm |         0 deg | dark              |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | brightness        |
| [ ]  | MLCAP_011_DimRoom_30fps          |    60 cm |         0 deg | dim room light    |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | brightness        |
| [ ]  | MLCAP_012_BrightRoom_30fps       |    60 cm |         0 deg | bright room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | brightness        |
| [ ]  | MLCAP_013_Screen40_30fps         |    60 cm |         0 deg | normal room light |               40% | none           | none              | auto          | 8x8       |         30 |                 30 | screen brightness |
| [ ]  | MLCAP_014_Screen55_30fps         |    60 cm |         0 deg | normal room light |               55% | none           | none              | auto          | 8x8       |         30 |                 30 | screen brightness |
| [ ]  | MLCAP_015_Screen85_30fps         |    60 cm |         0 deg | normal room light |               85% | none           | none              | auto          | 8x8       |         30 |                 30 | screen brightness |
| [ ]  | MLCAP_016_Screen100_30fps        |    60 cm |         0 deg | normal room light |              100% | none           | none              | auto          | 8x8       |         30 |                 30 | screen brightness |
| [ ]  | MLCAP_017_SlightDefocus_30fps    |    60 cm |         0 deg | normal room light |               70% | slight defocus | none              | auto          | 8x8       |         30 |                 30 | blur              |
| [ ]  | MLCAP_018_MediumDefocus_30fps    |    60 cm |         0 deg | normal room light |               70% | medium defocus | none              | auto          | 8x8       |         30 |                 30 | blur              |
| [ ]  | MLCAP_019_MildReflection_30fps   |    60 cm |         0 deg | normal room light |               70% | none           | mild reflection   | auto          | 8x8       |         30 |                 30 | glare             |
| [ ]  | MLCAP_020_StrongReflection_30fps |    60 cm |         0 deg | normal room light |               70% | none           | strong reflection | auto          | 8x8       |         30 |                 30 | glare             |
| [ ]  | MLCAP_021_LockedExposureBase     |    60 cm |         0 deg | normal room light |               70% | none           | none              | locked/manual | 8x8       |         30 |                 30 | exposure          |
| [ ]  | MLCAP_022_Near_Angle15           |    30 cm |        15 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | distance-angle    |
| [ ]  | MLCAP_023_Near_Angle30           |    30 cm |        30 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | distance-angle    |
| [ ]  | MLCAP_024_Far_Angle15            |   100 cm |        15 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | distance-angle    |
| [ ]  | MLCAP_025_Far_Angle30            |   100 cm |        30 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | distance-angle    |
| [ ]  | MLCAP_026_Dark_Screen100         |    60 cm |         0 deg | dark              |              100% | none           | none              | auto          | 8x8       |         30 |                 30 | brightness-screen |
| [ ]  | MLCAP_027_Dark_Screen40          |    60 cm |         0 deg | dark              |               40% | none           | none              | auto          | 8x8       |         30 |                 30 | brightness-screen |
| [ ]  | MLCAP_028_Bright_Screen100       |    60 cm |         0 deg | bright room light |              100% | none           | none              | auto          | 8x8       |         30 |                 30 | brightness-screen |
| [ ]  | MLCAP_029_Bright_Screen40        |    60 cm |         0 deg | bright room light |               40% | none           | none              | auto          | 8x8       |         30 |                 30 | brightness-screen |
| [ ]  | MLCAP_030_Dim_Angle15            |    60 cm |        15 deg | dim room light    |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | lighting-angle    |
| [ ]  | MLCAP_031_Dim_Angle30            |    60 cm |        30 deg | dim room light    |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | lighting-angle    |
| [ ]  | MLCAP_032_Bright_Angle15         |    60 cm |        15 deg | bright room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | lighting-angle    |
| [ ]  | MLCAP_033_Bright_Angle30         |    60 cm |        30 deg | bright room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | lighting-angle    |
| [ ]  | MLCAP_034_Near_SlightDefocus     |    30 cm |         0 deg | normal room light |               70% | slight defocus | none              | auto          | 8x8       |         30 |                 30 | blur-distance     |
| [ ]  | MLCAP_035_Far_SlightDefocus      |   100 cm |         0 deg | normal room light |               70% | slight defocus | none              | auto          | 8x8       |         30 |                 30 | blur-distance     |
| [ ]  | MLCAP_036_Angle15_SlightDefocus  |    60 cm |        15 deg | normal room light |               70% | slight defocus | none              | auto          | 8x8       |         30 |                 30 | blur-angle        |
| [ ]  | MLCAP_037_Angle30_SlightDefocus  |    60 cm |        30 deg | normal room light |               70% | slight defocus | none              | auto          | 8x8       |         30 |                 30 | blur-angle        |
| [ ]  | MLCAP_038_Dark_SlightDefocus     |    60 cm |         0 deg | dark              |               70% | slight defocus | none              | auto          | 8x8       |         30 |                 30 | blur-light        |
| [ ]  | MLCAP_039_Bright_SlightDefocus   |    60 cm |         0 deg | bright room light |               70% | slight defocus | none              | auto          | 8x8       |         30 |                 30 | blur-light        |
| [ ]  | MLCAP_040_Angle15_MildReflection |    60 cm |        15 deg | normal room light |               70% | none           | mild reflection   | auto          | 8x8       |         30 |                 30 | glare-angle       |
| [ ]  | MLCAP_041_Angle30_MildReflection |    60 cm |        30 deg | normal room light |               70% | none           | mild reflection   | auto          | 8x8       |         30 |                 30 | glare-angle       |
| [ ]  | MLCAP_042_Dark_MildReflection    |    60 cm |         0 deg | dark              |               70% | none           | mild reflection   | auto          | 8x8       |         30 |                 30 | glare-light       |
| [ ]  | MLCAP_043_Bright_MildReflection  |    60 cm |         0 deg | bright room light |               70% | none           | mild reflection   | auto          | 8x8       |         30 |                 30 | glare-light       |
| [ ]  | MLCAP_044_Near_MildReflection    |    30 cm |         0 deg | normal room light |               70% | none           | mild reflection   | auto          | 8x8       |         30 |                 30 | glare-distance    |
| [ ]  | MLCAP_045_Far_MildReflection     |   100 cm |         0 deg | normal room light |               70% | none           | mild reflection   | auto          | 8x8       |         30 |                 30 | glare-distance    |
| [ ]  | MLCAP_046_Cam60_Opt30            |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         60 |                 30 | camera fps        |
| [ ]  | MLCAP_047_Cam60_Opt60            |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         60 |                 60 | optical fps       |
| [ ]  | MLCAP_048_Cam30_Opt60            |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 60 | stress fps        |
| [ ]  | MLCAP_049_Cam60_Angle15_Opt60    |    60 cm |        15 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         60 |                 60 | fps-angle         |
| [ ]  | MLCAP_050_Cam60_Angle30_Opt60    |    60 cm |        30 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         60 |                 60 | fps-angle         |
| [ ]  | MLCAP_051_Cam60_Dark_Opt60       |    60 cm |         0 deg | dark              |               70% | none           | none              | auto          | 8x8       |         60 |                 60 | fps-light         |
| [ ]  | MLCAP_052_Cam60_Bright_Opt60     |    60 cm |         0 deg | bright room light |               70% | none           | none              | auto          | 8x8       |         60 |                 60 | fps-light         |
| [ ]  | MLCAP_053_Cam60_Screen40_Opt60   |    60 cm |         0 deg | normal room light |               40% | none           | none              | auto          | 8x8       |         60 |                 60 | fps-screen        |
| [ ]  | MLCAP_054_Cam60_Screen100_Opt60  |    60 cm |         0 deg | normal room light |              100% | none           | none              | auto          | 8x8       |         60 |                 60 | fps-screen        |
| [ ]  | MLCAP_055_Cam60_Defocus_Opt60    |    60 cm |         0 deg | normal room light |               70% | slight defocus | none              | auto          | 8x8       |         60 |                 60 | fps-blur          |
| [ ]  | MLCAP_056_Cam60_Reflection_Opt60 |    60 cm |         0 deg | normal room light |               70% | none           | mild reflection   | auto          | 8x8       |         60 |                 60 | fps-glare         |
| [ ]  | MLCAP_057_Locked_Near            |    30 cm |         0 deg | normal room light |               70% | none           | none              | locked/manual | 8x8       |         30 |                 30 | exposure-distance |
| [ ]  | MLCAP_058_Locked_Far             |   100 cm |         0 deg | normal room light |               70% | none           | none              | locked/manual | 8x8       |         30 |                 30 | exposure-distance |
| [ ]  | MLCAP_059_Locked_Dark            |    60 cm |         0 deg | dark              |               70% | none           | none              | locked/manual | 8x8       |         30 |                 30 | exposure-light    |
| [ ]  | MLCAP_060_Locked_Bright          |    60 cm |         0 deg | bright room light |               70% | none           | none              | locked/manual | 8x8       |         30 |                 30 | exposure-light    |
| [ ]  | MLCAP_061_Locked_Angle15         |    60 cm |        15 deg | normal room light |               70% | none           | none              | locked/manual | 8x8       |         30 |                 30 | exposure-angle    |
| [ ]  | MLCAP_062_Locked_Angle30         |    60 cm |        30 deg | normal room light |               70% | none           | none              | locked/manual | 8x8       |         30 |                 30 | exposure-angle    |
| [ ]  | MLCAP_063_LongText_Baseline      |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | longer payload    |
| [ ]  | MLCAP_064_LongText_Far           |   100 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | longer payload    |
| [ ]  | MLCAP_065_LongText_Angle30       |    60 cm |        30 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | longer payload    |
| [ ]  | MLCAP_066_LongText_Dark          |    60 cm |         0 deg | dark              |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | longer payload    |
| [ ]  | MLCAP_067_LongText_Bright        |    60 cm |         0 deg | bright room light |               70% | none           | none              | auto          | 8x8       |         30 |                 30 | longer payload    |
| [ ]  | MLCAP_068_LongText_Defocus       |    60 cm |         0 deg | normal room light |               70% | slight defocus | none              | auto          | 8x8       |         30 |                 30 | longer payload    |
| [ ]  | MLCAP_069_LongText_Reflection    |    60 cm |         0 deg | normal room light |               70% | none           | mild reflection   | auto          | 8x8       |         30 |                 30 | longer payload    |
| [ ]  | MLCAP_070_LongText_Opt60         |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 8x8       |         60 |                 60 | longer payload    |
| [ ]  | MLCAP_071_Grid16_Baseline        |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 16x16     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_072_Grid16_Near            |    30 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 16x16     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_073_Grid16_Far             |   100 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 16x16     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_074_Grid16_Angle15         |    60 cm |        15 deg | normal room light |               70% | none           | none              | auto          | 16x16     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_075_Grid16_Angle30         |    60 cm |        30 deg | normal room light |               70% | none           | none              | auto          | 16x16     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_076_Grid16_Dark            |    60 cm |         0 deg | dark              |               70% | none           | none              | auto          | 16x16     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_077_Grid16_Bright          |    60 cm |         0 deg | bright room light |               70% | none           | none              | auto          | 16x16     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_078_Grid16_Screen40        |    60 cm |         0 deg | normal room light |               40% | none           | none              | auto          | 16x16     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_079_Grid16_Screen100       |    60 cm |         0 deg | normal room light |              100% | none           | none              | auto          | 16x16     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_080_Grid16_Opt60           |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 16x16     |         60 |                 60 | grid comparison   |
| [ ]  | MLCAP_081_Grid32_Baseline        |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 32x32     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_082_Grid32_Near            |    30 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 32x32     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_083_Grid32_Far             |   100 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 32x32     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_084_Grid32_Angle15         |    60 cm |        15 deg | normal room light |               70% | none           | none              | auto          | 32x32     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_085_Grid32_Angle30         |    60 cm |        30 deg | normal room light |               70% | none           | none              | auto          | 32x32     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_086_Grid32_Dark            |    60 cm |         0 deg | dark              |               70% | none           | none              | auto          | 32x32     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_087_Grid32_Bright          |    60 cm |         0 deg | bright room light |               70% | none           | none              | auto          | 32x32     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_088_Grid32_Screen40        |    60 cm |         0 deg | normal room light |               40% | none           | none              | auto          | 32x32     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_089_Grid32_Screen100       |    60 cm |         0 deg | normal room light |              100% | none           | none              | auto          | 32x32     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_090_Grid32_Opt60           |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 32x32     |         60 |                 60 | grid comparison   |
| [ ]  | MLCAP_091_Grid64_Baseline        |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 64x64     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_092_Grid64_Near            |    30 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 64x64     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_093_Grid64_Far             |   100 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 64x64     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_094_Grid64_Angle15         |    60 cm |        15 deg | normal room light |               70% | none           | none              | auto          | 64x64     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_095_Grid64_Angle30         |    60 cm |        30 deg | normal room light |               70% | none           | none              | auto          | 64x64     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_096_Grid64_Dark            |    60 cm |         0 deg | dark              |               70% | none           | none              | auto          | 64x64     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_097_Grid64_Bright          |    60 cm |         0 deg | bright room light |               70% | none           | none              | auto          | 64x64     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_098_Grid64_Screen40        |    60 cm |         0 deg | normal room light |               40% | none           | none              | auto          | 64x64     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_099_Grid64_Screen100       |    60 cm |         0 deg | normal room light |              100% | none           | none              | auto          | 64x64     |         30 |                 30 | grid comparison   |
| [ ]  | MLCAP_100_Grid64_Opt60           |    60 cm |         0 deg | normal room light |               70% | none           | none              | auto          | 64x64     |         60 |                 60 | grid comparison   |

Start with rows 1-25 for the first quick dataset, then continue through all 100 rows for an ML-ready capture set.

## Notes

- This is for monitor-capture datasets, not random-pattern simulation.
- Glare/reflection is a dataset condition to measure, not a V1 correction feature.
- The first V1 sender preview tests can use approximate values. Later benchmark datasets should use measured values where possible.
