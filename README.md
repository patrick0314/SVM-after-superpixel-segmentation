un-update edge_texture_add folder and BSDS300 folder

# SVM-after-Superpixel-Segmentation

In this paper, we proposed a new framework and successfully applied the SVM on superpixels. Finally, the experiments on BSDS300 dataset showed the effectiveness of our proposed framework.

## Usage

### Training

The file `test.m` is the code which train the 5 models for different conditions.

In the `pre-merging.m` file, we apply the traditional segmentation algorithm to slice the image into superpixels. You can modify the parameters you want in order to fit your task.

In the `SVM_seg` folder, `SVM_seg_1` to `SVM_seg_5` are the code that extract the features from the superpixel image and label the corresponding features.

After pre-processing, we put features and labels to `boost.m` to train the model. You can modify the parameter in this file to fit your task.

### Testing

You can put the image which you want to segment into the folder `test_image`. And, run the file `test.m` to apply the segmentation. The results will be in the folder `results_test`.

Besides, the file `Evaluations.txt` in the `results_test` is the evaluations of all the segmented images.

## Demo

You can run the file `demo.m`. This file use BSDS300 as the examples and the results will in the folder `results`

| original image | segmented image |
| ------ | ------ |
| ![](https://i.imgur.com/h9nGwBV.jpg) | ![](https://i.imgur.com/6tO225S.jpg) |
| ![](https://i.imgur.com/RHBzEuG.jpg) | ![](https://i.imgur.com/TqTJZJB.jpg) |
| ![](https://i.imgur.com/rx0z43y.jpg) | ![](https://i.imgur.com/dMBNWMB.jpg) |
| ![](https://i.imgur.com/XDrUPio.jpg) | ![](https://i.imgur.com/lTLAthM.jpg) |
| ![](https://i.imgur.com/eEHy73T.jpg) | ![](https://i.imgur.com/hVcWVz0.jpg) |
