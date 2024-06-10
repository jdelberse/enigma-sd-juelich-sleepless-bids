import sys
#I cannot believe I have to do this in python
pvsv, icv = sys.argv[1:]
pvsvf = int(pvsv) / int(float(icv))
sys.exit(pvsvf)

