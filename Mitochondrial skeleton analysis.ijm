// Clear any leftover results
run("Clear Results");

in = "/Path";
out = "/Path";

list = getFileList(dir);

setBatchMode(true);

for (i = 0; i < list.length; i++) {

    if (endsWith(list[i], ".tif") || endsWith(list[i], ".jpg") || endsWith(list[i], ".png")) {

        open(in + list[i]);

        name = replace(list[i], ".tif", "");

        print("Processing: " + name);

        // Run Analyze Skeleton.
        run("Analyze Skeleton (2D/3D)", "prune=none calculate show");

        // Save BRANCH LENGTH table.
        selectWindow("Branch information");
        saveAs("Results", out + name + "_branch_length.csv");

        // Save BRANCH JUNCTIONS.
        selectWindow("Results");
        saveAs("Results", out + name + "_branch_junctions.csv");

        // Save skeleton images.
        saveAs("Tiff", out + name + "_skeleton.tif");

        close(); 
        if (isOpen("Results")) close("Results");
        if (isOpen("Branch information")) close("Branch information");
        if (isOpen("Tagged skeleton")) close("Tagged skeleton");

    }
}

setBatchMode(false);
