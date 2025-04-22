#!/bin/bash

# Input files
CSV1="file1.csv"
CSV2="file2.csv"

# Temp files
CSV1_RESOURCES="res1.txt"
CSV2_RESOURCES="res2.txt"

# Output Excel
OUTPUT="compare.xlsx"

# Column name to compare
COLUMN="ResourceName"

# Extract headers
HEADER=$(head -n 1 "$CSV1")

# Extract resource names
csvcut -c "$COLUMN" "$CSV1" | tail -n +2 | sort > "$CSV1_RESOURCES"
csvcut -c "$COLUMN" "$CSV2" | tail -n +2 | sort > "$CSV2_RESOURCES"

# Compare
comm -12 "$CSV1_RESOURCES" "$CSV2_RESOURCES" > both.txt
comm -23 "$CSV1_RESOURCES" "$CSV2_RESOURCES" > only_593.txt
comm -13 "$CSV1_RESOURCES" "$CSV2_RESOURCES" > only_366.txt

# Use Python to filter original CSVs and write output
python3 <<EOF
import pandas as pd

# Load original CSVs
df1 = pd.read_csv("$CSV1")
df2 = pd.read_csv("$CSV2")

# Load lists
both = set(open("both.txt").read().splitlines())
only_593 = set(open("only_593.txt").read().splitlines())
only_366 = set(open("only_366.txt").read().splitlines())

# Column to match
col = "$COLUMN"

# Filter rows
df_both = pd.concat([
    df1[df1[col].isin(both)],
    df2[df2[col].isin(both)]
])

df_593 = df1[df1[col].isin(only_593)]
df_366 = df2[df2[col].isin(only_366)]

# Write to Excel with 3 sheets
with pd.ExcelWriter("$OUTPUT", engine='xlsxwriter') as writer:
    df_both.to_excel(writer, sheet_name='both', index=False)
    df_593.to_excel(writer, sheet_name='593', index=False)
    df_366.to_excel(writer, sheet_name='366', index=False)
EOF

# Cleanup
rm "$CSV1_RESOURCES" "$CSV2_RESOURCES" both.txt only_593.txt only_366.txt

echo "Comparison completed. Output saved to $OUTPUT"
