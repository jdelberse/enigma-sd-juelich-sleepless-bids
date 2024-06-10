import sys, os
import nibabel as nb
import nilearn.image as nim

sub, ses, thresh = sys.argv[1:]
root = os.getcwd()
imgfile = f"{root}/derivatives/shiva/{sub}/ses-{ses}/PVS_segmentation.nii.gz"

print(f"Found image at {imgfile}. Thresholding at {thresh}.")
img = nim.image.threshold_img(imgfile, threshold = float(thresh), copy="True")
nb.save(img,imgfile.replace('.nii.gz','_05thresh.nii.gz'))
