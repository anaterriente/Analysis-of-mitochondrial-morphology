Mitochondrial network analysis from single motoneurons

This method enables the analysis of mitochondrial morphology parameters, such as median mitochondrial branch length and the number of mitochondrial branches interconnected at each junction. It can be used to analyse individual motoneurons as we did in Figure 2 of: https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1008844

To trace mitochondria in motoneurons, we used this combination CCAP-Gal4>UAS-mitoGFP, where the CCAP-Gal4 driver is expressed in a small number of scattered motoneurons localised along the sides of the dorsal VNC. The transcriptional activity of the Gal4 driver on the UAS binding sites regulates the expression of mitoGFP, a mitochondrial matrix-targeted GFP that is based on the Cox8A MTS sequence.

Image acquisition parameters: To image CCAP-expressing motoneurons, Drosophila ventral nerve cords (VNC) were mounted without the optic lobes and with dorsal facing the coverslip. For each VNC, 5-10 neurons were captured at either the left or right VNC side. Images were acquired at 2048 px by 2048 px using a confocal microscope with a 100X objective, 2x zoom, average line 2 and speed 5. 

Image cropping: Individual motoneurons were manually cropped and saved as separate TIFF files using Fiji/ImageJ. We named these TIFF files with a common name for each genotype.

Image processing: Mitochondrial network analysis is based on the Skeletonize function in Fiji/ImageJ. This function traces the trajectory of the mitochondrial branches and measures features such as the "Longest shortest path" among other parameters.

This method only works when the mitochondrial networks are well defined. It distinguishes single fragmented branches (rods), from branches interconnected at junctions. However, this method fails in the presence of mitochondrial clumps, as clumps appear as hundreds of branches interconnected.

To generate a fair representation of the mitochondrial network, we first conduct a smooth processing of the images; followed by binary conversion using thresholding (Otsu method). 

The "Skeletonize" function (found in Process > Binary > Skeletonize) is then applied. This approach works fine for quantifying mitochondrial branch lengths and junctions. The alternative method "Analyze Skeleton (2D/3D)" (found in Plugin > Skeleton) is only useful for making simplified representations of the network. 

Skeletonise may occasionally fail. Instead of giving the mitochondrial network, it draws a cube with lines inside. This issue can often be resolved by inverting the LUT of the binary image. 

An effective way to validate the result of the skeletonised mitochondrial branches is to overlap the original image with the resulting skeleton. 

Once we have generated the skeletons, we run "Analyze Skeleton (2D/3D)" and we save the "Branch information" and "Results" tables.

Then we use R to transform these tables into:

1) Median Branch length per motoneuron, calculated from the “Branch length” column in the “Branch information” table.

2) A histogram representing the proportion of interconnected branches. This histogram is calculated using a column called "#Branches" from the "Results" table. In this histogram we represent single branches (#Branches = 1, #Junctions = 0), pairs ((#Branches = 2, #Junctions = 1), and more complicated junctions built from multiple branches and up to 11 branches interconnected. We allow only clearly defined branches and remove complex branches resulting from clumps.

