#! /usr/bin/awk -f

# Convert relion *pick.star coordinate files to eman2 box format

# Run: star2box.awk relion_pick.star box_size > coordinates.box
# The box_size argument must be an integer number and cannot be omitted.

# Check that we received box_size from command line argument
BEGIN {
    if (length(ARGV) != 3) {
        print "Wrong number of arguments. Usage:" \
            > "/dev/stderr";
        print "star2box.awk relion_pick.star box_size > coordinates.box" \
            > "/dev/stderr";
        print "box_size must be an integer number and cannot be omitted." \
            > "/dev/stderr";
        exit 1;
    }
    box_size = ARGV[2];
    delete ARGV[2];
}

# To convert relion coordinates to eman coordinates:
# 1. extract X and Y coordinates (columns 1 and 2, respectively),
# 2. subtract half the box size (eman uses the top left corner of the box as
#    coordinate, not the center like relion)
# 3. append the box size twice (this is for display of the boxes by eman2boxer
#    and similar graphical programs)
NF > 2 {
    printf("%f\t%f\t%d\t%d\n",
           $1 - box_size / 2,
           $2 - box_size / 2,
           box_size,
           box_size);
}

