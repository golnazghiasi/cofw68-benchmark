## 68 keypoint annotations for COFW test data

This repository contains manually annotated 68 keypoints for COFW
test data (original annotation of [CFOW dataset](http://www.vision.caltech.edu/xpburgos/ICCV13/)
contains 29 keypoints). The annotations are stored at "COFW68_Data/test_annotations/". For each image,
there is one .mat file which contains the location of the keypoints and their visibilities.
Also, a face bounding box for each image is stored at "COFW68_Data/cofw68_test_bboxes.mat".
These bounding boxes are calculated using similar detection method
which is used for [300-W](http://ibug.doc.ic.ac.uk/resources/300-W/) datasets. So a
landmark localization model trained on 300-W datasets can be tested on COFW68 dataset. 

##### Download COFW Images:
``` sh
 cd	COFW68_Data
 wget http://www.vision.caltech.edu/xpburgos/ICCV13/Data/COFW.zip
 unzip COFW.zip
 mv common/xpburgos/behavior/code/pose/COFW_test.mat .
```

To visualize the annotations execute "VisualizeAnnotations.m"

#### Evaluate your method

To evaluate your model, create a text file that contains the landmark localization
predictions (and their visibilities). Then specify its address and name in Main.m and
execute the Main file.
For each image there should be 4 lines in the text file. The first line should contain
the image index (in COFW_test.mat). The second, third and fouth lines should contains
x, y and occlusion state of each keypoint, respectively.

If you like to share your results with others, please send the file containing landmark
localization results to gghiasi@uci.edu and it will be added it to the "Results" directory.

##### Please cite this paper if you use this benchmark for your research paper:
[Golnaz Ghiasi, Charless Fowlkes, "Occlusion Coherence: Detecting and Localizing Occluded Faces", arXiv:1506.08347](http://arxiv.org/pdf/1506.08347.pdf)

#### Issues, Questions, etc

Please contact "gghiasi @ ics.uci.edu"

