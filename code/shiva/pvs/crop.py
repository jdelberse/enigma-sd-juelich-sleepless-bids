import os
import sys
import numpy as np
import nibabel as nb
import scipy.ndimage as ndim

imgfile, maskfile = sys.argv[1:]
assert os.path.exists(imgfile), 'Input not found'
assert os.path.exists(maskfile), 'Mask not found'

# Cropping function
def crop_cm(img, mask, size):
	mask_array = np.array(mask.dataobj) # Set mask object to ndarray
	cm = ndim.center_of_mass(mask_array) # Find the center of mass
	cm = [round(val) for val in cm] # Round the values
	
	dim = np.zeros([3,2], dtype = 'int')
	for i in [0,1,2]:
		dim[i,0] = int(cm[i]-size[i]/2)
		dim[i,1] = int(cm[i]+size[i]/2)
		
		if dim[i,0] < 0:
			dim[i,:] = dim[i,:]-dim[i,0]
		if dim[i,1] > 256:
			dim[i,:] = dim[i,:]-(dim[i,1]-256)
	
	img_crop = img.slicer[dim[0,0]:dim[0,1],dim[1,0]:dim[1,1],dim[2,0]:dim[2,1]]
	return img_crop

# Load image
img = nb.load(imgfile)
mask = nb.load(maskfile)

# Cropping
img_crop = crop_cm(img, mask, (160,214,176)) # Crop around mask center of mass

# Save
imgfile = imgfile.replace(".nii.gz", "_cropped.nii.gz")

nb.save(img_crop, imgfile)