
in = "/Path";
out = "/Path";

list = getFileList(dir);

setBatchMode(true);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".tif")) {

        open(in + list[i]);

        
        // Improve the background/noise ratio.
        run("Unsharp Mask...", "radius=10 mask=0.90 stack");
        run("Median...", "radius=3 stack");
       
       // Create binary images of the mitochondrial branches.
       setAutoThreshold("Otsu dark");
        run("Convert to Mask", "method=Otsu background=Dark calculate");
       
       // Invert LUT if the resulting skeletons show a cube with lines inside, instead of lines overlapping the mitochondrial branches.
        run("Invert LUT");
       
       // Use the function Skeletonize (found in Process > Binary > Skeletonize). This method is best to quantify mitochondrial lengths and connections. 
       // The alternative method "Analyze Skeleton (2D/3D)" (found in Plugin > Skeleton) is useful to make simplified representations. 
        run("Skeletonize");

        // Save the results.
        saveAs("Tiff", out + "processed_" + list[i]);

        close(); 
    }
}

setBatchMode(false);
