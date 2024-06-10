import os
import sys
import nibabel as nb
from nibabel import processing
from nilearn import masking

imgfile, maskfile = sys.argv[1:]
assert os.path.exists(imgfile), 'Image not found'
assert os.path.exists(maskfile), 'Mask not found'

# Load image
img = nb.load(imgfile)
mask = nb.load(maskfile)

# Conformation
img_conf = nb.processing.conform( # Conform the image
    from_img = img,
    #out_shape=(160,214,176), # To the desired shape
    voxel_size=(1.0,1.0,1.0), # With the desired voxel size
    orientation="RAS") # TODO: Is this the right orientation?
    
mask_conf = nb.processing.conform( # Conform the image
    from_img = mask,
    #out_shape=(160,214,176), # To the desired shape
    voxel_size=(1.0,1.0,1.0), # With the desired voxel size
    orientation="RAS") # TODO: Is this the right orientation?
    
# Save
imgfile = imgfile.replace(".nii.gz", "_resampled.nii.gz")
maskfile = maskfile.replace(".nii.gz", "_resampled.nii.gz")
   
nb.save(img_conf, imgfile)
nb.save(mask_conf, maskfile)