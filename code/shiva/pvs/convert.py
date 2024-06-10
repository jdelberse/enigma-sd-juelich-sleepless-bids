import os
import sys
import nibabel as nb

imgfile, maskfile = sys.argv[1:]
assert os.path.exists(imgfile), 'Input not found'
assert os.path.exists(maskfile), 'Mask not found'

img = nb.load(imgfile)
mask = nb.load(maskfile)

imgfile_new = imgfile.replace('.mgz','.nii.gz')
maskfile_new = maskfile.replace('.mgz','.nii.gz')

nb.save(img, imgfile_new)
nb.save(mask, maskfile_new)