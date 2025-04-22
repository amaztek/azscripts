#!/bin/bash

CSV1="file1.csv"   # File with 593 lines
CSV2="file2.csv"   # File with 366 lines
COLNAME="ResourceName"

# Extract headers
HEADER1=$(head -1 "$CSV1")
HEADER2=$(head -1 "$CSV2")

# Determine column index of the resource name (1-based)
get_col_index() {
  echo "$1" | awk -v colname="$COLNAME" -F',' '{
    for (i=1; i<=NF; i++) {
      if ($i == colname) {
        print i;
        break;
      }
    }
  }'
}

INDEX1=$(get_col_index "$HEADER1")
INDEX2=$(get_col_index "$HEADER2")

# Extract resource names from each file
tail -n +2 "$CSV1" | awk -F',' -v col="$INDEX1" '{print $col}' | sort > res1.txt
tail -n +2 "$CSV2" | awk -F',' -v col="$INDEX2" '{print $col}' | sort > res2.txt

# Compare to get common and unique values
comm -12 res1.txt res2.txt > both.txt
comm -23 res1.txt res2.txt > only_593.txt
comm -13 res1.txt res2.txt > only_366.txt

# Output header to all files
echo "$HEADER1" > both.csv
echo "$HEADER1" > only_593.csv
echo "$HEADER2" > only_366.csv

# Output matching rows
grep -Ff both.txt "$CSV1" >> both.csv
grep -Ff both.txt "$CSV2" >> both.csv
grep -Ff only_593.txt "$CSV1" >> only_593.csv
grep -Ff only_366.txt "$CSV2" >> only_366.csv

# Cleanup
rm res1.txt res2.txt both.txt only_593.txt only_366.txt

echo "✅ Done. Generated: both.csv, only_593.csv, only_366.csv"
