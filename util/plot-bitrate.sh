#!/usr/bin/env bash

# Get the frame data
ffprobe -show_frames -select_streams v -show_entries frame=pkt_pts,pkt_size,pict_type -of default=nk=1:nw=1 -i "$1" | paste -s -d '\t\t\n' - | sed -e 's/I/167116800/g' -e 's/P/65280/g' -e 's/B/255/g' > /tmp/column.dat && echo "Frame data saved in /tmp/column.dat"

# Aggregate the frame data down to the second
awk 'BEGIN {cur=0; last=0; sum=0;} {cur=int($1/1000); if (cur == last) { sum = sum + $2 } else { print last "\t" sum "\t" $3; last = cur; sum = $2; }} END { print last "\t" sum "\t" $3; }' < /tmp/column.dat > /tmp/bitrate-per-second.dat && echo "Aggregated data saved in /tmp/bitrate-per-second.dat"

filename=$(basename "$1")

# Create the gnuplot settings file
cat << EOF > /tmp/plot-bitrate.txt
set term svg enhanced mouse size 1920,1080 dynamic standalone
set title "Bitrate Analysis\n$filename"
EOF

cat << 'EOF' >> /tmp/plot-bitrate.txt
set xlabel "Second"
set ylabel "Mbits per Second"
set yrange [0:40]
set xrange [0:*]
set lmargin 12
set rmargin 6
set grid
set pointsize 2

# Calculate running average
samples(x) = x > 29 ? 30 : (x+1)

avg30(x) = (shift30(x), (back1+back2+back3+back4+back5+back6+back7+back8+back9+back10+back11+back12+back13+back14+back15+back16+back17+back18+back19+back20+back21+back22+back23+back24+back25+back26+back27+back28+back29+back30)/samples($0))

shift30(x) = (back30 = back29, back29 = back28, back28 = back27, back27 = back26, back26 = back25, back25 = back24, back24 = back23, back23 = back22, back22 = back21, back21 = back20, back20 = back19, back19 = back18, back18 = back17, back17 = back16, back16 = back15, back15 = back14, back14 = back13, back13 = back12, back12 = back11, back11 = back10, back10 = back9, back9 = back8, back8 = back7, back7 = back6, back6 = back5, back5 = back4, back4 = back3, back3 = back2, back2 = back1, back1 = x)

init(x) = (back1 = back2 = back3 = back4 = back5 = back6 = back7 = back8 = back9 = back10 = back11 = back12 = back13 = back14 = back15 = back16 = back17 = back18 = back19 = back20 = back21 = back22 = back23 = back24 = back25 = back26 = back27 = back28 = back29 = back30 = sum = x)

#plot '/tmp/bitrate-per-second.dat' using 1:($2 * 8 / 1000 ** 2) notitle with i lc rgb 255 
plot sum = init(0), \
     '/tmp/bitrate-per-second.dat' using 1:($2 * 8 / 1000 ** 2) notitle with i lc rgb 255, \
     '' using 1:(avg30(($2 * 8 / 1000 ** 2))) title "Running average over last 30 seconds" with linespoints pointinterval 30 lt 3 pt 4 ps 1.5 lw 3 lc rgb "red"
 
EOF

# Generate the plot
file="/tmp/plot.svg"

if [ -n "$2" ]; then
  file="$2"
fi

gnuplot /tmp/plot-bitrate.txt > "$file" && echo Plot written to $file
