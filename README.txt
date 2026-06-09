tag: mitochondrial

## Mitochondrial network analysis from single motoneurons.

This method enables the analysis of mitochondrial morphology parameters, such as median mitochondrial branch length and the number of mitochondrial branches interconnected at the junctions. It can be used to analyse these parameters in individual motoneurons as we did in Figure 2 of: https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1008844

# To trace mitochondria in motoneurons, you can use this combination CCAP-Gal4>UAS-mitoGFP, where the CCAP-Gal4 driver - expressed in a small number of scattered motoneurons localised along the sides of the dorsal VNC- binds on the UAS binding sites to regulate the expression of mitoGFP - a mitochondrial matrix-targeted GFP that is based on the Cox8A MTS sequence.

Image acquisition parameters: To image CCAP-expressing motoneurons, Drosophila ventral nerve cords (VNC) are mounted without the optic lobes and with dorsal facing the coverslip. For each VNC, 5-10 neurons are captured at either the left or right VNC side. Images are acquired at 2048 px by 2048 px using a confocal microscope with a 100X objective, 2x zoom, average line 2 and speed 5. 

Image cropping: Individual motoneurons are manually cropped and saved as separate TIFF files using Fiji/ImageJ. TIFF files are named with a common name for each genotype.

Image processing: Mitochondrial network analysis is based on the Skeletonize function in Fiji/ImageJ. This function traces the trajectory of the mitochondrial branches and measures features such as the "Longest shortest path" among other parameters.

--------> RUN "Mitochondrial skeleton generation.ijm" and "Mitochondrial skeleton analysis.ijm"

# This method only works when the mitochondrial networks are well defined. It distinguishes single fragmented branches (rods), from branches interconnected at junctions. However, this method fails in the presence of mitochondrial clumps, as clumps appear as hundreds of branches interconnected.

To generate a fair representation of the mitochondrial network, first conduct a smooth processing of the images; followed by binary conversion using thresholding (Otsu method). 

The "Skeletonize" function (found in Process > Binary > Skeletonize) is then applied. This approach works fine for quantifying mitochondrial branch lengths and junctions. The alternative method "Analyze Skeleton (2D/3D)" (found in Plugin > Skeleton) is only useful for making simplified representations of the network. 

Skeletonise may occasionally fail. Instead of giving the mitochondrial network, it draws a cube with lines inside. This issue can often be resolved by inverting the LUT of the binary image. 

An effective way to validate the result of the skeletonised mitochondrial branches is to overlap the original image with the resulting skeleton. 

Once you have generated the skeletons, then run "Analyze Skeleton (2D/3D)" and save the "Branch information" and "Results" tables.

# Use R to transform these tables into:

--------> RUN "R script Branch analysis.R"

1) Median Branch length per motoneuron, calculated from the “Branch length” column in the “Branch information” table.

2) A histogram representing the proportion of interconnected branches. This histogram is calculated using a column called "#Branches" from the "Results" table. In this histogram we represent single branches (#Branches = 1, #Junctions = 0), pairs ((#Branches = 2, #Junctions = 1), and more complicated junctions built from multiple branches and up to 11 branches interconnected. Just allow only clearly defined branches and remove complex branches resulting from clumps.

