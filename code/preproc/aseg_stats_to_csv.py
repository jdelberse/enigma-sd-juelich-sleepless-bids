import os
import pandas as pd

root = os.getcwd()
fs = f"{root}/derivatives/freesurfer"
specs = [(1,3), (4,11), (12,19), (20,28), (29,63), (64,71), (72,85), (86,96), (97,108), (109,118)]
names = ["Index", "SegId", "NVoxels", "Volume_mm3", "StructName",
        "normMean", "normStdDev", "normMin", "normMax", "normRange"]

for dir in os.listdir(fs):
    print(f"Processing {dir}")
    if dir=="fsaverage":
        continue
    file = f"{fs}/{dir}/stats/aseg.stats"
    stats = pd.read_fwf(file, colspecs=specs, skiprows=79, header=None, names=names)
    
    out = f"{file}.csv"
    stats.to_csv(out)
    print(f"Saved to {out}")